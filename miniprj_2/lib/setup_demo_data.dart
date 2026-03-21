import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

/// Run this file ONCE to populate Firestore with demo data
///
/// To run: flutter run lib/setup_demo_data.dart
///
/// This will create:
/// - 30 demo students
/// - 5 halls with different capacities
/// - 5 exams for different subjects
/// - Sample seating arrangements
/// - Sample notifications

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const DemoDataSetupApp());
}

class DemoDataSetupApp extends StatelessWidget {
  const DemoDataSetupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Data Setup',
      theme: ThemeData(
        primaryColor: const Color(0xFFECDCAB),
        scaffoldBackgroundColor: const Color(0xFFFCFCF7),
      ),
      home: const DemoDataSetupScreen(),
    );
  }
}

class DemoDataSetupScreen extends StatefulWidget {
  const DemoDataSetupScreen({super.key});

  @override
  State<DemoDataSetupScreen> createState() => _DemoDataSetupScreenState();
}

class _DemoDataSetupScreenState extends State<DemoDataSetupScreen> {
  final List<String> logs = [];
  bool isCreating = false;
  int totalSteps = 0;
  int completedSteps = 0;

  void addLog(String message) {
    setState(() {
      logs.add('${DateTime.now().toLocal().toString().substring(11, 19)} - $message');
    });
    print(message);
  }

  Future<void> createDemoData() async {
    setState(() {
      isCreating = true;
      logs.clear();
      completedSteps = 0;
      totalSteps = 6;
    });

    final db = FirebaseFirestore.instance;

    try {
      addLog('🚀 Starting demo data creation...\n');

      // Step 1: Create Students
      addLog('📚 Step 1/6: Creating students...');
      await _createStudents(db);
      setState(() => completedSteps++);
      addLog('✅ Students created successfully!\n');

      // Step 2: Create Halls
      addLog('🏛️ Step 2/6: Creating halls...');
      await _createHalls(db);
      setState(() => completedSteps++);
      addLog('✅ Halls created successfully!\n');

      // Step 3: Create Exams
      addLog('📝 Step 3/6: Creating exams...');
      await _createExams(db);
      setState(() => completedSteps++);
      addLog('✅ Exams created successfully!\n');

      // Step 4: Create Invigilator Assignments
      addLog('👥 Step 4/6: Creating invigilator assignments...');
      await _createInvigilatorAssignments(db);
      setState(() => completedSteps++);
      addLog('✅ Invigilator assignments created!\n');

      // Step 5: Create Seating Plans
      addLog('🪑 Step 5/6: Creating seating plans...');
      await _createSeatingPlans(db);
      setState(() => completedSteps++);
      addLog('✅ Seating plans created successfully!\n');

      // Step 6: Create Notifications
      addLog('🔔 Step 6/6: Creating notifications...');
      await _createNotifications(db);
      setState(() => completedSteps++);
      addLog('✅ Notifications created successfully!\n');

      addLog('🎉 ALL DEMO DATA CREATED SUCCESSFULLY!');
      addLog('\n📊 Summary:');
      addLog('✅ 30 Students added');
      addLog('✅ 5 Halls configured');
      addLog('✅ 5 Exams scheduled');
      addLog('✅ 5 Invigilator assignments');
      addLog('✅ Sample seating arrangements');
      addLog('✅ 6 Notifications created');
      addLog('\n🚀 You can now run your main app!');
      addLog('Run: flutter run');

    } catch (e, stackTrace) {
      addLog('❌ Error: $e');
      addLog('Stack trace: $stackTrace');
    } finally {
      setState(() => isCreating = false);
    }
  }

