import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminMedicalRequestsPage extends StatefulWidget {
  const AdminMedicalRequestsPage({Key? key}) : super(key: key);

  @override
  State<AdminMedicalRequestsPage> createState() =>
      _AdminMedicalRequestsPageState();
}

class _AdminMedicalRequestsPageState extends State<AdminMedicalRequestsPage> {
  final List<Map<String, dynamic>> _medicalRequests = [
    {
      'studentName': 'John Smith',
      'studentId': 'STU2024001',
      'requestType': 'Extra Time',
      'condition': 'Dyslexia',
      'requestDate': '2026-02-10',
      'examDate': '2026-03-15',
      'status': 'pending',
      'description': 'Requires 25% additional time for reading and writing',
      'documents': ['Medical Certificate', 'Doctor\'s Note'],
    },
    {
      'studentName': 'Emma Williams',
      'studentId': 'STU2024002',
      'requestType': 'Separate Room',
      'condition': 'Anxiety Disorder',
      'requestDate': '2026-02-08',
      'examDate': '2026-03-15',
      'status': 'approved',
      'description': 'Needs quiet environment with minimal distractions',
      'documents': ['Psychiatrist Report'],
    },
    {
      'studentName': 'Michael Brown',
      'studentId': 'STU2024003',
      'requestType': 'Wheelchair Access',
      'condition': 'Mobility Impairment',
      'requestDate': '2026-02-12',
      'examDate': '2026-03-15',
      'status': 'approved',
      'description': 'Requires ground floor exam hall with wheelchair accessibility',
      'documents': ['Disability Certificate'],
    },
    {
      'studentName': 'Sarah Johnson',
      'studentId': 'STU2024004',
      'requestType': 'Medical Equipment',
      'condition': 'Type 1 Diabetes',
      'requestDate': '2026-02-13',
      'examDate': '2026-03-15',
      'status': 'rejected',
      'description': 'Permission to keep glucose monitor and snacks',
      'documents': ['Medical Report'],
      'rejectionReason': 'Standard medical equipment allowed by default',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEDICAL REQUESTS'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pending & Recent Requests',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${_medicalRequests.where((r) => r['status'] == 'pending').length} pending requests',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              // Status Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', true),
                    const SizedBox(width: 8),
                    _buildFilterChip('Pending', false),
                    const SizedBox(width: 8),
                    _buildFilterChip('Approved', false),
                    const SizedBox(width: 8),
                    _buildFilterChip('Rejected', false),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _medicalRequests.length,
                  itemBuilder: (context, index) {
                    final request = _medicalRequests[index];
                    final statusColor = _getStatusColor(request['status']);
                    final statusIcon = _getStatusIcon(request['status']);

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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.userGraduate,
                                            size: 16,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              request['studentName'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'ID: ${request['studentId']}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13,
                                        ),
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
                                    color: statusColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FaIcon(
                                        statusIcon,
                                        size: 12,
                                        color: statusColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        request['status'].toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: statusColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.fileMedical,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    request['requestType'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1a1a1a),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.heartPulse,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Condition: ${request['condition']}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.calendar,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Requested: ${request['requestDate']}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                FaIcon(
                                  FontAwesomeIcons.calendarCheck,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Exam: ${request['examDate']}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                request['description'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              children: (request['documents'] as List<String>)
                                  .map((doc) => Chip(
                                avatar: const FaIcon(
                                  FontAwesomeIcons.paperclip,
                                  size: 12,
                                ),
                                label: Text(
                                  doc,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                backgroundColor: const Color(0xFFECDCAB)
                                    .withOpacity(0.3),
                                padding: EdgeInsets.zero,
                              ))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () => _viewRequestDetails(request),
                                  icon: const FaIcon(
                                    FontAwesomeIcons.eye,
                                    size: 16,
                                  ),
                                  label: const Text('View'),
                                ),
                                if (request['status'] == 'pending') ...[
                                  const SizedBox(width: 8),
                                  TextButton.icon(
                                    onPressed: () => _approveRequest(request),
                                    icon: const FaIcon(
                                      FontAwesomeIcons.circleCheck,
                                      size: 16,
                                    ),
                                    label: const Text('Approve'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton.icon(
                                    onPressed: () => _rejectRequest(request),
                                    icon: const FaIcon(
                                      FontAwesomeIcons.circleXmark,
                                      size: 16,
                                    ),
                                    label: const Text('Reject'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                  ),
                                ],
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
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        // Handle filter logic
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFFECDCAB),
      checkmarkColor: Colors.black87,
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'approved':
        return FontAwesomeIcons.circleCheck;
      case 'pending':
        return FontAwesomeIcons.clock;
      case 'rejected':
        return FontAwesomeIcons.circleXmark;
      default:
        return FontAwesomeIcons.circle;
    }
  }

  void _viewRequestDetails(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const FaIcon(FontAwesomeIcons.fileMedical, size: 20),
            const SizedBox(width: 12),
            const Expanded(child: Text('Request Details')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(FontAwesomeIcons.userGraduate, 'Student',
                  request['studentName']),
              _buildDetailRow(
                  FontAwesomeIcons.idCard, 'ID', request['studentId']),
              _buildDetailRow(FontAwesomeIcons.fileMedical, 'Request Type',
                  request['requestType']),
              _buildDetailRow(FontAwesomeIcons.heartPulse, 'Condition',
                  request['condition']),
              _buildDetailRow(FontAwesomeIcons.calendar, 'Request Date',
                  request['requestDate']),
              _buildDetailRow(FontAwesomeIcons.calendarCheck, 'Exam Date',
                  request['examDate']),
              const Divider(height: 24),
              const Text(
                'Description:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  request['description'],
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
              ),
              if (request['status'] == 'rejected' &&
                  request['rejectionReason'] != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Rejection Reason:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(
                    request['rejectionReason'],
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Colors.red[900],
                    ),
                  ),
                ),
              ],
            ],
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _approveRequest(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Request'),
        content: Text(
          'Are you sure you want to approve the medical request for ${request['studentName']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                request['status'] = 'approved';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Request approved successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('APPROVE'),
          ),
        ],
      ),
    );
  }

  void _rejectRequest(Map<String, dynamic> request) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Rejecting medical request for ${request['studentName']}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for rejection',
                hintText: 'Provide a reason...',
                prefixIcon: FaIcon(FontAwesomeIcons.comment, size: 20),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                request['status'] = 'rejected';
                request['rejectionReason'] = reasonController.text;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Request rejected'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('REJECT'),
          ),
        ],
      ),
    );
  }
}