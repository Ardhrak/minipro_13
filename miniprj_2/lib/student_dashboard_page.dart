import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'student_seat_allocation_page.dart';
import 'student_hall_ticket_page.dart';
import 'student_notifications_page.dart';
import 'student_medical_request_page.dart';

class StudentDashboardPage extends StatelessWidget {
  const StudentDashboardPage({Key? key}) : super(key: key);

  // ✅ Student info — in production, pass this via constructor or provider
  static const String studentName = 'Rhithunath';
  static const String rollNumber = 'CS 068';
  static const String course = 'B.Tech CSE – Semester 6';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('STUDENT DASHBOARD'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.bell, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentNotificationsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.rightFromBracket, size: 20),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Student Info Card ───────────────────────────────────────
                Card(
                  color: const Color(0xFFECDCAB).withOpacity(0.3),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECDCAB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.userGraduate,
                            size: 32,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Welcome,',
                                style:
                                TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              const Text(
                                studentName,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  rollNumber,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFECDCAB),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                course,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // ─── Dashboard Grid ──────────────────────────────────────────
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildDashboardCard(
                      context,
                      title: 'Seat\nAllocation',
                      icon: FontAwesomeIcons.chair,
                      color: const Color(0xFFECDCAB),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const StudentSeatAllocationPage(),
                          ),
                        );
                      },
                    ),
                    _buildDashboardCard(
                      context,
                      title: 'Hall\nTicket',
                      icon: FontAwesomeIcons.ticketSimple,
                      color: const Color(0xFFECDCAB),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StudentHallTicketPage(),
                          ),
                        );
                      },
                    ),
                    _buildDashboardCard(
                      context,
                      title: 'Medical\nRequest',
                      icon: FontAwesomeIcons.notesMedical,
                      color: const Color(0xFFECDCAB),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const StudentMedicalRequestPage(),
                          ),
                        );
                      },
                    ),
                    _buildDashboardCard(
                      context,
                      title: 'Notifications',
                      icon: FontAwesomeIcons.bell,
                      color: const Color(0xFFECDCAB),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const StudentNotificationsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ─── Upcoming Exams Banner ───────────────────────────────────
                const Text(
                  'Upcoming Exams',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildExamBanner(
                  subject: 'Data Structures & Algorithms',
                  subjectCode: 'CS301',
                  date: '15 Mar 2026',
                  time: '09:00 AM',
                  hall: 'Hall A – Block 1',
                  seat: '47',
                ),
                const SizedBox(height: 12),
                _buildExamBanner(
                  subject: 'Computer Networks',
                  subjectCode: 'CS304',
                  date: '18 Mar 2026',
                  time: '02:00 PM',
                  hall: 'Hall B – Block 2',
                  seat: '23',
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: color.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: FaIcon(icon, size: 40, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamBanner({
    required String subject,
    required String subjectCode,
    required String date,
    required String time,
    required String hall,
    required String seat,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$subjectCode  •  $date  •  $time',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.buildingColumns,
                          size: 12, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(hall,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54)),
                      const SizedBox(width: 12),
                      const FaIcon(FontAwesomeIcons.chair,
                          size: 12, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text('Seat $seat',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFECDCAB).withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color(0xFFECDCAB).withOpacity(0.6)),
              ),
              child: Text(
                seat,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}