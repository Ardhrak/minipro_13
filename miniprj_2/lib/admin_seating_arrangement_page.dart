import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  // ✅ Simulated File Upload Handler (NO file_picker package needed)
  Future<void> _handleFileUpload(String category) async {
    // Show file selection dialog (simulated)
    final fileName = await _showFileSelectionDialog(category);

    if (fileName != null) {
      // Show processing dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing file...'),
                ],
              ),
            ),
          ),
        ),
      );

      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _uploadStatus[category] = true;
        _uploadedFiles[category] = fileName;
      });

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
    }
  }

  // ✅ Simulated File Selection Dialog
  Future<String?> _showFileSelectionDialog(String category) async {
    final TextEditingController fileNameController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const FaIcon(FontAwesomeIcons.fileExcel, size: 20, color: Colors.green),
            const SizedBox(width: 12),
            const Text('Select Excel File'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter file name for ${_getCategoryName(category)}:',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: fileNameController,
              decoration: InputDecoration(
                labelText: 'File Name',
                hintText: 'e.g., ${category}_data.xlsx',
                suffixText: '.xlsx',
                prefixIcon: const FaIcon(FontAwesomeIcons.file, size: 20),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.circleInfo,
                    size: 16,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Accepted formats: .xlsx, .xls, .csv',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              if (fileNameController.text.trim().isNotEmpty) {
                Navigator.pop(context, '${fileNameController.text.trim()}.xlsx');
              }
            },
            icon: const FaIcon(FontAwesomeIcons.check, size: 16),
            label: const Text('SELECT'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
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

  void _generateArrangement() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
              FaIcon(FontAwesomeIcons.wandMagicSparkles, size: 20),
            SizedBox(width: 12),
            Text('Generate Arrangement'),
          ],
        ),
        content: const Text(
          'This will automatically generate seating arrangements based on the uploaded data. Do you want to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Switch to hall list tab
              _tabController.animateTo(1);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Seating arrangement generated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('GENERATE'),
          ),
        ],
      ),
    );
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
}