  Future<void> _createStudents(FirebaseFirestore db) async {
    final students = [
      // Computer Science Students
      {'registerNumber': 'CS2024001', 'name': 'Arjun Menon', 'course': 'B.Tech CS', 'semester': 6, 'department': 'CSE', 'exams': ['CS301', 'CS302', 'CS303']},
      {'registerNumber': 'CS2024002', 'name': 'Priya Nair', 'course': 'B.Tech CS', 'semester': 6, 'department': 'CSE', 'exams': ['CS301', 'CS302', 'CS303']},
      {'registerNumber': 'CS2024003', 'name': 'Aditya Kumar', 'course': 'B.Tech CS', 'semester': 6, 'department': 'CSE', 'exams': ['CS301', 'CS302', 'CS303']},
      {'registerNumber': 'CS2024004', 'name': 'Divya Rajan', 'course': 'B.Tech CS', 'semester': 6, 'department': 'CSE', 'exams': ['CS301', 'CS302', 'CS303']},
      {'registerNumber': 'CS2024005', 'name': 'Anjali Mohan', 'course': 'B.Tech CS', 'semester': 6, 'department': 'CSE', 'exams': ['CS301', 'CS302', 'CS303']},
      {'registerNumber': 'CS2024006', 'name': 'Suresh Babu', 'course': 'B.Tech CS', 'semester': 6, 'department': 'CSE', 'exams': ['CS301', 'CS302', 'CS303']},
      {'registerNumber': 'CS2024007', 'name': 'Pooja Chandran', 'course': 'B.Tech CS', 'semester': 6, 'department': 'CSE', 'exams': ['CS301', 'CS302', 'CS303']},
      {'registerNumber': 'CS2024008', 'name': 'Abhijit Paul', 'course': 'B.Tech CS', 'semester': 6, 'department': 'CSE', 'exams': ['CS301', 'CS302', 'CS303']},
      {'registerNumber': 'CS2024009', 'name': 'Athira Pillai', 'course': 'B.Tech CS', 'semester': 6, 'department': 'CSE', 'exams': ['CS301', 'CS302', 'CS303']},
      {'registerNumber': 'CS2024010', 'name': 'Sanjay Kumar', 'course': 'B.Tech CS', 'semester': 6, 'department': 'CSE', 'exams': ['CS301', 'CS302', 'CS303']},

      // Electronics Students
      {'registerNumber': 'EC2024001', 'name': 'Rahul Das', 'course': 'B.Tech EC', 'semester': 6, 'department': 'ECE', 'exams': ['EC301', 'EC302', 'MATH301']},
      {'registerNumber': 'EC2024002', 'name': 'Meera Krishnan', 'course': 'B.Tech EC', 'semester': 6, 'department': 'ECE', 'exams': ['EC301', 'EC302', 'MATH301']},
      {'registerNumber': 'EC2024003', 'name': 'Karthik Suresh', 'course': 'B.Tech EC', 'semester': 6, 'department': 'ECE', 'exams': ['EC301', 'EC302', 'MATH301']},
      {'registerNumber': 'EC2024004', 'name': 'Nisha Thomas', 'course': 'B.Tech EC', 'semester': 6, 'department': 'ECE', 'exams': ['EC301', 'EC302', 'MATH301']},
      {'registerNumber': 'EC2024005', 'name': 'Nikhil George', 'course': 'B.Tech EC', 'semester': 6, 'department': 'ECE', 'exams': ['EC301', 'EC302', 'MATH301']},
      {'registerNumber': 'EC2024006', 'name': 'Sruthi Madhavan', 'course': 'B.Tech EC', 'semester': 6, 'department': 'ECE', 'exams': ['EC301', 'EC302', 'MATH301']},
      {'registerNumber': 'EC2024007', 'name': 'Jithin Mathew', 'course': 'B.Tech EC', 'semester': 6, 'department': 'ECE', 'exams': ['EC301', 'EC302', 'MATH301']},
      {'registerNumber': 'EC2024008', 'name': 'Reetha Joseph', 'course': 'B.Tech EC', 'semester': 6, 'department': 'ECE', 'exams': ['EC301', 'EC302', 'MATH301']},
      {'registerNumber': 'EC2024009', 'name': 'Tharun Menon', 'course': 'B.Tech EC', 'semester': 6, 'department': 'ECE', 'exams': ['EC301', 'EC302', 'MATH301']},
      {'registerNumber': 'EC2024010', 'name': 'Amrutha Suresh', 'course': 'B.Tech EC', 'semester': 6, 'department': 'ECE', 'exams': ['EC301', 'EC302', 'MATH301']},

      // Mechanical Students
      {'registerNumber': 'ME2024001', 'name': 'Sneha Pillai', 'course': 'B.Tech ME', 'semester': 6, 'department': 'MECH', 'exams': ['ME301', 'ME302', 'MATH301']},
      {'registerNumber': 'ME2024002', 'name': 'Vivek Sharma', 'course': 'B.Tech ME', 'semester': 6, 'department': 'MECH', 'exams': ['ME301', 'ME302', 'MATH301']},
      {'registerNumber': 'ME2024003', 'name': 'Rohan Iyer', 'course': 'B.Tech ME', 'semester': 6, 'department': 'MECH', 'exams': ['ME301', 'ME302', 'MATH301']},
      {'registerNumber': 'ME2024004', 'name': 'Lakshmi Varma', 'course': 'B.Tech ME', 'semester': 6, 'department': 'MECH', 'exams': ['ME301', 'ME302', 'MATH301']},
      {'registerNumber': 'ME2024005', 'name': 'Anand Rajesh', 'course': 'B.Tech ME', 'semester': 6, 'department': 'MECH', 'exams': ['ME301', 'ME302', 'MATH301']},
      {'registerNumber': 'ME2024006', 'name': 'Kavya Menon', 'course': 'B.Tech ME', 'semester': 6, 'department': 'MECH', 'exams': ['ME301', 'ME302', 'MATH301']},
      {'registerNumber': 'ME2024007', 'name': 'Manoj Nair', 'course': 'B.Tech ME', 'semester': 6, 'department': 'MECH', 'exams': ['ME301', 'ME302', 'MATH301']},
      {'registerNumber': 'ME2024008', 'name': 'Fathima Beevi', 'course': 'B.Tech ME', 'semester': 6, 'department': 'MECH', 'exams': ['ME301', 'ME302', 'MATH301']},
      {'registerNumber': 'ME2024009', 'name': 'Vishnu Prakash', 'course': 'B.Tech ME', 'semester': 6, 'department': 'MECH', 'exams': ['ME301', 'ME302', 'MATH301']},
      {'registerNumber': 'ME2024010', 'name': 'Geetha Krishnan', 'course': 'B.Tech ME', 'semester': 6, 'department': 'MECH', 'exams': ['ME301', 'ME302', 'MATH301']},
    ];

    for (var student in students) {
      await db.collection('students').doc(student['registerNumber'] as String).set({
        ...student,
        'createdAt': FieldValue.serverTimestamp(),
      });
      addLog('  ✓ ${student['name']} (${student['registerNumber']})');
    }
  }

