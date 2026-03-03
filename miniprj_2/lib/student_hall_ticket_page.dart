import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentHallTicketPage extends StatelessWidget {
  const StudentHallTicketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HALL TICKET'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.download, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Hall Ticket downloaded successfully!'),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // ─── Hall Ticket Card ──────────────────────────────────────
              Card(
                elevation: 4,
                shadowColor: Colors.black26,
                child: Column(
                  children: [
                    // Header stripe
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 20),
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'UNIVERSITY OF TECHNOLOGY',
                            style: TextStyle(
                              color: Color(0xFFECDCAB),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'EXAMINATION HALL TICKET',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color:
                              const Color(0xFFECDCAB).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: const Color(0xFFECDCAB)
                                      .withOpacity(0.4)),
                            ),
                            child: const Text(
                              'End Semester Examinations – March 2026',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Student details
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Student photo placeholder
                              Container(
                                width: 90,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECDCAB)
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color(0xFFECDCAB),
                                      width: 2),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(FontAwesomeIcons.userGraduate,
                                        size: 36, color: Colors.black54),
                                    SizedBox(height: 6),
                                    Text('PHOTO',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black45,
                                            letterSpacing: 1)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _infoRow('Name', 'Arjun Menon'),
                                    _infoRow('Roll No.', '22CS047'),
                                    _infoRow('Course', 'B.Tech CSE'),
                                    _infoRow('Semester', '6th Semester'),
                                    _infoRow('Batch', '2022 – 2026'),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 12),

                          // Schedule table header
                          Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.calendarDays,
                                  size: 16, color: Colors.black87),
                              const SizedBox(width: 8),
                              const Text(
                                'Examination Schedule',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Table
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                  const Color(0xFFECDCAB).withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                _tableHeader(),
                                _tableRow('CS301', 'Data Structures',
                                    '15 Mar', '09:00 AM', 'A-47', false),
                                _tableRow('CS302', 'Operating Systems',
                                    '18 Mar', '09:00 AM', 'A-11', true),
                                _tableRow('CS304', 'Computer Networks',
                                    '20 Mar', '02:00 PM', 'B-23', false),
                                _tableRow('CS305', 'Compiler Design',
                                    '22 Mar', '09:00 AM', 'A-30', true),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 12),

                          // Instructions
                          Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.triangleExclamation,
                                  size: 16, color: Colors.black87),
                              const SizedBox(width: 8),
                              const Text(
                                'Instructions',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _instruction(
                              '1',
                              'Carry this hall ticket and a valid college ID to every exam.'),
                          _instruction(
                              '2',
                              'Report to the hall at least 15 minutes before start time.'),
                          _instruction(
                              '3',
                              'Electronic devices are strictly prohibited inside the hall.'),
                          _instruction(
                              '4',
                              'Hall ticket must be signed by the class teacher before the exam.'),
                        ],
                      ),
                    ),

                    // Footer
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECDCAB).withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Generated: Feb 2026',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[600]),
                          ),
                          Text(
                            'Ticket No: HT-2026-22CS047',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Download button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                          Text('Hall Ticket downloaded as PDF!')),
                    );
                  },
                  icon: const FaIcon(FontAwesomeIcons.filePdf, size: 18),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text('DOWNLOAD AS PDF'),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(label,
                style:
                TextStyle(fontSize: 12, color: Colors.grey[500])),
          ),
          const Text(': ',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('Code',
                style: TextStyle(
                    color: Color(0xFFECDCAB),
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 4,
            child: Text('Subject',
                style: TextStyle(
                    color: Color(0xFFECDCAB),
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text('Date',
                style: TextStyle(
                    color: Color(0xFFECDCAB),
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text('Time',
                style: TextStyle(
                    color: Color(0xFFECDCAB),
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text('Seat',
                style: TextStyle(
                    color: Color(0xFFECDCAB),
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _tableRow(String code, String subject, String date, String time,
      String seat, bool alternate) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: alternate
          ? const Color(0xFFECDCAB).withOpacity(0.08)
          : Colors.transparent,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(code,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 4,
            child: Text(subject,
                style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 3,
            child: Text(date,
                style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 3,
            child: Text(time,
                style: const TextStyle(fontSize: 11)),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFECDCAB),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                seat,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _instruction(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                    color: Color(0xFFECDCAB),
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}