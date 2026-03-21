import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

/// Run this file ONCE to create test users in Firebase Authentication & Firestore
///
/// To run: flutter run lib/setup_test_users.dart
///
/// This will create:
/// - admin@test.com / admin1234
/// - student@test.com / student1234
/// - invigilator@test.com / invig1234

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SetupApp());
}

class SetupApp extends StatelessWidget {
  const SetupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SetupScreen(),
    );
  }
}

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final List<Map<String, String>> testUsers = [
    {
      'email': 'admin@test.com',
      'password': 'admin1234',
      'role': 'admin',
      'name': 'Admin User',
    },
    {
      'email': 'student@test.com',
      'password': 'student1234',
      'role': 'student',
      'name': 'Test Student',
      'registerNumber': 'STU001',
    },
    {
      'email': 'invigilator@test.com',
      'password': 'invig1234',
      'role': 'invigilator',
      'name': 'Test Invigilator',
    },
  ];

  List<String> logs = [];
  bool isCreating = false;

  void addLog(String message) {
    setState(() {
      logs.add('${DateTime.now().toLocal().toString().substring(11, 19)} - $message');
    });
    print(message);
  }

  Future<void> createTestUsers() async {
    setState(() {
      isCreating = true;
      logs.clear();
    });

    addLog('🚀 Starting user creation process...');

    final auth = FirebaseAuth.instance;
    final db = FirebaseFirestore.instance;

    for (var userData in testUsers) {
      try {
        addLog('\n📝 Creating ${userData['email']}...');

        // Check if user already exists in Auth
        UserCredential? cred;
        try {
          cred = await auth.createUserWithEmailAndPassword(
            email: userData['email']!,
            password: userData['password']!,
          );
          addLog('✅ Auth account created');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            addLog('⚠️  Auth account already exists');
            // Try to sign in to get UID
            try {
              cred = await auth.signInWithEmailAndPassword(
                email: userData['email']!,
                password: userData['password']!,
              );
              addLog('✅ Signed in to existing account');
            } catch (e) {
              addLog('❌ Could not sign in: $e');
              continue;
            }
          } else {
            addLog('❌ Auth error: ${e.message}');
            continue;
          }
        }

        if (cred.user == null) {
          addLog('❌ Failed to get user credential');
          continue;
        }

        // Create/Update Firestore document
        final uid = cred.user!.uid;
        final firestoreData = {
          'email': userData['email'],
          'role': userData['role'],
          'name': userData['name'],
          'createdAt': FieldValue.serverTimestamp(),
        };

        if (userData.containsKey('registerNumber')) {
          firestoreData['registerNumber'] = userData['registerNumber'];
        }

        await db.collection('users').doc(uid).set(
          firestoreData,
          SetOptions(merge: true),
        );
        addLog('✅ Firestore document created/updated');
        addLog('✨ ${userData['email']} setup complete!');

      } catch (e) {
        addLog('❌ Error creating ${userData['email']}: $e');
      }
    }

    // Sign out
    await auth.signOut();
    addLog('\n🎉 Setup complete! All users created.');
    addLog('\n📋 Test Credentials:');
    addLog('Admin: admin@test.com / admin1234');
    addLog('Student: student@test.com / student1234');
    addLog('Invigilator: invigilator@test.com / invig1234');

    setState(() {
      isCreating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase User Setup'),
        backgroundColor: const Color(0xFFECDCAB),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Test Users to Create:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...testUsers.map((user) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        '• ${user['email']} (${user['role']}) - Password: ${user['password']}',
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isCreating ? null : createTestUsers,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFFECDCAB),
              ),
              child: isCreating
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Creating Users...'),
                      ],
                    )
                  : const Text(
                      'CREATE TEST USERS',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Setup Log:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: logs.isEmpty
                    ? const Center(
                        child: Text(
                          'Click "CREATE TEST USERS" to begin',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              logs[index],
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