  Future<void> _createHalls(FirebaseFirestore db) async {
    final halls = [
      {'hallId': 'HALL_A', 'hallName': 'Hall A - Block 1', 'capacity': 30, 'rows': 5, 'columns': 6, 'available': true, 'building': 'Main Block', 'floor': 1},
      {'hallId': 'HALL_B', 'hallName': 'Hall B - Block 1', 'capacity': 40, 'rows': 5, 'columns': 8, 'available': true, 'building': 'Main Block', 'floor': 2},
      {'hallId': 'HALL_C', 'hallName': 'Hall C - Block 2', 'capacity': 35, 'rows': 5, 'columns': 7, 'available': true, 'building': 'Science Block', 'floor': 1},
      {'hallId': 'HALL_D', 'hallName': 'Hall D - Block 2', 'capacity': 25, 'rows': 5, 'columns': 5, 'available': true, 'building': 'Science Block', 'floor': 2},
      {'hallId': 'HALL_E', 'hallName': 'Hall E - Block 3', 'capacity': 50, 'rows': 5, 'columns': 10, 'available': true, 'building': 'Engineering Block', 'floor': 1},
    ];

    for (var hall in halls) {
      await db.collection('halls').doc(hall['hallId'] as String).set({
        ...hall,
        'createdAt': FieldValue.serverTimestamp(),
      });
      addLog('  ✓ ${hall['hallName']} (Capacity: ${hall['capacity']})');
    }
  }

