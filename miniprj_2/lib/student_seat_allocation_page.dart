import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentSeatAllocationPage extends StatefulWidget {
  const StudentSeatAllocationPage({Key? key}) : super(key: key);

  @override
  State<StudentSeatAllocationPage> createState() =>
      _StudentSeatAllocationPageState();
}

class _StudentSeatAllocationPageState
    extends State<StudentSeatAllocationPage> {
  // Mock data — in production, fetch from backend
  final List<Map<String, dynamic>> _examSeats = [
    {
      'subject': 'Data Structures & Algorithms',
      'subjectCode': 'CS301',
      'date': '15 Mar 2026',
      'time': '09:00 AM – 12:00 PM',
      'hall': 'Hall A – Block 1',
      'seat': '47',
      'row': 'D',
      'column': '7',
      'building': 'Academic Block North',
    },
    {
      'subject': 'Computer Networks',
      'subjectCode': 'CS304',
      'date': '18 Mar 2026',
      'time': '02:00 PM – 05:00 PM',
      'hall': 'Hall B – Block 2',
      'seat': '23',
      'row': 'B',
      'column': '3',
      'building': 'Academic Block South',
    },
    {
      'subject': 'Operating Systems',
      'subjectCode': 'CS302',
      'date': '20 Mar 2026',
      'time': '09:00 AM – 12:00 PM',
      'hall': 'Hall A – Block 1',
      'seat': '11',
      'row': 'A',
      'column': '11',
      'building': 'Academic Block North',
    },
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selected = _examSeats[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SEAT ALLOCATION'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Seat Allocations',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Select an exam to view seat details',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),

              // ─── Exam Selector ───────────────────────────────────────────
              // ✅ FIX: Use intrinsic height via shrinkWrap row instead of a
              //         fixed SizedBox height that clips content on some devices.
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_examSeats.length, (index) {
                    final exam = _examSeats[index];
                    final isSelected = index == _selectedIndex;
                    return Padding(
                      padding: EdgeInsets.only(
                          right: index < _examSeats.length - 1 ? 12 : 0),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 150,
                          // ✅ FIX: No fixed height — let content define height
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black87 : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.black87
                                  : const Color(0xFFECDCAB),
                              width: 2,
                            ),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min, // ✅ FIX: shrink to content
                            children: [
                              Text(
                                exam['subjectCode'],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? const Color(0xFFECDCAB)
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                exam['date'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected
                                      ? Colors.white70
                                      : Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Seat ${exam['seat']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 24),

              // ─── Selected Seat Detail Card ───────────────────────────────
              Card(
                elevation: 4,
                shadowColor: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Subject header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECDCAB).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color:
                                  const Color(0xFFECDCAB).withOpacity(0.5),
                                  width: 2),
                            ),
                            child: const FaIcon(FontAwesomeIcons.bookOpen,
                                size: 28, color: Colors.black87),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selected['subject'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  selected['subjectCode'],
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 12),

                      // ✅ FIX: Replace rigid 100×100 fixed box with
                      //         intrinsically sized container + FittedBox so
                      //         the text never overflows at any font scale.
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 90,
                            minHeight: 90,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECDCAB),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.black87.withOpacity(0.3),
                                width: 3),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  selected['seat'],
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'SEAT',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Row ${selected['row']} • Column ${selected['column']}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),

                      const SizedBox(height: 20),

                      // Detail rows
                      _buildDetailRow(
                          FontAwesomeIcons.calendar, 'Date', selected['date']),
                      const SizedBox(height: 10),
                      _buildDetailRow(
                          FontAwesomeIcons.clock, 'Time', selected['time']),
                      const SizedBox(height: 10),
                      _buildDetailRow(FontAwesomeIcons.buildingColumns, 'Hall',
                          selected['hall']),
                      const SizedBox(height: 10),
                      _buildDetailRow(FontAwesomeIcons.locationDot, 'Building',
                          selected['building']),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ─── Info Banner ─────────────────────────────────────────────
              Card(
                color: const Color(0xFFECDCAB).withOpacity(0.2),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.circleInfo,
                          size: 18, color: Colors.black87),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Please carry your Hall Ticket and a valid college ID card to the examination hall.',
                          style:
                          TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                      ),
                    ],
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFECDCAB).withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: FaIcon(icon, size: 16, color: Colors.black87)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                  TextStyle(fontSize: 11, color: Colors.grey[500])),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}