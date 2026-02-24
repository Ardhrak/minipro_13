import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'admin_seating_arrangement_page.dart';
import 'admin_invigilator_allocation_page.dart';
import 'admin_medical_requests_page.dart';
import 'admin_notifications_page.dart';



class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADMIN DASHBOARD'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.bell,
              size: 20,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminNotificationsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.rightFromBracket,
              size: 20,
            ),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView( // ✅ NEW: Made scrollable
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome, Admin',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage exam arrangements efficiently',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                // ✅ IMPROVED: Better grid layout
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85, // ✅ NEW: Better card proportions
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildDashboardCard(
                      context,
                      title: 'Seating\nArrangement',
                      icon: FontAwesomeIcons.chair,
                      color: const Color(0xFFECDCAB),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const AdminSeatingArrangementPage(),
                          ),
                        );
                      },
                    ),
                    _buildDashboardCard(
                      context,
                      title: 'Invigilator\nAllocation',
                      icon: FontAwesomeIcons.users,
                      color: const Color(0xFFECDCAB),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const AdminInvigilatorAllocationPage(),
                          ),
                        );
                      },
                    ),
                    _buildDashboardCard(
                      context,
                      title: 'Medical\nRequests',
                      icon: FontAwesomeIcons.notesMedical,
                      color: const Color(0xFFECDCAB),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const AdminMedicalRequestsPage(),
                          ),
                        );
                      },
                    ),
                    _buildDashboardCard(
                      context,
                      title: 'Send\nNotifications',
                      icon: FontAwesomeIcons.paperPlane,
                      color: const Color(0xFFECDCAB),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const AdminNotificationsPage(),
                          ),
                        );
                      },
                    ),
                  ],
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
      elevation: 4, // ✅ IMPROVED: Better shadow
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
                child: FaIcon(
                  icon,
                  size: 40,
                  color: Colors.black87,
                ),
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
}