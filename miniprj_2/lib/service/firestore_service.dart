import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  // ── STUDENT ──────────────────────────────────────────

  Future<Map<String, dynamic>> getStudentProfile() async {
    final doc = await _db.collection('users').doc(_uid).get();
    return doc.data() ?? {};
  }

  Future<List<Map<String, dynamic>>> getMySeats() async {
    final userDoc = await _db.collection('users').doc(_uid).get();
    final regNo = userDoc['registerNumber'];

    List<Map<String, dynamic>> results = [];
    final plans = await _db.collection('seatingPlans').get();

    for (final plan in plans.docs) {
      final halls = await plan.reference.collection('halls').get();
      for (final hall in halls.docs) {
        final seats = await hall.reference
            .collection('seats')
            .where('registerNumber', isEqualTo: regNo)
            .get();
        for (final seat in seats.docs) {
          results.add({
            ...seat.data(),
            'hallName': hall['hallName'],
            'examDate': plan.id,
          });
        }
      }
    }
    return results;
  }

  Stream<List<Map<String, dynamic>>> getStudentNotifications() {
    return _db
        .collection('notifications')
        .where('targetRole', whereIn: ['student', 'all'])
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs
        .map((d) => {...d.data(), 'id': d.id})
        .toList());
  }

  Future<void> submitMedicalRequest({
    required String subjectCode,
    required String reason,
  }) async {
    final userDoc = await _db.collection('users').doc(_uid).get();
    await _db.collection('medicalRequests').add({
      'studentUid': _uid,
      'registerNumber': userDoc['registerNumber'],
      'studentName': userDoc['name'],
      'subjectCode': subjectCode,
      'reason': reason,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ── ADMIN ─────────────────────────────────────────────

  Future<void> uploadStudents(List<Map<String, dynamic>> students) async {
    final batch = _db.batch();
    for (final student in students) {
      final ref = _db
          .collection('students')
          .doc(student['registerNumber']);
      batch.set(ref, student, SetOptions(merge: true));
    }
    await batch.commit();
  }

  Stream<List<Map<String, dynamic>>> getMedicalRequests() {
    return _db
        .collection('medicalRequests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs
        .map((d) => {...d.data(), 'id': d.id})
        .toList());
  }

  Future<void> updateMedicalStatus(String requestId, String status) async {
    await _db
        .collection('medicalRequests')
        .doc(requestId)
        .update({
      'status': status,
      'reviewedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendNotification({
    required String title,
    required String body,
    required String targetRole,
  }) async {
    await _db.collection('notifications').add({
      'title': title,
      'body': body,
      'targetRole': targetRole,
      'sentBy': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
