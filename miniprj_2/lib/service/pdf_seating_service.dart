import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PdfSeatingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generate and download PDF for seating arrangement of a specific exam date
  Future<void> generateSeatingPdf(String examDate) async {
    try {
      print('📄 Starting PDF generation for date: $examDate');
      
      // Fetch seating plan data
      final planDoc = await _firestore
          .collection('seatingPlans')
          .doc(examDate)
          .get();

      if (!planDoc.exists) {
        throw Exception('❌ Seating plan not found for date: $examDate\n\nPlease generate the seating arrangement first from Admin Dashboard.');
      }

      final planData = planDoc.data()!;
      print('✓ Seating plan found. Total halls: ${planData['totalHalls']}');

      // Fetch all halls and their seat allocations
      final hallsSnapshot = await _firestore
          .collection('seatingPlans')
          .doc(examDate)
          .collection('halls')
          .orderBy('hallCode')
          .get();

      if (hallsSnapshot.docs.isEmpty) {
        throw Exception('❌ No halls found in seating plan\n\nPlease ensure seating arrangement includes hall data.');
      }

      print('✓ Found ${hallsSnapshot.docs.length} halls');

      // Build seating data for each hall
      final hallsSeatingData = <Map<String, dynamic>>[];

      for (final hallDoc in hallsSnapshot.docs) {
        final hallData = hallDoc.data();
        final hallCode = hallData['hallCode'] as String;

        // Fetch all seats for this hall
        final seatsSnapshot = await _firestore
            .collection('seatingPlans')
            .doc(examDate)
            .collection('halls')
            .doc(hallCode)
            .collection('seats')
            .get();

        final seats = <Map<String, dynamic>>[];
        for (final seatDoc in seatsSnapshot.docs) {
          final seatData = seatDoc.data();
          
          // Fetch student details for this seat
          final studentRegNo = seatData['registerNumber'] as String?;
          String studentName = 'Unallocated';
          String studentEmail = 'N/A';

          if (studentRegNo != null && studentRegNo.isNotEmpty) {
            try {
              final studentDoc = await _firestore
                  .collection('students')
                  .doc(studentRegNo)
                  .get();

              if (studentDoc.exists) {
                final studentData = studentDoc.data()!;
                studentName = studentData['name'] ?? 'Unknown';
                studentEmail = studentData['email'] ?? 'N/A';
              }
            } catch (e) {
              print('Error fetching student data: $e');
            }
          }

          seats.add({
            'seatCode': seatData['seatCode'] ?? seatDoc.id,
            'row': seatData['row'] ?? 0,
            'column': seatData['column'] ?? 0,
            'registerNumber': studentRegNo ?? 'Empty',
            'studentName': studentName,
            'studentEmail': studentEmail,
          });
        }

        // Sort seats by row then column (in code instead of Firestore)
        seats.sort((a, b) {
          final rowCompare = (a['row'] as int).compareTo(b['row'] as int);
          if (rowCompare != 0) return rowCompare;
          return (a['column'] as int).compareTo(b['column'] as int);
        });        hallsSeatingData.add({
          'hallCode': hallCode,
          'hallName': hallData['hallName'] ?? 'Unknown Hall',
          'capacity': hallData['capacity'] ?? 0,
          'allocatedSeats': hallData['allocatedSeats'] ?? 0,
          'rows': hallData['rows'] ?? 0,
          'columns': hallData['columns'] ?? 0,
          'block': hallData['block'] ?? 'N/A',
          'seats': seats,
        });
      }

      // Generate PDF
      final pdf = pw.Document();

      // Add title page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'SEATING ARRANGEMENT REPORT',
                  style: pw.TextStyle(
                    fontSize: 32,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Examination Date: $examDate',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 30),
                pw.Divider(),
                pw.SizedBox(height: 30),
                pw.Text(
                  'Summary',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 15),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text(
                          'Total Halls',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          '${hallsSeatingData.length}',
                          style: pw.TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text(
                          'Total Students',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          '${planData['totalStudents'] ?? 0}',
                          style: pw.TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text(
                          'Total Allocated',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          '${planData['totalAllocated'] ?? 0}',
                          style: pw.TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Text(
                  'Generated: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey,
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Add detailed pages for each hall
      for (final hall in hallsSeatingData) {
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '${hall['hallName']} (${hall['hallCode']})',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Block: ${hall['block']} | Capacity: ${hall['capacity']} | Allocated: ${hall['allocatedSeats']}',
                    style: pw.TextStyle(fontSize: 11, color: PdfColors.grey),
                  ),
                  pw.SizedBox(height: 15),
                  pw.Divider(),
                  pw.SizedBox(height: 15),
                  _buildSeatingGrid(hall),
                  pw.SizedBox(height: 20),
                  _buildDetailedSeatingList(hall),
                ],
              );
            },
          ),
        );
      }

      // Open print dialog
      try {
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save(),
          name: 'Seating_Arrangement_$examDate.pdf',
        );
      } catch (e) {
        // If layoutPdf fails, try direct save/share as fallback
        print('Printing.layoutPdf failed: $e');
        try {
          // Try to share the PDF instead
          final pdfBytes = await pdf.save();
          await Printing.sharePdf(
            bytes: pdfBytes,
            filename: 'Seating_Arrangement_$examDate.pdf',
          );
        } catch (shareError) {
          print('Share PDF failed: $shareError');
          throw Exception('Could not open or share PDF: $shareError');
        }
      }
    } catch (e) {
      throw Exception('Error generating PDF: $e');
    }
  }

  /// Build visual seating grid for a hall - BENCH LAYOUT
  pw.Widget _buildSeatingGrid(Map<String, dynamic> hall) {
    final benches = hall['rows'] as int; // 8 benches
    final columns = hall['columns'] as int; // 3 columns
    final seats = hall['seats'] as List<Map<String, dynamic>>;

    final gridItems = <pw.Widget>[];

    // Add header
    gridItems.add(
      pw.Text(
        'Bench Layout (${benches} benches × $columns columns, 2 students per bench):',
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );

    gridItems.add(pw.SizedBox(height: 12));

    // Build bench layout table
    final tableRows = <pw.TableRow>[];

    // Header row
    tableRows.add(
      pw.TableRow(
        decoration: pw.BoxDecoration(color: PdfColors.grey300),
        children: [
          _buildHeaderCell('Bench'),
          _buildHeaderCell('A'),
          _buildHeaderCell('B'),
          _buildHeaderCell('C'),
          _buildHeaderCell('D'),
          _buildHeaderCell('E'),
          _buildHeaderCell('F'),
        ],
      ),
    );

    // Bench rows
    for (int bench = 1; bench <= benches; bench++) {
      final cells = <pw.Widget>[
        _buildDataCell('B${bench}'), // Bench number
      ];

      // For each column
      for (int col = 1; col <= columns; col++) {
        // LEFT position
        final leftCode = '${String.fromCharCode(64 + bench)}${col}-L';
        final leftSeat = seats.firstWhere(
          (s) => s['seatCode'] == leftCode,
          orElse: () => {'registerNumber': '-', 'studentEmail': '-'},
        );
        // Extract email prefix (everything before @gecskp.ac.in)
        final leftEmailPrefix = _extractEmailPrefix(leftSeat['studentEmail'] ?? '-');
        cells.add(_buildDataCell(leftEmailPrefix));

        // RIGHT position
        final rightCode = '${String.fromCharCode(64 + bench)}${col}-R';
        final rightSeat = seats.firstWhere(
          (s) => s['seatCode'] == rightCode,
          orElse: () => {'registerNumber': '-', 'studentEmail': '-'},
        );
        // Extract email prefix (everything before @gecskp.ac.in)
        final rightEmailPrefix = _extractEmailPrefix(rightSeat['studentEmail'] ?? '-');
        cells.add(_buildDataCell(rightEmailPrefix));
      }

      tableRows.add(
        pw.TableRow(
          children: cells,
          decoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.grey200),
            ),
          ),
        ),
      );
    }

    gridItems.add(
      pw.Table(
        border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
        columnWidths: {
          0: pw.FixedColumnWidth(25),
          1: pw.FixedColumnWidth(30),
          2: pw.FixedColumnWidth(30),
          3: pw.FixedColumnWidth(30),
          4: pw.FixedColumnWidth(30),
          5: pw.FixedColumnWidth(30),
          6: pw.FixedColumnWidth(30),
        },
        children: tableRows,
      ),
    );

    gridItems.add(pw.SizedBox(height: 10));
    gridItems.add(
      pw.Text(
        'Legend: B1-B8 = Bench numbers, Col 1-3 = Columns, LEFT/RIGHT = Student positions',
        style: pw.TextStyle(fontSize: 8, color: PdfColors.grey),
      ),
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: gridItems,
    );
  }

  /// Helper to build header cell
  pw.Widget _buildHeaderCell(String text) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(3),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  /// Helper to build data cell
  pw.Widget _buildDataCell(String text) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(2),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 7),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  /// Extract email prefix (pkdYYdeptXXX) from full email
  /// Example: pkd23cs001@gecskp.ac.in → pkd23cs001
  String _extractEmailPrefix(String email) {
    if (email == '-' || email == 'N/A' || email.isEmpty) {
      return '-';
    }
    try {
      final parts = email.split('@');
      return parts[0]; // Return everything before @
    } catch (e) {
      return '-';
    }
  }

  /// Build detailed seating list for a hall
  /// Build detailed seating list for a hall
  pw.Widget _buildDetailedSeatingList(Map<String, dynamic> hall) {
    final seats = (hall['seats'] as List<Map<String, dynamic>>)
        .where((s) => s['registerNumber'] != 'Empty' && s['registerNumber'] != 'Unallocated')
        .toList();

    if (seats.isEmpty) {
      return pw.Text(
        'No students allocated to this hall',
        style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
      );
    }

    final rows = <pw.TableRow>[];

    // Header row
    rows.add(
      pw.TableRow(
        decoration: pw.BoxDecoration(color: PdfColors.grey300),
        children: [
          pw.Padding(
            padding: pw.EdgeInsets.all(5),
            child: pw.Text(
              'Seat',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.all(5),
            child: pw.Text(
              'Register No.',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.all(5),
            child: pw.Text(
              'Student Name',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.all(5),
            child: pw.Text(
              'Email',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
        ],
      ),
    );

    // Data rows
    for (final seat in seats) {
      rows.add(
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.all(5),
              child: pw.Text(
                '${seat['seatCode']}',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.all(5),
              child: pw.Text(
                '${seat['registerNumber']}',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.all(5),
              child: pw.Text(
                '${seat['studentName']}',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.all(5),
              child: pw.Text(
                '${seat['studentEmail']}',
                style: pw.TextStyle(fontSize: 8),
              ),
            ),
          ],
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Detailed Seating List (${seats.length} students):',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(),
          columnWidths: {
            0: pw.FixedColumnWidth(35),
            1: pw.FixedColumnWidth(60),
            2: pw.FlexColumnWidth(1),
            3: pw.FlexColumnWidth(1.2),
          },
          children: rows,
        ),
      ],
    );
  }
}
