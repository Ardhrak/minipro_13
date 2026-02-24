import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminNotificationsPage extends StatefulWidget {
  const AdminNotificationsPage({Key? key}) : super(key: key);

  @override
  State<AdminNotificationsPage> createState() =>
      _AdminNotificationsPageState();
}

class _AdminNotificationsPageState extends State<AdminNotificationsPage> {
  final List<Map<String, dynamic>> _sentNotifications = [
    {
      'title': 'Exam Schedule Released',
      'message':
      'The final exam schedule for March 2026 has been published. Please check your registered subjects.',
      'recipient': 'All Students',
      'sentDate': '2026-02-14 10:30 AM',
      'priority': 'high',
      'readCount': 1245,
      'totalRecipients': 1500,
    },
    {
      'title': 'Hall Ticket Available',
      'message':
      'Hall tickets are now available for download. Login to your account to download.',
      'recipient': 'All Students',
      'sentDate': '2026-02-13 02:15 PM',
      'priority': 'high',
      'readCount': 1380,
      'totalRecipients': 1500,
    },
    {
      'title': 'Invigilator Meeting',
      'message':
      'Mandatory meeting for all invigilators scheduled for Feb 16, 3 PM at Admin Block.',
      'recipient': 'All Invigilators',
      'sentDate': '2026-02-12 09:00 AM',
      'priority': 'medium',
      'readCount': 45,
      'totalRecipients': 50,
    },
    {
      'title': 'Medical Request Deadline',
      'message':
      'Last date to submit medical accommodation requests is Feb 20, 2026.',
      'recipient': 'All Students',
      'sentDate': '2026-02-10 11:45 AM',
      'priority': 'medium',
      'readCount': 890,
      'totalRecipients': 1500,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NOTIFICATIONS'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateNotificationDialog(context),
        backgroundColor: Theme.of(context).primaryColor,
        icon: const FaIcon(FontAwesomeIcons.plus, size: 20),
        label: const Text('New Notification'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sent Notifications',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${_sentNotifications.length} notifications sent',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _sentNotifications.length,
                  itemBuilder: (context, index) {
                    final notification = _sentNotifications[index];
                    final readPercentage =
                    (notification['readCount'] /
                        notification['totalRecipients'] *
                        100)
                        .round();
                    final priorityColor =
                    _getPriorityColor(notification['priority']);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: priorityColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.bell,
                                    color: priorityColor,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              notification['title'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                              priorityColor.withOpacity(0.2),
                                              borderRadius:
                                              BorderRadius.circular(6),
                                              border: Border.all(
                                                color: priorityColor
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            child: Text(
                                              notification['priority']
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: priorityColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        notification['message'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          height: 1.4,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                                  FontAwesomeIcons.userGroup,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'To: ${notification['recipient']}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.clock,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  notification['sentDate'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Read Status',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${notification['readCount']} / ${notification['totalRecipients']} ($readPercentage%)',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: readPercentage / 100,
                                    minHeight: 8,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      readPercentage > 75
                                          ? Colors.green
                                          : readPercentage > 50
                                          ? Colors.orange
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () =>
                                      _viewNotificationDetails(notification),
                                  icon: const FaIcon(
                                    FontAwesomeIcons.eye,
                                    size: 16,
                                  ),
                                  label: const Text('View'),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: () =>
                                      _resendNotification(notification),
                                  icon: const FaIcon(
                                    FontAwesomeIcons.arrowRotateRight,
                                    size: 16,
                                  ),
                                  label: const Text('Resend'),
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

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showCreateNotificationDialog(BuildContext context) {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    String selectedRecipient = 'All Students';
    String selectedPriority = 'medium';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: const [
              FaIcon(FontAwesomeIcons.bullhorn, size: 20),
              SizedBox(width: 12),
              Text('Send Notification'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter notification title',
                    prefixIcon: FaIcon(FontAwesomeIcons.heading, size: 20),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    hintText: 'Enter notification message',
                    prefixIcon: FaIcon(FontAwesomeIcons.message, size: 20),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedRecipient,
                  decoration: const InputDecoration(
                    labelText: 'Recipients',
                    prefixIcon: FaIcon(FontAwesomeIcons.userGroup, size: 20),
                  ),
                  items: [
                    'All Students',
                    'All Invigilators',
                    'Specific Year',
                    'Specific Department'
                  ]
                      .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedRecipient = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    prefixIcon: FaIcon(FontAwesomeIcons.flag, size: 20),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'low',
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Low'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'medium',
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Medium'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'high',
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('High'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedPriority = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    messageController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: const [
                          FaIcon(FontAwesomeIcons.circleCheck,
                              color: Colors.white, size: 20),
                          SizedBox(width: 12),
                          Text('Notification sent successfully!'),
                        ],
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: const FaIcon(FontAwesomeIcons.paperPlane, size: 16),
              label: const Text('SEND'),
            ),
          ],
        ),
      ),
    );
  }

  void _viewNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.bell,
              size: 20,
              color: _getPriorityColor(notification['priority']),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Notification Details')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  notification['message'],
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              const Divider(height: 24),
              _buildDetailRow(FontAwesomeIcons.userGroup, 'Recipients',
                  notification['recipient']),
              _buildDetailRow(
                  FontAwesomeIcons.clock, 'Sent', notification['sentDate']),
              _buildDetailRow(FontAwesomeIcons.flag, 'Priority',
                  notification['priority'].toUpperCase()),
              _buildDetailRow(
                  FontAwesomeIcons.envelopeOpen,
                  'Read Status',
                  '${notification['readCount']} / ${notification['totalRecipients']}'),
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

  void _resendNotification(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resend Notification'),
        content: Text(
          'Resend "${notification['title']}" to ${notification['recipient']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification resent successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const FaIcon(FontAwesomeIcons.arrowRotateRight, size: 16),
            label: const Text('RESEND'),
          ),
        ],
      ),
    );
  }
}