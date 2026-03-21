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

  /// Main entry point — admin calls this after uploading student data
  Future<void> generateSeatingPlan(String examDate) async {
    try {
      // 1. Fetch exams scheduled for this date
      final examsQuery = await _firestore
          .collection('exams')
          .where('examDate', isEqualTo: examDate)
          .get();

      if (examsQuery.docs.isEmpty) {
        throw const SeatingGenerationException('No exams found for this date');
      }

      // 2. Fetch student registrations under each exam document
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

      // 2. Fetch available halls
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
          'rows': data['rows'] as int,
          'columns': data['columns'] as int,
        };
      }).toList();

      // 3. Sort halls by capacity (largest first)
      halls.sort((a, b) => (b['capacity'] as int).compareTo(a['capacity'] as int));

      // 4. Allocate students to halls
      int studentIndex = 0;
      int totalAllocated = 0;
      final seatingPlanRef = _firestore.collection('seatingPlans').doc(examDate);

      WriteBatch batch = _firestore.batch();

      for (final hall in halls) {
        if (studentIndex >= studentRegNos.length) break;

        final hallCapacity = hall['capacity'] as int;
        final rows = hall['rows'] as int;
        final columns = hall['columns'] as int;
        final hallCode = hall['code'] as String;

        // Create hall document
        final hallRef = seatingPlanRef.collection('halls').doc(hallCode);
        batch.set(hallRef, {
          'hallCode': hallCode,
          'hallName': hall['name'],
          'block': hall['block'],
          'capacity': hallCapacity,
          'allocatedSeats': 0,
          'rows': rows,
          'columns': columns,
        });

        // Allocate students to seats
        int seatNumber = 1;
        int allocatedInHall = 0;

        for (int row = 1; row <= rows && studentIndex < studentRegNos.length; row++) {
          for (int col = 1; col <= columns && studentIndex < studentRegNos.length; col++) {
            if (allocatedInHall >= hallCapacity) break;

            final regNo = studentRegNos[studentIndex];
            final seatCode = '${String.fromCharCode(64 + row)}$col';

            // Create seat allocation
            final seatRef = hallRef.collection('seats').doc(seatCode);
            batch.set(seatRef, {
              'registerNumber': regNo,
              'seatNumber': seatNumber,
              'row': row,
              'column': col,
              'seatCode': seatCode,
              'hallCode': hallCode,
              'hallName': hall['name'],
              'examDate': examDate,
              'allocatedAt': FieldValue.serverTimestamp(),
            });

            // Create student notification - save to student's seatAllocations subcollection
            final studentSeatRef = _firestore
                .collection('students')
                .doc(regNo)
                .collection('seatAllocations')
                .doc(examDate);

            batch.set(studentSeatRef, {
              'examDate': examDate,
              'hallCode': hallCode,
              'hallName': hall['name'],
              'block': hall['block'],
              'seatCode': seatCode,
              'seatNumber': seatNumber,
              'row': row,
              'column': col,
              'notified': true,
              'notifiedAt': FieldValue.serverTimestamp(),
            });

            seatNumber++;
            allocatedInHall++;
            studentIndex++;
            totalAllocated++;

            if (studentIndex % 500 == 0) {
              await batch.commit();
              batch = _firestore.batch();
            }
          }
        }

        // Update hall allocated seats
        batch.update(hallRef, {'allocatedSeats': allocatedInHall});
      }

      // Create seating plan summary
      batch.set(seatingPlanRef, {
        'examDate': examDate,
        'totalStudents': studentRegNos.length,
        'totalAllocated': totalAllocated,
        'totalHalls': halls.length,
        'generatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
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