# Firebase Code Examples for Exam Seating System

## 1. Authentication Service

Create a file: `lib/services/auth_service.dart`

```dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up
  Future<String?> signUp({
    required String email,
    required String password,
    required String role, // 'student', 'admin', 'invigilator'
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Save additional user data to Firestore
      // (see Firestore example below)
      
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  // Sign in
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Check if user is logged in
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }
}
```

---

## 2. Firestore Database Service

Create a file: `lib/services/firestore_service.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add user profile to Firestore
  Future<void> addUserProfile({
    required String uid,
    required String email,
    required String name,
    required String role, // 'student', 'admin', 'invigilator'
  }) async {
    try {
      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding user profile: $e');
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Create new exam
  Future<String?> createExam({
    required String name,
    required DateTime date,
    required int totalStudents,
    required int hallCount,
  }) async {
    try {
      final docRef = await _db.collection('exams').add({
        'name': name,
        'date': date,
        'totalStudents': totalStudents,
        'hallCount': hallCount,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'upcoming', // upcoming, ongoing, completed
      });
      return docRef.id;
    } catch (e) {
      print('Error creating exam: $e');
      return null;
    }
  }

  // Get all exams
  Future<List<Map<String, dynamic>>> getAllExams() async {
    try {
      final snapshot = await _db.collection('exams').get();
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e) {
      print('Error getting exams: $e');
      return [];
    }
  }

  // Stream exams (real-time updates)
  Stream<List<Map<String, dynamic>>> streamExams() {
    return _db.collection('exams').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    });
  }

  // Add seat allocation
  Future<void> addSeatAllocation({
    required String examId,
    required String studentId,
    required String hallNumber,
    required String seatNumber,
  }) async {
    try {
      await _db
          .collection('exams')
          .doc(examId)
          .collection('seats')
          .doc(studentId)
          .set({
        'studentId': studentId,
        'hallNumber': hallNumber,
        'seatNumber': seatNumber,
        'allocatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding seat allocation: $e');
    }
  }

  // Get seat allocation for student
  Future<Map<String, dynamic>?> getStudentSeat({
    required String examId,
    required String studentId,
  }) async {
    try {
      final doc = await _db
          .collection('exams')
          .doc(examId)
          .collection('seats')
          .doc(studentId)
          .get();
      return doc.data();
    } catch (e) {
      print('Error getting student seat: $e');
      return null;
    }
  }

  // Add medical request
  Future<void> addMedicalRequest({
    required String studentId,
    required String examId,
    required String reason,
    required String requestDetails,
  }) async {
    try {
      await _db.collection('medicalRequests').add({
        'studentId': studentId,
        'examId': examId,
        'reason': reason,
        'requestDetails': requestDetails,
        'status': 'pending', // pending, approved, rejected
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding medical request: $e');
    }
  }

  // Get medical requests for admin
  Future<List<Map<String, dynamic>>> getMedicalRequests({
    String? status,
  }) async {
    try {
      Query query = _db.collection('medicalRequests');
      
      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }
      
      final snapshot = await query.get();
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      }).toList();
    } catch (e) {
      print('Error getting medical requests: $e');
      return [];
    }
  }

  // Send notification
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
    required String type, // exam, medical, seat, general
  }) async {
    try {
      await _db.collection('notifications').add({
        'userId': userId,
        'title': title,
        'message': message,
        'type': type,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  // Stream user notifications
  Stream<List<Map<String, dynamic>>> streamUserNotifications(String userId) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    });
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _db.collection('notifications').doc(notificationId).update({
        'read': true,
      });
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // Update exam status
  Future<void> updateExamStatus(String examId, String status) async {
    try {
      await _db.collection('exams').doc(examId).update({
        'status': status,
      });
    } catch (e) {
      print('Error updating exam status: $e');
    }
  }
}
```

---

## 3. Storage Service (Hall Tickets, Documents)

Create a file: `lib/services/storage_service.dart`

