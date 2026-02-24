import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminInvigilatorAllocationPage extends StatefulWidget {
  const AdminInvigilatorAllocationPage({Key? key}) : super(key: key);

  @override
  State<AdminInvigilatorAllocationPage> createState() =>
      _AdminInvigilatorAllocationPageState();
}

class _AdminInvigilatorAllocationPageState
    extends State<AdminInvigilatorAllocationPage> {
  final List<Map<String, dynamic>> _invigilators = [
    {
      'name': 'Dr. Sarah Johnson',
      'id': 'INV001',
      'department': 'Computer Science',
      'assignedHall': 'Hall A - Block 1',
      'examDate': '2026-03-15',
      'timeSlot': '09:00 AM - 12:00 PM',
      'status': 'confirmed',
    },
    {
      'name': 'Prof. Michael Chen',
      'id': 'INV002',
      'department': 'Mathematics',
      'assignedHall': 'Hall B - Block 2',
      'examDate': '2026-03-15',
      'timeSlot': '09:00 AM - 12:00 PM',
      'status': 'confirmed',
    },
    {
      'name': 'Dr. Emily Rodriguez',
      'id': 'INV003',
      'department': 'Physics',
      'assignedHall': 'Not Assigned',
      'examDate': '-',
      'timeSlot': '-',
      'status': 'available',
    },
    {
      'name': 'Prof. David Kumar',
      'id': 'INV004',
      'department': 'Chemistry',
      'assignedHall': 'PWD Hall - Block 3',
      'examDate': '2026-03-15',
      'timeSlot': '02:00 PM - 05:00 PM',
      'status': 'pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('INVIGILATOR ALLOCATION'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAllocateDialog(context),
        backgroundColor: Theme.of(context).primaryColor,
        icon: const FaIcon(FontAwesomeIcons.userPlus, size: 20),
        label: const Text('Allocate Invigilator'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Allocations',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${_invigilators.length} invigilators registered',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _invigilators.length,
                  itemBuilder: (context, index) {
                    final invigilator = _invigilators[index];
                    final isAssigned = invigilator['status'] != 'available';
                    final statusColor = _getStatusColor(invigilator['status']);
                    final statusIcon = _getStatusIcon(invigilator['status']);

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
                                            FontAwesomeIcons.user,
                                            size: 16,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              invigilator['name'],
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
                                        'ID: ${invigilator['id']} • ${invigilator['department']}',
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
                                        invigilator['status'].toUpperCase(),
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
                            if (isAssigned) ...[
                              const Divider(height: 24),
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.locationDot,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      invigilator['assignedHall'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
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
                                    invigilator['examDate'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  FaIcon(
                                    FontAwesomeIcons.clock,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    invigilator['timeSlot'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (isAssigned)
                                  TextButton.icon(
                                    onPressed: () => _viewDetails(invigilator),
                                    icon: const FaIcon(
                                      FontAwesomeIcons.circleInfo,
                                      size: 16,
                                    ),
                                    label: const Text('Details'),
                                  ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: () => _editAllocation(invigilator),
                                  icon: FaIcon(
                                    isAssigned
                                        ? FontAwesomeIcons.penToSquare
                                        : FontAwesomeIcons.userPlus,
                                    size: 16,
                                  ),
                                  label: Text(isAssigned ? 'Edit' : 'Assign'),
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
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'available':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'confirmed':
        return FontAwesomeIcons.circleCheck;
      case 'pending':
        return FontAwesomeIcons.clock;
      case 'available':
        return FontAwesomeIcons.circleUser;
      default:
        return FontAwesomeIcons.circle;
    }
  }

  void _showAllocateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Allocate Invigilator'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Invigilator Name',
                  hintText: 'Select or enter name',
                  prefixIcon: FaIcon(FontAwesomeIcons.user, size: 20),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Hall Assignment',
                  hintText: 'e.g., Hall A - Block 1',
                  prefixIcon: FaIcon(FontAwesomeIcons.locationDot, size: 20),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Exam Date',
                  hintText: 'YYYY-MM-DD',
                  prefixIcon: FaIcon(FontAwesomeIcons.calendar, size: 20),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Time Slot',
                  hintText: 'e.g., 09:00 AM - 12:00 PM',
                  prefixIcon: FaIcon(FontAwesomeIcons.clock, size: 20),
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
                  content: Text('Invigilator allocated successfully!'),
                ),
              );
            },
            child: const Text('ALLOCATE'),
          ),
        ],
      ),
    );
  }

  void _viewDetails(Map<String, dynamic> invigilator) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(invigilator['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
                FontAwesomeIcons.idCard, 'ID', invigilator['id']),
            _buildDetailRow(FontAwesomeIcons.building, 'Department',
                invigilator['department']),
            _buildDetailRow(FontAwesomeIcons.locationDot, 'Assigned Hall',
                invigilator['assignedHall']),
            _buildDetailRow(
                FontAwesomeIcons.calendar, 'Date', invigilator['examDate']),
            _buildDetailRow(
                FontAwesomeIcons.clock, 'Time', invigilator['timeSlot']),
          ],
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

  void _editAllocation(Map<String, dynamic> invigilator) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing allocation for ${invigilator['name']}...')),
    );
  }
}