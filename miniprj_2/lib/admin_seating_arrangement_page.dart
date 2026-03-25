import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'service/seating_service.dart';
import 'service/pdf_seating_service.dart';
import 'universal_file_stub.dart'
    if (dart.library.io) 'universal_file_io.dart';

class AdminSeatingArrangementPage extends StatefulWidget {
  const AdminSeatingArrangementPage({Key? key}) : super(key: key);

  @override
  State<AdminSeatingArrangementPage> createState() =>
      _AdminSeatingArrangementPageState();
}

class _AdminSeatingArrangementPageState
    extends State<AdminSeatingArrangementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Upload status tracking
  final Map<String, bool> _uploadStatus = {
    'invigilators': false,
    'students': false,
    'halls': false,
  };

  // ✅ NEW: Store uploaded file names
  final Map<String, String?> _uploadedFiles = {
    'invigilators': null,
    'students': null,
    'halls': null,
  };

  final List<Map<String, dynamic>> _examHalls = [
    {
      'name': 'Hall A - Block 1',
      'capacity': 120,
      'allocated': 98,
      'examDate': '2026-03-15',
      'subject': 'Mathematics',
    },
    {
      'name': 'Hall B - Block 2',
      'capacity': 150,
      'allocated': 150,
      'examDate': '2026-03-15',
      'subject': 'Physics',
    },
    {
      'name': 'PWD Hall - Block 3',
      'capacity': 30,
      'allocated': 12,
      'examDate': '2026-03-15',
      'subject': 'Various',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SEATING ARRANGEMENT'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black87,
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.black54,
          tabs: const [
            Tab(
              icon: FaIcon(FontAwesomeIcons.fileUpload, size: 20),
              text: 'Upload Data',
            ),
            Tab(
              icon: FaIcon(FontAwesomeIcons.list, size: 20),
              text: 'Hall List',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUploadTab(),
          _buildHallListTab(),
        ],
      ),
    );
  }

  // ✅ Upload Data Tab
  Widget _buildUploadTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload Excel Data',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload required data files for exam arrangement',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Upload Status Summary
            Card(
              color: const Color(0xFFECDCAB).withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.circleInfo,
                          size: 20,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Upload Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '${_uploadStatus.values.where((v) => v).length}/3 Completed',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _uploadStatus.values.where((v) => v).length / 3,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 1. Invigilator List Upload
            _buildUploadCard(
              title: 'Invigilator List',
              description: 'Upload Excel file containing invigilator details',
              icon: FontAwesomeIcons.userTie,
              color: Colors.blue,
              isUploaded: _uploadStatus['invigilators']!,
              fileName: _uploadedFiles['invigilators'],
              onUpload: () => _handleFileUpload('invigilators'),
              sampleFields: [
                'Invigilator ID',
                'Name',
                'Department',
                'Contact Number',
                'Email',
                'Availability'
              ],
            ),
            const SizedBox(height: 16),

            // 2. Student Details Upload
            _buildUploadCard(
              title: 'Student Details',
              description: 'Upload Excel file with students attending exam on a specific day',
              icon: FontAwesomeIcons.userGraduate,
              color: Colors.orange,
              isUploaded: _uploadStatus['students']!,
              fileName: _uploadedFiles['students'],
              onUpload: () => _handleFileUpload('students'),
              sampleFields: [
                'Roll Number',
                'Student Name',
                'Course',
                'Year',
                'Subject Code',
                'Exam Date'
              ],
            ),
            const SizedBox(height: 16),

            // 3. Hall Details Upload
            _buildUploadCard(
              title: 'Hall Details',
              description: 'Upload Excel file containing examination hall information',
              icon: FontAwesomeIcons.building,
              color: Colors.green,
              isUploaded: _uploadStatus['halls']!,
              fileName: _uploadedFiles['halls'],
              onUpload: () => _handleFileUpload('halls'),
              sampleFields: [
                'Hall ID',
                'Hall Name',
                'Block',
                'Capacity',
                'Floor',
                'Facilities'
              ],
            ),
            const SizedBox(height: 24),

            // Generate Arrangement Button
            if (_uploadStatus.values.every((v) => v))
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _generateArrangement,
                  icon: const FaIcon(FontAwesomeIcons.wandMagicSparkles, size: 20),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'GENERATE SEATING ARRANGEMENT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ✅ Upload Card Widget
  Widget _buildUploadCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool isUploaded,
    String? fileName,
    required VoidCallback onUpload,
    required List<String> sampleFields,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FaIcon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isUploaded)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  FaIcon(
                                    FontAwesomeIcons.circleCheck,
                                    size: 12,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Uploaded',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (fileName != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.file,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                fileName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Sample Fields
            ExpansionTile(
              title: const Text(
                'Required Fields',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              dense: true,
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(left: 16, bottom: 8),
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: sampleFields
                      .map((field) => Chip(
                    label: Text(
                      field,
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor:
                    const Color(0xFFECDCAB).withOpacity(0.3),
                    padding: EdgeInsets.zero,
                  ))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Upload Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onUpload,
                icon: FaIcon(
                  isUploaded
                      ? FontAwesomeIcons.arrowRotateRight
                      : FontAwesomeIcons.fileUpload,
                  size: 16,
                ),
                label: Text(isUploaded ? 'RE-UPLOAD FILE' : 'UPLOAD FILE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isUploaded ? Colors.grey[400] : color,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ REAL File Upload Handler with CSV parsing
  Future<void> _handleFileUpload(String category) async {
    try {
      // Pick CSV file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx', 'xls'],
        withData: true, // Important for web platform
      );

      if (result == null) return;

      final fileName = result.files.single.name;

      // Show processing dialog
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Processing file...'),
              SizedBox(height: 8),
              Text(
                'Reading and uploading data to Firestore',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      );

      // Read file content - works on both web and desktop
      final csvString = await UniversalFile.readAsString(
        result.files.single.path,
        result.files.single.bytes,
      );

      // Parse CSV
      final csvData = const CsvToListConverter().convert(csvString);

      if (csvData.isEmpty || csvData.length < 2) {
        throw Exception('CSV file is empty or invalid');
      }

      // Upload to Firestore based on category
      await _uploadToFirestore(category, csvData);

      setState(() {
        _uploadStatus[category] = true;
        _uploadedFiles[category] = fileName;
      });

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.circleCheck,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text('${_getCategoryName(category)} uploaded successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.circleExclamation,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text('Error: $e')),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  // ✅ Upload parsed CSV data to Firestore
  Future<void> _uploadToFirestore(String category, List<List<dynamic>> csvData) async {
    final firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();
    int count = 0;

    switch (category) {
      case 'students':
        // CSV Format: RegisterNumber, Name, Department, Email, Phone, SubjectCode, ExamDate
        for (int i = 1; i < csvData.length; i++) {
          final row = csvData[i];
          if (row.length < 7) continue;

          final regNo = row[0].toString().trim();
          final subjectCode = row[5].toString().trim();
          final examDate = row[6].toString().trim();

          // Add student to students collection
          final studentRef = firestore.collection('students').doc(regNo);
          batch.set(studentRef, {
            'registerNumber': regNo,
            'name': row[1].toString().trim(),
            'department': row[2].toString().trim(),
            'email': row[3].toString().trim(),
            'phone': row[4].toString().trim(),
            'uploadedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          // Add exam if not exists
          final examRef = firestore.collection('exams').doc(subjectCode);
          batch.set(examRef, {
            'subjectCode': subjectCode,
            'examDate': examDate,
            'uploadedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          // Add student registration for this exam
          final regRef = examRef.collection('registrations').doc();
          batch.set(regRef, {
            'registerNumber': regNo,
            'examDate': examDate,
            'registeredAt': FieldValue.serverTimestamp(),
          });

          count++;
          if (count % 500 == 0) {
            await batch.commit();
            batch = firestore.batch();
          }
        }
        break;

      case 'halls':
        // CSV Format: HallCode, HallName, Block, Capacity, Rows, Columns
        for (int i = 1; i < csvData.length; i++) {
          final row = csvData[i];
          if (row.length < 6) continue;

          final hallCode = row[0].toString().trim();
          final hallRef = firestore.collection('halls').doc(hallCode);

          batch.set(hallRef, {
            'hallCode': hallCode,
            'hallName': row[1].toString().trim(),
            'block': row[2].toString().trim(),
            'capacity': int.parse(row[3].toString()),
            'rows': int.parse(row[4].toString()),
            'columns': int.parse(row[5].toString()),
            'uploadedAt': FieldValue.serverTimestamp(),
          });

          count++;
        }
        break;

      case 'invigilators':
        // CSV Format: EmployeeId, Name, Department, Email
        for (int i = 1; i < csvData.length; i++) {
          final row = csvData[i];
          if (row.length < 4) continue;

          final empId = row[0].toString().trim();
          final invRef = firestore.collection('invigilators').doc(empId);

          batch.set(invRef, {
            'employeeId': empId,
            'name': row[1].toString().trim(),
            'department': row[2].toString().trim(),
            'email': row[3].toString().trim(),
            'uploadedAt': FieldValue.serverTimestamp(),
          });

          count++;
        }
        break;
    }

    await batch.commit();
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'invigilators':
        return 'Invigilator list';
      case 'students':
        return 'Student details';
      case 'halls':
        return 'Hall details';
      default:
        return 'File';
    }
  }

  Future<void> _generateArrangement() async {
    // Show date picker to select exam date
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Select Exam Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFECDCAB),
              onPrimary: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null) return;

    // Format date for Firestore
    final examDate = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Generating seating arrangement...'),
            SizedBox(height: 8),
            Text(
              'This may take a few moments',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );

    try {
      // Call the seating service
      final seatingService = SeatingService();
      await seatingService.generateSeatingPlan(examDate);

      // Get the generated plan details
      final planDoc = await FirebaseFirestore.instance
          .collection('seatingPlans')
          .doc(examDate)
          .get();

      if (!mounted) return;

      // Close loading dialog
      Navigator.pop(context);

      // Show success dialog with details
      final totalHalls = planDoc.data()?['totalHalls'] ?? 0;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(width: 12),
              Text('Success!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Seating arrangement generated successfully!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text('📅 Exam Date: $examDate'),
              Text('🏛️ Halls Used: $totalHalls'),
              const SizedBox(height: 16),
              const Text(
                'Students can now view their seat allocations.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CLOSE'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await _generateAndDownloadPdf(examDate);
              },
              icon: const FaIcon(FontAwesomeIcons.filePdf, size: 16),
              label: const Text('GENERATE PDF'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _tabController.animateTo(1); // Switch to Hall List tab
              },
              child: const Text('VIEW HALLS'),
            ),
          ],
        ),
      );

    } catch (e) {
      if (!mounted) return;

      // Close loading dialog
      Navigator.pop(context);

      final seatingError = e is SeatingGenerationException ? e : null;
      final isMissingIndex = seatingError?.isMissingIndex ?? false;

      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 32),
              SizedBox(width: 12),
              Text('Error'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Failed to generate seating arrangement:'),
              const SizedBox(height: 8),
              Text(
                seatingError?.message ?? e.toString(),
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
              if (isMissingIndex) ...[
                const SizedBox(height: 12),
                const Text(
                  'Action needed:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('1) Create the required index in Firebase Console'),
                const Text('2) Wait for index status to become Enabled'),
                const Text('3) Tap RETRY'),
                if ((seatingError?.indexUrl ?? '').isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    seatingError!.indexUrl!,
                    style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
                  ),
                ],
              ] else ...[
                const SizedBox(height: 16),
                const Text(
                  'Please ensure:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('• Students are registered for exams'),
                const Text('• Exam details are in Firestore'),
                const Text('• Hall information is available'),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CLOSE'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _generateArrangement(); // Retry
              },
              child: const Text('RETRY'),
            ),
          ],
        ),
      );
    }
  }

  // Original Hall List Tab
  Widget _buildHallListTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Exam Halls',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_examHalls.length} halls configured',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                FloatingActionButton(
                  mini: true,
                  onPressed: () => _showCreateArrangementDialog(context),
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const FaIcon(FontAwesomeIcons.plus, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _examHalls.length,
                itemBuilder: (context, index) {
                  final hall = _examHalls[index];
                  final utilizationPercentage =
                  (hall['allocated'] / hall['capacity'] * 100).round();
                  final isFull = hall['allocated'] >= hall['capacity'];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hall['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Subject: ${hall['subject']}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    Text(
                                      'Date: ${hall['examDate']}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isFull
                                      ? Colors.red.withOpacity(0.2)
                                      : Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isFull ? 'FULL' : 'AVAILABLE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isFull ? Colors.red : Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.users,
                                size: 18,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${hall['allocated']} / ${hall['capacity']} seats',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: utilizationPercentage / 100,
                              minHeight: 8,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isFull
                                    ? Colors.red
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () => _viewHallLayout(hall),
                                icon: const FaIcon(
                                  FontAwesomeIcons.map,
                                  size: 16,
                                ),
                                label: const Text('View Layout'),
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                onPressed: () => _editArrangement(hall),
                                icon: const FaIcon(
                                  FontAwesomeIcons.penToSquare,
                                  size: 16,
                                ),
                                label: const Text('Edit'),
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                onPressed: () => _generateAndDownloadPdf(hall['examDate']),
                                icon: const FaIcon(
                                  FontAwesomeIcons.filePdf,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                label: const Text('PDF'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateArrangementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Arrangement'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Hall Name',
                  hintText: 'e.g., Hall C - Block 4',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Capacity',
                  hintText: 'Total seats',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  hintText: 'e.g., Chemistry',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Exam Date',
                  hintText: 'YYYY-MM-DD',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Arrangement created successfully!'),
                ),
              );
            },
            child: const Text('CREATE'),
          ),
        ],
      ),
    );
  }

  void _viewHallLayout(Map<String, dynamic> hall) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${hall['name']} Layout'),
        content: SizedBox(
          width: 300,
          height: 400,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: hall['capacity'],
            itemBuilder: (context, index) {
              final isAllocated = index < hall['allocated'];
              return Container(
                decoration: BoxDecoration(
                  color: isAllocated
                      ? Theme.of(context).primaryColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 10,
                      color: isAllocated ? Colors.black87 : Colors.grey[600],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }

  void _editArrangement(Map<String, dynamic> hall) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing ${hall['name']}...')),
    );
  }

  /// Generate and download PDF of seating arrangement
  Future<void> _generateAndDownloadPdf(String examDate) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Generating PDF...\n\nThis may take a few seconds'),
              SizedBox(height: 8),
              Text('Please wait...', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      );

      // Generate PDF with improved error handling
      final pdfService = PdfSeatingService();
      try {
        await pdfService.generateSeatingPdf(examDate);
      } catch (pdfError) {
        print('PDF Generation Error: $pdfError');
        rethrow;
      }

      if (!mounted) return;

      // Close loading dialog
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ PDF generated successfully!\n\nCheck your device notifications for the print/share dialog.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      // Close loading dialog
      try {
        Navigator.pop(context);
      } catch (e) {
        // Dialog might not be open
      }

      // Show detailed error message
      final errorMessage = _formatPdfError(e.toString());
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 28),
              SizedBox(width: 12),
              Text('PDF Generation Error'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(errorMessage, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Troubleshooting Tips:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      SizedBox(height: 8),
                      Text('• Ensure seating arrangement has been generated', style: TextStyle(fontSize: 11)),
                      SizedBox(height: 4),
                      Text('• Check internet connection', style: TextStyle(fontSize: 11)),
                      SizedBox(height: 4),
                      Text('• Try again in a few moments', style: TextStyle(fontSize: 11)),
                      SizedBox(height: 4),
                      Text('• Check Firebase Firestore has seating data', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CLOSE'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _generateAndDownloadPdf(examDate); // Retry
              },
              child: const Text('RETRY'),
            ),
          ],
        ),
      );
    }
  }

  /// Format PDF error message for display
  String _formatPdfError(String errorMessage) {
    if (errorMessage.contains('Seating plan not found')) {
      return '❌ No seating plan found for this date.\n\nPlease generate the seating arrangement first.';
    } else if (errorMessage.contains('No halls found')) {
      return '❌ No hall data found in seating plan.\n\nPlease ensure halls are configured before generating seating.';
    } else if (errorMessage.contains('layoutPdf')) {
      return '❌ PDF viewer error.\n\nYour device might not have a PDF viewer configured.\n\nTry installing Adobe Reader or another PDF viewer.';
    } else if (errorMessage.contains('permission')) {
      return '❌ Permission denied.\n\nPlease grant storage permissions in app settings.';
    } else if (errorMessage.contains('network')) {
      return '❌ Network error.\n\nPlease check your internet connection.';
    } else {
      return '❌ Error: ${errorMessage.length > 100 ? errorMessage.substring(0, 100) + '...' : errorMessage}';
    }
  }

}

