import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Cache for user data to avoid repeated Firestore calls
  static final Map<String, Map<String, dynamic>> _userCache = {};

  // ── Get current user ──────────────────────────────────
  User? get currentUser => _auth.currentUser;

  // ── Login ─────────────────────────────────────────────
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Perform authentication with timeout
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Login timeout. Please check your internet connection.');
        },
      );

      final uid = cred.user!.uid;

      // Check cache first
      if (_userCache.containsKey(uid)) {
        return {
          'success': true,
          'role': _userCache[uid]!['role'],
          'user': _userCache[uid],
        };
      }

      // Fetch role from Firestore with timeout
      final doc = await _db
          .collection('users')
          .doc(uid)
          .get()
          .timeout(
            const Duration(seconds: 8),
            onTimeout: () {
              throw Exception('Failed to fetch user data. Please try again.');
            },
          );

      if (!doc.exists) {
        await _auth.signOut();
        return {'success': false, 'error': 'User data not found. Please contact admin.'};
      }

      final userData = doc.data()!;

      // ✅ SECURITY: Check if student account is approved
      if (userData['role'] == 'student') {
        final approved = userData['approved'] ?? true;
        final approvalStatus = userData['approvalStatus'] ?? 'approved';

        if (!approved || approvalStatus == 'pending') {
          await _auth.signOut();
          return {
            'success': false,
            'error': '⏳ Your account is pending admin approval.\n\nPlease wait for approval notification via email.'
          };
        }

        if (approvalStatus == 'rejected') {
          await _auth.signOut();
          return {
            'success': false,
            'error': '❌ Your registration was rejected.\n\nPlease contact the admin office for more information.'
          };
        }

        // ✅ CHECK EMAIL VERIFICATION
        final emailVerified = cred.user!.emailVerified;
        userData['emailVerificationWarning'] = !emailVerified;

        // Update email verification status
        await _db.collection('users').doc(uid).update({
          'emailVerified': emailVerified,
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }

      // Cache the user data
      _userCache[uid] = userData;

      return {
        'success': true,
        'role': userData['role'],
        'user': userData,
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = '❌ No user found with this email.\n\nPlease run the setup script first:\nflutter run lib/setup_test_users.dart';
          break;
        case 'wrong-password':
          errorMessage = '❌ Incorrect password';
          break;
        case 'invalid-email':
          errorMessage = '❌ Invalid email address format';
          break;
        case 'user-disabled':
          errorMessage = '❌ This account has been disabled';
          break;
        case 'network-request-failed':
          errorMessage = '❌ Network error. Check your internet connection';
          break;
        case 'invalid-credential':
          errorMessage = '❌ Invalid credentials.\n\nUser not found in Firebase Authentication.\nRun: flutter run lib/setup_test_users.dart';
          break;
        case 'too-many-requests':
          errorMessage = '❌ Too many failed attempts. Try again later.';
          break;
        default:
          errorMessage = '❌ ${e.message ?? 'Login failed'}\n\nError Code: ${e.code}';
      }
      return {'success': false, 'error': errorMessage};
    } catch (e) {
      return {'success': false, 'error': '❌ Error: ${e.toString()}'};
    }
  }

  // ── Logout ────────────────────────────────────────────
  Future<void> logout() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      _userCache.remove(uid); // Clear cache on logout
    }
    await _auth.signOut();
  }

  // ── Create user (Admin does this for students) ────────
  Future<void> createUser({
    required String email,
    required String password,
    required String role,
    required String name,
    String? registerNumber,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _db.collection('users').doc(cred.user!.uid).set({
      'email': email,
      'role': role,
      'name': name,
      'registerNumber': registerNumber,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}