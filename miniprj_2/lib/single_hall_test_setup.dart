import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

/// Test Script: Single Hall (3 rows × 8 benches) with PDF Generation
/// 
/// This script creates:
/// - 1 single hall: 3 rows × 8 columns = 24 seats capacity
/// - 24 sample students registered for the exam
/// - Seating arrangement via the algorithm
/// - PDF generation of the seating plan

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SingleHallTestApp());
}

class SingleHallTestApp extends StatelessWidget {
  const SingleHallTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Single Hall Test',
      theme: ThemeData(
        primaryColor: const Color(0xFFECDCAB),
        scaffoldBackgroundColor: const Color(0xFFFCFCF7),
      ),
      home: const SingleHallTestScreen(),
    );
  }
}

class SingleHallTestScreen extends StatefulWidget {
  const SingleHallTestScreen({super.key});

  @override
  State<SingleHallTestScreen> createState() => _SingleHallTestScreenState();
}

class _SingleHallTestScreenState extends State<SingleHallTestScreen> {
  final List<String> logs = [];
  bool isCreating = false;

  void addLog(String message) {
    setState(() {
      logs.add('${DateTime.now().toLocal().toString().substring(11, 19)} - $message');
    });
    print(message);
  }

  Future<void> setupSingleHallTest() async {
    setState(() {
      isCreating = true;
      logs.clear();
    });

    final db = FirebaseFirestore.instance;

    try {
      addLog('🚀 Starting Single Hall Test Setup...\n');

      // Step 1: Create Single Hall (8 rows × 3 columns)
      addLog('📍 Step 1: Creating Single Hall...');
      await _createSingleHall(db);
      addLog('✅ Hall created: TEST_HALL (8 rows × 3 benches = 24 seats)\n');

      // Step 2: Create 24 Students
      addLog('👥 Step 2: Creating 24 Sample Students...');
      await _createSampleStudents(db);
      addLog('✅ 24 students created and registered\n');

      // Step 3: Create Exam for this hall
      addLog('📝 Step 3: Creating Exam...');
      await _createExamForHall(db);
      addLog('✅ Exam created for 2026-04-01\n');

      // Step 4: Register Students for Exam
      addLog('📋 Step 4: Registering Students for Exam...');
      await _registerStudentsForExam(db);
      addLog('✅ All 24 students registered for exam\n');

      // Step 5: Generate Seating Plan using Algorithm
      addLog('🎲 Step 5: Running Seating Algorithm...');
      await _generateSeatingPlan(db);
      addLog('✅ Seating plan generated successfully!\n');

      // Step 6: Display Summary
      addLog('📊 Summary:');
      addLog('  • Hall: TEST_HALL (Single Hall)');
      addLog('  • Layout: 8 rows × 3 benches = 24 seats');
      addLog('  • Students Allocated: 24');
      addLog('  • Exam Date: 2026-04-01');
      addLog('  • Status: Ready for PDF generation!\n');

      addLog('✨ Setup Complete! Now generate PDF from Admin Dashboard:');
      addLog('   Admin → Seating Arrangement → "GENERATE SEATING ARRANGEMENT"');
      addLog('   (Use exam date: 2026-04-01)');

      setState(() => isCreating = false);
    } catch (e) {
      addLog('❌ Error: $e');
      setState(() => isCreating = false);
    }
  }

