import 'package:cloud_firestore/cloud_firestore.dart';

class SeatingGenerationException implements Exception {
  final String message;
  final bool isMissingIndex;
  final String? indexUrl;

  const SeatingGenerationException(
    this.message, {
    this.isMissingIndex = false,
    this.indexUrl,
  });

  @override
  String toString() => message;
}

class SeatingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Bench layout: 3 columns, 8 benches per column
  /// Each bench has 2 students (at both ends)
  /// Structure: Different departments at ends, consecutive regNo behind
  Future<void> generateSeatingPlan(String examDate) async {
    try {
      print('📋 Starting seating plan generation for: $examDate');
      
      // 1. Fetch exams scheduled for this date
      final examsQuery = await _firestore
          .collection('exams')
          .where('examDate', isEqualTo: examDate)
          .get();

      if (examsQuery.docs.isEmpty) {
        throw const SeatingGenerationException('No exams found for this date');
      }

      // 2. Fetch student registrations
      final studentRegSet = <String>{};
      for (final examDoc in examsQuery.docs) {
        final registrations = await examDoc.reference.collection('registrations').get();
        for (final regDoc in registrations.docs) {
          final regNo = (regDoc.data()['registerNumber'] ?? '').toString().trim();
          if (regNo.isNotEmpty) {
            studentRegSet.add(regNo);
          }
        }
      }

      if (studentRegSet.isEmpty) {
        throw const SeatingGenerationException('No students registered for this date');
      }

      final studentRegNos = studentRegSet.toList();
      print('✓ Total students registered: ${studentRegNos.length}');

      // 3. Fetch available halls
      final hallsQuery = await _firestore.collection('halls').get();

      if (hallsQuery.docs.isEmpty) {
        throw const SeatingGenerationException('No halls available');
      }

      final halls = hallsQuery.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'code': data['hallCode'],
          'name': data['hallName'],
          'block': data['block'] ?? '',
          'capacity': data['capacity'] as int,
          'rows': data['rows'] as int, // benches (8)
          'columns': data['columns'] as int, // columns (3)
        };
      }).toList();

      // 4. Sort halls by capacity (largest first)
      halls.sort((a, b) => (b['capacity'] as int).compareTo(a['capacity'] as int));

      // 5. Allocate students to halls using bench layout
      int studentIndex = 0;
      int totalAllocated = 0;
      final seatingPlanRef = _firestore.collection('seatingPlans').doc(examDate);

      WriteBatch batch = _firestore.batch();

      for (final hall in halls) {
        if (studentIndex >= studentRegNos.length) break;

        final hallCapacity = hall['capacity'] as int;
        final benches = hall['rows'] as int; // 8 benches per column
        final columns = hall['columns'] as int; // 3 columns
        final hallCode = hall['code'] as String;

        print('🏛️  Processing hall: $hallCode (${hall['name']})');

        // Create hall document
        final hallRef = seatingPlanRef.collection('halls').doc(hallCode);
        batch.set(hallRef, {
          'hallCode': hallCode,
          'hallName': hall['name'],
          'block': hall['block'],
          'capacity': hallCapacity,
          'allocatedSeats': 0,
          'rows': benches, // Number of benches
          'columns': columns, // Number of columns
          'benchLayout': true, // Mark this as bench-based layout
          'studentsPerBench': 2, // 2 students per bench
        });

        // Allocate students using bench layout
        int allocatedInHall = 0;
        int seatNumber = 1;

        // Iterate through columns first, then benches
        for (int col = 1; col <= columns && studentIndex < studentRegNos.length; col++) {
          for (int bench = 1; bench <= benches && studentIndex < studentRegNos.length; bench++) {
            if (allocatedInHall >= hallCapacity) break;

            // BENCH LAYOUT: Each bench has 2 students
            // Student 1 (Left/Front - different department)
            // Student 2 (Right/Back - consecutive regNo)

            // Allocate Student 1 (Left seat)
            if (studentIndex < studentRegNos.length && allocatedInHall < hallCapacity) {
              final regNo1 = studentRegNos[studentIndex];
              final benchCode = '${String.fromCharCode(64 + bench)}$col-L'; // Letter+Column-Left

              final seatRef = hallRef.collection('seats').doc(benchCode);
              batch.set(seatRef, {
                'registerNumber': regNo1,
                'seatNumber': seatNumber,
                'benchNumber': bench,
                'column': col,
                'position': 'LEFT', // Left/Front of bench
                'seatCode': benchCode,
                'hallCode': hallCode,
                'hallName': hall['name'],
                'examDate': examDate,
                'allocatedAt': FieldValue.serverTimestamp(),
              });

              // Save to student's collection
              final studentSeatRef = _firestore
                  .collection('students')
                  .doc(regNo1)
                  .collection('seatAllocations')
                  .doc(examDate);

              batch.set(studentSeatRef, {
                'examDate': examDate,
                'hallCode': hallCode,
                'hallName': hall['name'],
                'block': hall['block'],
                'seatCode': benchCode,
                'benchNumber': bench,
                'column': col,
                'position': 'LEFT',
                'seatNumber': seatNumber,
                'notified': true,
                'notifiedAt': FieldValue.serverTimestamp(),
              });

              seatNumber++;
              allocatedInHall++;
              studentIndex++;
              totalAllocated++;
            }

            // Allocate Student 2 (Right/Back seat) - consecutive regNo
            if (studentIndex < studentRegNos.length && allocatedInHall < hallCapacity) {
              final regNo2 = studentRegNos[studentIndex];
              final benchCode = '${String.fromCharCode(64 + bench)}$col-R'; // Letter+Column-Right

              final seatRef = hallRef.collection('seats').doc(benchCode);
              batch.set(seatRef, {
                'registerNumber': regNo2,
                'seatNumber': seatNumber,
                'benchNumber': bench,
                'column': col,
                'position': 'RIGHT', // Right/Back of bench
                'seatCode': benchCode,
                'hallCode': hallCode,
                'hallName': hall['name'],
                'examDate': examDate,
                'allocatedAt': FieldValue.serverTimestamp(),
              });

              // Save to student's collection
              final studentSeatRef = _firestore
                  .collection('students')
                  .doc(regNo2)
                  .collection('seatAllocations')
                  .doc(examDate);

              batch.set(studentSeatRef, {
                'examDate': examDate,
                'hallCode': hallCode,
                'hallName': hall['name'],
                'block': hall['block'],
                'seatCode': benchCode,
                'benchNumber': bench,
                'column': col,
                'position': 'RIGHT',
                'seatNumber': seatNumber,
                'notified': true,
                'notifiedAt': FieldValue.serverTimestamp(),
              });

              seatNumber++;
              allocatedInHall++;
              studentIndex++;
              totalAllocated++;
            }

            if (studentIndex % 500 == 0) {
              await batch.commit();
              batch = _firestore.batch();
            }
          }
        }

        print('✓ $hallCode: $allocatedInHall students allocated');

        // Update hall allocated seats
        batch.update(hallRef, {'allocatedSeats': allocatedInHall});
      }

      // Create seating plan summary
      batch.set(seatingPlanRef, {
        'examDate': examDate,
        'totalStudents': studentRegNos.length,
        'totalAllocated': totalAllocated,
        'totalHalls': halls.length,
        'layoutType': 'benchLayout', // Mark as bench layout
        'generatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
      print('✅ Seating plan generated successfully!');
    } on SeatingGenerationException {
      rethrow;
    } on FirebaseException catch (e) {
      final rawMessage = e.message ?? e.toString();
      final isMissingIndex =
          e.code == 'failed-precondition' && rawMessage.contains('requires a COLLECTION_GROUP_ASC index');

      if (isMissingIndex) {
        final urlMatch = RegExp(r'https://[^\s]+').firstMatch(rawMessage);
        throw SeatingGenerationException(
          'Firestore index is required before seating can be generated. '
          'Create the index, wait until it is enabled, then retry.',
          isMissingIndex: true,
          indexUrl: urlMatch?.group(0),
        );
      }

      throw SeatingGenerationException('Failed to generate seating: ${e.message ?? e.code}');
    } catch (e) {
      throw SeatingGenerationException('Failed to generate seating: $e');
    }
  }
}