  Future<void> _createExams(FirebaseFirestore db) async {
    final exams = [
      {'examId': 'CS301', 'subjectCode': 'CS301', 'subjectName': 'Data Structures & Algorithms', 'date': '2026-03-15', 'timeSlot': '09:00 AM - 12:00 PM', 'duration': 180, 'department': 'CSE'},
      {'examId': 'CS302', 'subjectCode': 'CS302', 'subjectName': 'Database Management Systems', 'date': '2026-03-17', 'timeSlot': '02:00 PM - 05:00 PM', 'duration': 180, 'department': 'CSE'},
      {'examId': 'EC301', 'subjectCode': 'EC301', 'subjectName': 'Digital Signal Processing', 'date': '2026-03-16', 'timeSlot': '09:00 AM - 12:00 PM', 'duration': 180, 'department': 'ECE'},
      {'examId': 'ME301', 'subjectCode': 'ME301', 'subjectName': 'Thermodynamics', 'date': '2026-03-18', 'timeSlot': '09:00 AM - 12:00 PM', 'duration': 180, 'department': 'MECH'},
      {'examId': 'MATH301', 'subjectCode': 'MATH301', 'subjectName': 'Engineering Mathematics III', 'date': '2026-03-20', 'timeSlot': '02:00 PM - 05:00 PM', 'duration': 180, 'department': 'ALL'},
    ];

    for (var exam in exams) {
      await db.collection('exams').doc(exam['examId'] as String).set({
        ...exam,
        'createdAt': FieldValue.serverTimestamp(),
      });
      addLog('  ✓ ${exam['subjectName']} (${exam['date']})');
    }
  }

  Future<void> _createInvigilatorAssignments(FirebaseFirestore db) async {
    // Get the invigilator UID from test users
    final invigilatorQuery = await db.collection('users')
        .where('role', isEqualTo: 'invigilator')
        .limit(1)
        .get();

    String invigilatorId = 'INV001'; // Default
    if (invigilatorQuery.docs.isNotEmpty) {
      invigilatorId = invigilatorQuery.docs.first.id;
    }

    final assignments = [
      {'examId': 'CS301', 'hallId': 'HALL_A', 'invigilatorId': invigilatorId, 'date': '2026-03-15', 'timeSlot': '09:00 AM - 12:00 PM', 'status': 'confirmed'},
      {'examId': 'EC301', 'hallId': 'HALL_B', 'invigilatorId': invigilatorId, 'date': '2026-03-16', 'timeSlot': '09:00 AM - 12:00 PM', 'status': 'confirmed'},
      {'examId': 'CS302', 'hallId': 'HALL_C', 'invigilatorId': invigilatorId, 'date': '2026-03-17', 'timeSlot': '02:00 PM - 05:00 PM', 'status': 'confirmed'},
      {'examId': 'ME301', 'hallId': 'HALL_D', 'invigilatorId': invigilatorId, 'date': '2026-03-18', 'timeSlot': '09:00 AM - 12:00 PM', 'status': 'confirmed'},
      {'examId': 'MATH301', 'hallId': 'HALL_E', 'invigilatorId': invigilatorId, 'date': '2026-03-20', 'timeSlot': '02:00 PM - 05:00 PM', 'status': 'confirmed'},
    ];

    for (var assignment in assignments) {
      await db.collection('invigilatorAssignments').add({
        ...assignment,
        'createdAt': FieldValue.serverTimestamp(),
      });
      addLog('  ✓ ${assignment['examId']} → ${assignment['hallId']}');
    }
  }