```dart
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload hall ticket
  Future<String?> uploadHallTicket({
    required File file,
    required String studentId,
    required String examId,
  }) async {
    try {
      final ref = _storage
          .ref('hall_tickets')
          .child(examId)
          .child('$studentId.pdf');
      
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error uploading hall ticket: $e');
      return null;
    }
  }

  // Download hall ticket
  Future<List<int>?> downloadHallTicket({
    required String studentId,
    required String examId,
  }) async {
    try {
      final ref = _storage
          .ref('hall_tickets')
          .child(examId)
          .child('$studentId.pdf');
      
      final data = await ref.getData();
      return data;
    } catch (e) {
      print('Error downloading hall ticket: $e');
      return null;
    }
  }

  // Upload seating arrangement document
  Future<String?> uploadSeatingArrangement({
    required File file,
    required String examId,
  }) async {
    try {
      final ref = _storage
          .ref('seating_arrangements')
          .child('$examId.pdf');
      
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error uploading seating arrangement: $e');
      return null;
    }
  }

  // Get file download URL
  Future<String?> getDownloadURL({
    required String path,
  }) async {
    try {
      final url = await _storage.ref(path).getDownloadURL();
      return url;
    } catch (e) {
      print('Error getting download URL: $e');
      return null;
    }
  }

  // Delete file
  Future<bool> deleteFile({
    required String path,
  }) async {
    try {
      await _storage.ref(path).delete();
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }
}
```

---

## 4. Usage in Widgets

### Example: Login Page with Firebase Auth

```dart
import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void _handleLogin() async {
    setState(() => isLoading = true);
    
    final success = await _authService.signIn(
      email: emailController.text,
      password: passwordController.text,
    );
    
    if (success) {
      // Get user role and navigate
      final user = _authService.getCurrentUser();
      final profile = await _firestoreService.getUserProfile(user!.uid);
      
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(
          '/role_${profile?['role'] ?? 'student'}',
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    }
    
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : _handleLogin,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Example: Display Exams with Real-time Updates

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/firestore_service.dart';

class ExamsListPage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firestoreService.streamExams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final exams = snapshot.data ?? [];

        return ListView.builder(
          itemCount: exams.length,
          itemBuilder: (context, index) {
            final exam = exams[index];
            return ListTile(
              title: Text(exam['name']),
              subtitle: Text(
                'Date: ${exam['date']?.toDate()}\nTotal Students: ${exam['totalStudents']}',
              ),
            );
          },
        );
      },
    );
  }
}
```

---

## 5. Firestore Security Rules

Go to Firebase Console → Firestore → Rules and add:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users can only read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Students can read all exams
    match /exams/{examId} {
      allow read: if request.auth != null;
      allow write: if isAdmin();
      
      // Students can read their own seat allocation
      match /seats/{studentId} {
        allow read: if request.auth.uid == studentId || isAdmin();
        allow write: if isAdmin();
      }
    }
    
    // Medical requests
    match /medicalRequests/{requestId} {
      allow create: if isStudent();
      allow read, update: if isAdmin() || request.auth.uid == resource.data.studentId;
    }
    
    // Notifications
    match /notifications/{notificationId} {
      allow read, update: if request.auth.uid == resource.data.userId;
      allow create, write: if isAdmin();
    }
    
    // Helper functions
    function isAdmin() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    function isStudent() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'student';
    }
  }
}
```

---

## 6. Initialize Services in main.dart

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/storage_service.dart';

// Global service instances
final authService = AuthService();
final firestoreService = FirestoreService();
final storageService = StorageService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ExamSeatingApp());
}
```

---

## 7. Best Practices

1. **Always handle errors** with try-catch blocks
2. **Use StreamBuilder** for real-time data
3. **Add loading states** in your UI
4. **Never commit API keys** - use environment variables if needed
5. **Set up security rules** to protect your data
6. **Use transactions** for complex operations:
   ```dart
   await _db.runTransaction((transaction) async {
     // Multiple operations
   });
   ```

---

These examples should cover most of your app's features!