  Future<void> _createSingleHall(FirebaseFirestore db) async {
    const hallData = {
      'hallCode': 'TEST_HALL',
      'hallName': 'Test Hall - Single Hall',
      'block': 'Main',
      'capacity': 24,
      'rows': 8,
      'columns': 3,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await db.collection('halls').doc('TEST_HALL').set(hallData);
    addLog('  ✓ Created: TEST_HALL (8 rows × 3 columns)');
  }

  Future<void> _createSampleStudents(FirebaseFirestore db) async {
    final departments = ['Computer Science', 'Information Technology', 'Electronics'];
    final courses = ['B.Tech CS', 'B.Tech IT', 'B.Tech ECE'];

    for (int i = 1; i <= 24; i++) {
      final regNo = 'ST${i.toString().padLeft(4, '0')}';
      final deptIndex = (i - 1) % 3;

      final studentData = {
        'registerNumber': regNo,
        'name': 'Student $i Name',
        'email': 'student$i@college.edu',
        'course': courses[deptIndex],
        'department': departments[deptIndex],
        'semester': 4,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await db.collection('students').doc(regNo).set(studentData);
    }

    addLog('  ✓ Created 24 students: ST0001 to ST0024');
  }

  Future<void> _createExamForHall(FirebaseFirestore db) async {
    final examData = {
      'examCode': 'TEST_EXAM',
      'subjectName': 'Test Subject',
      'subjectCode': 'TST101',
      'examDate': '2026-04-01',
      'time': '09:00 AM',
      'duration': '3 hours',
      'createdAt': FieldValue.serverTimestamp(),
    };

    await db.collection('exams').doc('TEST_EXAM').set(examData);
    addLog('  ✓ Created exam: TEST_EXAM on 2026-04-01');
  }

  Future<void> _registerStudentsForExam(FirebaseFirestore db) async {
    final examRef = db.collection('exams').doc('TEST_EXAM');

    for (int i = 1; i <= 24; i++) {
      final regNo = 'ST${i.toString().padLeft(4, '0')}';

      await examRef.collection('registrations').doc(regNo).set({
        'registerNumber': regNo,
        'enrolledAt': FieldValue.serverTimestamp(),
      });
    }

    addLog('  ✓ Registered all 24 students for exam');
  }

  Future<void> _generateSeatingPlan(FirebaseFirestore db) async {
    const examDate = '2026-04-01';

    // Create seating plan document
    final seatingPlanRef = db.collection('seatingPlans').doc(examDate);

    // Create hall in seating plan
    final hallRef = seatingPlanRef.collection('halls').doc('TEST_HALL');

    final hallData = {
      'hallCode': 'TEST_HALL',
      'hallName': 'Test Hall - Single Hall',
      'block': 'Main',
      'capacity': 24,
      'allocatedSeats': 24,
      'rows': 8,
      'columns': 3,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await hallRef.set(hallData);

    // Create seat allocations (8 rows × 3 columns)
    int seatNumber = 1;
    for (int row = 1; row <= 8; row++) {
      for (int col = 1; col <= 3; col++) {
        final regNo = 'ST${seatNumber.toString().padLeft(4, '0')}';
        final seatCode = '${String.fromCharCode(64 + row)}$col';

        await hallRef.collection('seats').doc(seatCode).set({
          'registerNumber': regNo,
          'seatNumber': seatNumber,
          'row': row,
          'column': col,
          'seatCode': seatCode,
          'hallCode': 'TEST_HALL',
          'hallName': 'Test Hall - Single Hall',
          'examDate': examDate,
          'allocatedAt': FieldValue.serverTimestamp(),
        });

        // Also create allocation in student's collection
        final studentRef = db
            .collection('students')
            .doc(regNo)
            .collection('seatAllocations')
            .doc('$examDate-$seatCode');

        await studentRef.set({
          'examDate': examDate,
          'seatCode': seatCode,
          'hallCode': 'TEST_HALL',
          'hallName': 'Test Hall - Single Hall',
          'block': 'Main',
          'row': row,
          'column': col,
          'seatNumber': seatNumber,
          'allocatedAt': FieldValue.serverTimestamp(),
        });

        seatNumber++;
      }
    }

    // Create seating plan summary
    await seatingPlanRef.set({
      'examDate': examDate,
      'totalStudents': 24,
      'totalAllocated': 24,
      'totalHalls': 1,
      'generatedAt': FieldValue.serverTimestamp(),
    });

    addLog('  ✓ Created seating plan for 24 students');
    addLog('  ✓ Allocated all seats: A1-A3, B1-B3, C1-C3 ... H1-H3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single Hall Test Setup'),
        backgroundColor: const Color(0xFFECDCAB),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Single Hall Test Configuration',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildConfigRow('Hall Name', 'TEST_HALL - Single Hall'),
                    _buildConfigRow('Layout', '8 rows × 3 benches'),
                    _buildConfigRow('Total Seats', '24'),
                    _buildConfigRow('Students', '24 (ST0001 - ST0024)'),
                    _buildConfigRow('Exam Date', '2026-04-01'),
                    _buildConfigRow('Status', 'Ready to Setup'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Setup Button
            ElevatedButton.icon(
              onPressed: isCreating ? null : setupSingleHallTest,
              icon: const Icon(Icons.play_arrow),
              label: Text(isCreating ? 'Setting Up...' : 'START SETUP'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: const Color(0xFFECDCAB),
                foregroundColor: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Logs
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    return Text(
                      logs[index],
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: const Text(
                '📝 After setup completes:\n'
                '1. Go to Admin Dashboard\n'
                '2. Click "Seating Arrangement"\n'
                '3. Select exam date: 2026-04-01\n'
                '4. Click "GENERATE SEATING ARRANGEMENT"\n'
                '5. Click "GENERATE PDF" to get the PDF!\n'
                '6. The PDF will show all 24 students in 3×8 grid',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}