  Future<void> _createSeatingPlans(FirebaseFirestore db) async {
    // Create seating plan for CS301 exam in Hall A
    addLog('  Creating seating for CS301 in Hall A...');

    final cs301Students = [
      'CS2024001', 'CS2024002', 'CS2024003', 'CS2024004', 'CS2024005',
      'CS2024006', 'CS2024007', 'CS2024008', 'CS2024009', 'CS2024010',
    ];

    final planRef = db.collection('seatingPlans').doc('2026-03-15');
    await planRef.set({
      'examDate': '2026-03-15',
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': 'admin',
    });

    final hallRef = planRef.collection('halls').doc('HALL_A');
    await hallRef.set({
      'hallName': 'Hall A - Block 1',
      'examId': 'CS301',
      'capacity': 30,
    });

    int seatIndex = 0;
    for (int row = 1; row <= 5; row++) {
      for (int col = 1; col <= 6; col++) {
        if (seatIndex < cs301Students.length) {
          final regNo = cs301Students[seatIndex];
          final studentDoc = await db.collection('students').doc(regNo).get();
          final studentData = studentDoc.data()!;

          await hallRef.collection('seats').doc('${String.fromCharCode(64 + row)}$col').set({
            'seatNumber': '${String.fromCharCode(64 + row)}$col',
            'row': row,
            'column': col,
            'registerNumber': regNo,
            'studentName': studentData['name'],
            'course': studentData['course'],
            'department': studentData['department'],
            'occupied': true,
          });
          seatIndex++;
        } else {
          await hallRef.collection('seats').doc('${String.fromCharCode(64 + row)}$col').set({
            'seatNumber': '${String.fromCharCode(64 + row)}$col',
            'row': row,
            'column': col,
            'occupied': false,
          });
        }
      }
    }
    addLog('  ✓ CS301 seating plan created (${cs301Students.length} students)');
  }

  Future<void> _createNotifications(FirebaseFirestore db) async {
    final notifications = [
      {
        'title': 'Exam Schedule Released',
        'message': 'The semester end exam schedule has been published. Check your dashboard for details.',
        'targetRole': 'all',
        'priority': 'high',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Hall Tickets Available',
        'message': 'Download your hall tickets from the student dashboard. Carry printed copies to the exam hall.',
        'targetRole': 'student',
        'priority': 'high',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Seating Arrangement Published',
        'message': 'Seating arrangements for all exams are now available. Check your allocated seat.',
        'targetRole': 'student',
        'priority': 'medium',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Invigilator Duty Assigned',
        'message': 'You have been assigned invigilation duties. Check your dashboard for details.',
        'targetRole': 'invigilator',
        'priority': 'high',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Medical Certificate Submission',
        'message': 'Students requiring medical consideration must submit certificates 48 hours before the exam.',
        'targetRole': 'student',
        'priority': 'medium',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Exam Guidelines',
        'message': 'Please review the exam guidelines and instructions before attending the exam.',
        'targetRole': 'all',
        'priority': 'low',
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var notification in notifications) {
      await db.collection('notifications').add(notification);
      addLog('  ✓ ${notification['title']} (${notification['targetRole']})');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Data Setup'),
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
                      'Demo Data to Create:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('• 30 Students (CS, EC, ME departments)'),
                    const Text('• 5 Halls with different capacities'),
                    const Text('• 5 Exams scheduled for March 2026'),
                    const Text('• Invigilator assignments'),
                    const Text('• Sample seating arrangements'),
                    const Text('• 6 Notifications'),
                    const SizedBox(height: 16),
                    const Text(
                      '⚠️ Warning: This will create data in your Firestore database.',
                      style: TextStyle(color: Colors.orange, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isCreating) ...[
              LinearProgressIndicator(
                value: completedSteps / totalSteps,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFECDCAB)),
              ),
              const SizedBox(height: 8),
              Text(
                'Progress: $completedSteps/$totalSteps steps completed',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
            ],
            ElevatedButton(
              onPressed: isCreating ? null : createDemoData,
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
                        Text('Creating Demo Data...'),
                      ],
                    )
                  : const Text(
                      'CREATE DEMO DATA',
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
                          'Click "CREATE DEMO DATA" to begin',
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

