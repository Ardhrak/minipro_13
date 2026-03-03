import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentNotificationsPage extends StatefulWidget {
  const StudentNotificationsPage({Key? key}) : super(key: key);

  @override
  State<StudentNotificationsPage> createState() =>
      _StudentNotificationsPageState();
}

class _StudentNotificationsPageState
    extends State<StudentNotificationsPage> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Seat Allocation Published',
      'body':
      'Your seat allocations for the March 2026 end semester exams are now available. Please check your seat details.',
      'time': '2 hrs ago',
      'icon': FontAwesomeIcons.chair,
      'type': 'seat',
      'isRead': false,
    },
    {
      'title': 'Medical Request Approved',
      'body':
      'Your medical accommodation request for CS301 – Data Structures has been approved. Extra 30 minutes will be allotted.',
      'time': '1 day ago',
      'icon': FontAwesomeIcons.circleCheck,
      'type': 'medical',
      'isRead': false,
    },
    {
      'title': 'Hall Ticket Available',
      'body':
      'Your hall ticket for End Semester Examinations March 2026 is ready. Download and carry it to all exams.',
      'time': '2 days ago',
      'icon': FontAwesomeIcons.ticketSimple,
      'type': 'ticket',
      'isRead': true,
    },
    {
      'title': 'Exam Schedule Reminder',
      'body':
      'Your first exam CS301 – Data Structures is on 15 Mar 2026 at 09:00 AM in Hall A. Please be present 15 minutes early.',
      'time': '3 days ago',
      'icon': FontAwesomeIcons.calendarDays,
      'type': 'reminder',
      'isRead': true,
    },
    {
      'title': 'Important: Exam Guidelines',
      'body':
      'Please read the updated examination guidelines. Electronic devices are not permitted. Carry your hall ticket and college ID.',
      'time': '5 days ago',
      'icon': FontAwesomeIcons.triangleExclamation,
      'type': 'alert',
      'isRead': true,
    },
  ];

  Color _typeColor(String type) {
    switch (type) {
      case 'seat':
        return Colors.blue;
      case 'medical':
        return Colors.green;
      case 'ticket':
        return const Color(0xFFECDCAB);
      case 'reminder':
        return Colors.orange;
      case 'alert':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unread = _notifications.where((n) => !n['isRead']).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NOTIFICATIONS'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  for (var n in _notifications) {
                    n['isRead'] = true;
                  }
                });
              },
              child: const Text(
                'Mark all read',
                style: TextStyle(color: Colors.black87, fontSize: 13),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  const Text(
                    'Notifications',
                    style:
                    TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  if (unread > 0) ...[
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$unread new',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: _notifications.isEmpty
                  ? _buildEmpty()
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                itemCount: _notifications.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final n = _notifications[index];
                  final color = _typeColor(n['type']);
                  return Dismissible(
                    key: Key('notif_$index'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const FaIcon(FontAwesomeIcons.trash,
                          color: Colors.red),
                    ),
                    onDismissed: (_) {
                      setState(
                              () => _notifications.removeAt(index));
                    },
                    child: GestureDetector(
                      onTap: () {
                        setState(() => n['isRead'] = true);
                      },
                      child: Card(
                        elevation: n['isRead'] ? 1 : 4,
                        shadowColor: Colors.black26,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.15),
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  border: Border.all(
                                      color: color.withOpacity(0.3)),
                                ),
                                child: FaIcon(n['icon'],
                                    size: 20, color: color),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            n['title'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: n['isRead']
                                                  ? FontWeight.w600
                                                  : FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        if (!n['isRead'])
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration:
                                            const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      n['body'],
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: n['isRead']
                                            ? Colors.grey[500]
                                            : Colors.grey[700],
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      n['time'],
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[400]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFECDCAB).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const FaIcon(FontAwesomeIcons.bellSlash,
                size: 40, color: Colors.black45),
          ),
          const SizedBox(height: 16),
          const Text('No notifications',
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('You\'re all caught up!',
              style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }
}