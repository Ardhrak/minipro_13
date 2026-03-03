import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────────────────────────────────────

class InvigilatorData {
  static const Map<String, dynamic> profile = {
    'name': 'Dr. Sarah Johnson',
    'id': 'INV001',
    'department': 'Computer Science',
    'assignedHall': 'Hall A - Block 1',
    'examDate': '2026-03-15',
    'timeSlot': '09:00 AM - 12:00 PM',
    'subject': 'Mathematics',
    'status': 'confirmed',
    'hallCapacity': 30,
    'rows': 5,
    'cols': 6,
  };

  static const List<Map<String, dynamic>> students = [
    {'seat': 'A1', 'rollNo': 'CS2024001', 'name': 'Arjun Menon',        'course': 'B.Tech CS',   'present': true,  'hasMedical': false},
    {'seat': 'A2', 'rollNo': 'CS2024002', 'name': 'Priya Nair',         'course': 'B.Tech CS',   'present': true,  'hasMedical': false},
    {'seat': 'A3', 'rollNo': 'EC2024001', 'name': 'Rahul Das',          'course': 'B.Tech EC',   'present': false, 'hasMedical': false},
    {'seat': 'A4', 'rollNo': 'ME2024001', 'name': 'Sneha Pillai',       'course': 'B.Tech ME',   'present': true,  'hasMedical': false},
    {'seat': 'A5', 'rollNo': 'CS2024003', 'name': 'Aditya Kumar',       'course': 'B.Tech CS',   'present': true,  'hasMedical': false},
    {'seat': 'A6', 'rollNo': 'EC2024002', 'name': 'Meera Krishnan',     'course': 'B.Tech EC',   'present': true,  'hasMedical': true },
    {'seat': 'B1', 'rollNo': 'ME2024002', 'name': 'Vivek Sharma',       'course': 'B.Tech ME',   'present': true,  'hasMedical': false},
    {'seat': 'B2', 'rollNo': 'CS2024004', 'name': 'Divya Rajan',        'course': 'B.Tech CS',   'present': false, 'hasMedical': false},
    {'seat': 'B3', 'rollNo': 'EC2024003', 'name': 'Karthik Suresh',     'course': 'B.Tech EC',   'present': true,  'hasMedical': false},
    {'seat': 'B4', 'rollNo': 'CS2024005', 'name': 'Anjali Mohan',       'course': 'B.Tech CS',   'present': true,  'hasMedical': false},
    {'seat': 'B5', 'rollNo': 'ME2024003', 'name': 'Rohan Iyer',         'course': 'B.Tech ME',   'present': true,  'hasMedical': false},
    {'seat': 'B6', 'rollNo': 'EC2024004', 'name': 'Nisha Thomas',       'course': 'B.Tech EC',   'present': true,  'hasMedical': false},
    {'seat': 'C1', 'rollNo': 'CS2024006', 'name': 'Suresh Babu',        'course': 'B.Tech CS',   'present': true,  'hasMedical': false},
    {'seat': 'C2', 'rollNo': 'ME2024004', 'name': 'Lakshmi Varma',      'course': 'B.Tech ME',   'present': false, 'hasMedical': false},
    {'seat': 'C3', 'rollNo': 'EC2024005', 'name': 'Nikhil George',      'course': 'B.Tech EC',   'present': true,  'hasMedical': false},
    {'seat': 'C4', 'rollNo': 'CS2024007', 'name': 'Pooja Chandran',     'course': 'B.Tech CS',   'present': true,  'hasMedical': false},
    {'seat': 'C5', 'rollNo': 'ME2024005', 'name': 'Anand Rajesh',       'course': 'B.Tech ME',   'present': true,  'hasMedical': false},
    {'seat': 'C6', 'rollNo': 'EC2024006', 'name': 'Sruthi Madhavan',    'course': 'B.Tech EC',   'present': true,  'hasMedical': true },
    {'seat': 'D1', 'rollNo': 'CS2024008', 'name': 'Abhijit Paul',       'course': 'B.Tech CS',   'present': true,  'hasMedical': false},
    {'seat': 'D2', 'rollNo': 'ME2024006', 'name': 'Kavya Menon',        'course': 'B.Tech ME',   'present': true,  'hasMedical': false},
    {'seat': 'D3', 'rollNo': 'EC2024007', 'name': 'Jithin Mathew',      'course': 'B.Tech EC',   'present': false, 'hasMedical': false},
    {'seat': 'D4', 'rollNo': 'CS2024009', 'name': 'Athira Pillai',      'course': 'B.Tech CS',   'present': true,  'hasMedical': false},
    {'seat': 'D5', 'rollNo': 'ME2024007', 'name': 'Manoj Nair',         'course': 'B.Tech ME',   'present': true,  'hasMedical': false},
    {'seat': 'D6', 'rollNo': 'EC2024008', 'name': 'Reetha Joseph',      'course': 'B.Tech EC',   'present': true,  'hasMedical': false},
    {'seat': 'E1', 'rollNo': 'CS2024010', 'name': 'Sanjay Kumar',       'course': 'B.Tech CS',   'present': true,  'hasMedical': false},
    {'seat': 'E2', 'rollNo': 'ME2024008', 'name': 'Fathima Beevi',      'course': 'B.Tech ME',   'present': true,  'hasMedical': false},
    {'seat': 'E3', 'rollNo': 'EC2024009', 'name': 'Tharun Menon',       'course': 'B.Tech EC',   'present': true,  'hasMedical': false},
    {'seat': 'E4', 'rollNo': 'CS2024011', 'name': 'Geetha Krishnan',    'course': 'B.Tech CS',   'present': false, 'hasMedical': false},
    {'seat': 'E5', 'rollNo': 'ME2024009', 'name': 'Vishnu Prakash',     'course': 'B.Tech ME',   'present': true,  'hasMedical': false},
    {'seat': 'E6', 'rollNo': 'EC2024010', 'name': 'Amrutha Suresh',     'course': 'B.Tech EC',   'present': true,  'hasMedical': false},
  ];

  static const List<Map<String, dynamic>> submittedReports = [
    {
      'type': 'malpractice',
      'studentName': 'Rahul Das',
      'studentSeat': 'A3',
      'description': 'Student found with cheat sheet hidden in pencil case.',
      'severity': 'high',
      'time': '09:45 AM',
      'status': 'submitted',
    },
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN DASHBOARD PAGE
// ─────────────────────────────────────────────────────────────────────────────

class InvigilatorDashboardPage extends StatefulWidget {
  const InvigilatorDashboardPage({Key? key}) : super(key: key);

  @override
  State<InvigilatorDashboardPage> createState() =>
      _InvigilatorDashboardPageState();
}

class _InvigilatorDashboardPageState extends State<InvigilatorDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mutable attendance state
  late List<Map<String, dynamic>> _students;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Deep-copy so we can mutate attendance
    _students = InvigilatorData.students
        .map((s) => Map<String, dynamic>.from(s))
        .toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Convenience getters ──────────────────────────────────────────────────
  int get _presentCount => _students.where((s) => s['present'] == true).length;
  int get _absentCount  => _students.where((s) => s['present'] == false).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('INVIGILATOR DASHBOARD'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.bell, size: 20),
            onPressed: () => _showNotificationsSheet(context),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.rightFromBracket, size: 20),
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black87,
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.black45,
          isScrollable: true,
          tabs: const [
            Tab(icon: FaIcon(FontAwesomeIcons.house,          size: 18), text: 'Overview'),
            Tab(icon: FaIcon(FontAwesomeIcons.tableCells,      size: 18), text: 'Hall Layout'),
            Tab(icon: FaIcon(FontAwesomeIcons.clipboardUser,   size: 18), text: 'Attendance'),
            Tab(icon: FaIcon(FontAwesomeIcons.triangleExclamation, size: 18), text: 'Report'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _OverviewTab(
            students: _students,
            presentCount: _presentCount,
            absentCount: _absentCount,
            onGoToAttendance: () => _tabController.animateTo(2),
            onGoToHallLayout: () => _tabController.animateTo(1),
            onGoToReport:     () => _tabController.animateTo(3),
          ),
          _HallLayoutTab(students: _students),
          _AttendanceTab(
            students: _students,
            onToggle: (index) {
              setState(() {
                _students[index]['present'] = !(_students[index]['present'] as bool);
              });
            },
            onMarkAllPresent: () {
              setState(() {
                for (final s in _students) s['present'] = true;
              });
            },
            onSubmitAttendance: () => _submitAttendanceDialog(context),
          ),
          _ReportTab(),
        ],
      ),
    );
  }

  // ── Notifications bottom sheet ───────────────────────────────────────────
  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const FaIcon(FontAwesomeIcons.bell, size: 20),
              const SizedBox(width: 12),
              const Text('Notifications',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ]),
            const Divider(height: 24),
            _buildNotifTile(FontAwesomeIcons.circleInfo, Colors.blue,
                'Exam starts in 30 minutes', 'Report to Hall A - Block 1 by 8:45 AM'),
            const SizedBox(height: 12),
            _buildNotifTile(FontAwesomeIcons.bell, const Color(0xFFECDCAB).withOpacity(2),
                'Admin: Invigilator Meeting', 'Feb 16, 3 PM at Admin Block'),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifTile(IconData icon, Color color, String title, String sub) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(children: [
        FaIcon(icon, size: 18, color: color),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 2),
            Text(sub, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        )),
      ]),
    );
  }

  // ── Attendance submission dialog ─────────────────────────────────────────
  void _submitAttendanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: const [
          FaIcon(FontAwesomeIcons.clipboardCheck, size: 20),
          SizedBox(width: 12),
          Text('Submit Attendance'),
        ]),
        content: Text(
          'Submit attendance?\n\n'
              'Present: $_presentCount  •  Absent: $_absentCount\n\n'
              'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Attendance submitted successfully!'),
                backgroundColor: Colors.green,
              ));
            },
            icon: const FaIcon(FontAwesomeIcons.check, size: 16),
            label: const Text('SUBMIT'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 1 — OVERVIEW
// ─────────────────────────────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  final List<Map<String, dynamic>> students;
  final int presentCount;
  final int absentCount;
  final VoidCallback onGoToAttendance;
  final VoidCallback onGoToHallLayout;
  final VoidCallback onGoToReport;

  const _OverviewTab({
    required this.students,
    required this.presentCount,
    required this.absentCount,
    required this.onGoToAttendance,
    required this.onGoToHallLayout,
    required this.onGoToReport,
  });

  @override
  Widget build(BuildContext context) {
    final profile = InvigilatorData.profile;
    final total   = students.length;
    final pct     = total > 0 ? presentCount / total : 0.0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Greeting banner ──────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFECDCAB).withOpacity(0.35),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFECDCAB), width: 1.5),
              ),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECDCAB).withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const FaIcon(FontAwesomeIcons.clipboardUser, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome, ${profile['name']}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${profile['id']} • ${profile['department']}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    _StatusBadge(status: profile['status']),
                  ],
                )),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Exam assignment card ─────────────────────────────────────
            _SectionLabel(icon: FontAwesomeIcons.bookOpen, label: 'Assigned Exam'),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  _InfoRow(FontAwesomeIcons.locationDot, 'Hall',     profile['assignedHall']),
                  const SizedBox(height: 10),
                  _InfoRow(FontAwesomeIcons.bookOpen,    'Subject',  profile['subject']),
                  const SizedBox(height: 10),
                  _InfoRow(FontAwesomeIcons.calendar,    'Date',     profile['examDate']),
                  const SizedBox(height: 10),
                  _InfoRow(FontAwesomeIcons.clock,       'Timeslot', profile['timeSlot']),
                  const SizedBox(height: 10),
                  _InfoRow(FontAwesomeIcons.chair,       'Capacity', '${profile['hallCapacity']} seats'),
                ]),
              ),
            ),
            const SizedBox(height: 16),

            // ── Attendance summary ───────────────────────────────────────
            _SectionLabel(icon: FontAwesomeIcons.chartPie, label: 'Attendance Summary'),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Row(children: [
                    _StatChip(label: 'Total',   value: '$total',        color: Colors.blueGrey),
                    const SizedBox(width: 10),
                    _StatChip(label: 'Present', value: '$presentCount', color: Colors.green),
                    const SizedBox(width: 10),
                    _StatChip(label: 'Absent',  value: '$absentCount',  color: Colors.red),
                  ]),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Attendance', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      Text('${(pct * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 8,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        pct >= 0.9 ? Colors.green : pct >= 0.7 ? Colors.orange : Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onGoToAttendance,
                      icon: const FaIcon(FontAwesomeIcons.clipboardUser, size: 16),
                      label: const Text('MARK ATTENDANCE'),
                    ),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 16),

            // ── Quick actions ────────────────────────────────────────────
            _SectionLabel(icon: FontAwesomeIcons.boltLightning, label: 'Quick Actions'),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _QuickActionCard(
                icon: FontAwesomeIcons.tableCells,
                label: 'View\nHall Layout',
                color: const Color(0xFFECDCAB),
                onTap: onGoToHallLayout,
              )),
              const SizedBox(width: 12),
              Expanded(child: _QuickActionCard(
                icon: FontAwesomeIcons.triangleExclamation,
                label: 'Report\nIncident',
                color: Colors.red.shade50,
                onTap: onGoToReport,
              )),
            ]),
            const SizedBox(height: 16),

            // ── Medical students notice ──────────────────────────────────
            Builder(builder: (_) {
              final medStudents = students.where((s) => s['hasMedical'] == true).toList();
              if (medStudents.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(icon: FontAwesomeIcons.heartPulse, label: 'Medical Accommodations'),
                  const SizedBox(height: 8),
                  ...medStudents.map((s) => _MedicalAlertTile(student: s)),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 2 — HALL LAYOUT  (visual seating grid)
// ─────────────────────────────────────────────────────────────────────────────

class _HallLayoutTab extends StatefulWidget {
  final List<Map<String, dynamic>> students;
  const _HallLayoutTab({required this.students});

  @override
  State<_HallLayoutTab> createState() => _HallLayoutTabState();
}

class _HallLayoutTabState extends State<_HallLayoutTab> {
  Map<String, dynamic>? _selectedStudent;

  @override
  Widget build(BuildContext context) {
    final profile = InvigilatorData.profile;
    final rows    = profile['rows'] as int;
    final cols    = profile['cols'] as int;
    final rowLabels = List.generate(rows, (i) => String.fromCharCode(65 + i)); // A, B, C…

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile['assignedHall'],
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('${profile['subject']} • ${profile['examDate']}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              )),
              _LegendDot(color: Colors.green,   label: 'Present'),
              const SizedBox(width: 10),
              _LegendDot(color: Colors.red,     label: 'Absent'),
              const SizedBox(width: 10),
              _LegendDot(color: Colors.blue,    label: 'Medical'),
            ]),
            const SizedBox(height: 16),

            // ── FRONT OF HALL label ──────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('FRONT — INVIGILATOR DESK',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                        letterSpacing: 1.5, fontSize: 13)),
              ),
            ),
            const SizedBox(height: 12),

            // ── Seat grid ────────────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: List.generate(rows, (r) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          // Row label
                          SizedBox(
                            width: 20,
                            child: Text(rowLabels[r],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.grey[600])),
                          ),
                          const SizedBox(width: 6),
                          // Seats
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(cols, (c) {
                                final seatId = '${rowLabels[r]}${c + 1}';
                                final student = widget.students.firstWhere(
                                      (s) => s['seat'] == seatId,
                                  orElse: () => {},
                                );
                                final isEmpty = student.isEmpty;
                                return _SeatCell(
                                  seatId: seatId,
                                  student: isEmpty ? null : student,
                                  isSelected: _selectedStudent != null &&
                                      _selectedStudent!['seat'] == seatId,
                                  onTap: () {
                                    setState(() {
                                      _selectedStudent =
                                      (!isEmpty && _selectedStudent?['seat'] != seatId)
                                          ? student
                                          : null;
                                    });
                                  },
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Column numbers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(cols, (c) => Text('${c + 1}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]))),
              ),
            ),
            const SizedBox(height: 16),

            // ── Selected student detail card ──────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _selectedStudent != null
                  ? _StudentDetailCard(
                key: ValueKey(_selectedStudent!['seat']),
                student: _selectedStudent!,
                onClose: () => setState(() => _selectedStudent = null),
              )
                  : Container(
                key: const ValueKey('empty'),
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(children: [
                  FaIcon(FontAwesomeIcons.handPointer, size: 28, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text('Tap a seat to view student details',
                      style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 3 — ATTENDANCE
// ─────────────────────────────────────────────────────────────────────────────

class _AttendanceTab extends StatefulWidget {
  final List<Map<String, dynamic>> students;
  final ValueChanged<int> onToggle;
  final VoidCallback onMarkAllPresent;
  final VoidCallback onSubmitAttendance;

  const _AttendanceTab({
    required this.students,
    required this.onToggle,
    required this.onMarkAllPresent,
    required this.onSubmitAttendance,
  });

  @override
  State<_AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<_AttendanceTab> {
  String _search = '';

  List<Map<String, dynamic>> get _filtered {
    if (_search.isEmpty) return widget.students;
    final q = _search.toLowerCase();
    return widget.students.where((s) =>
    s['name'].toString().toLowerCase().contains(q) ||
        s['rollNo'].toString().toLowerCase().contains(q) ||
        s['seat'].toString().toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final total   = widget.students.length;
    final present = widget.students.where((s) => s['present'] == true).length;
    final absent  = total - present;

    return SafeArea(
      child: Column(
        children: [
          // ── Summary bar ────────────────────────────────────────────────
          Container(
            color: const Color(0xFFECDCAB).withOpacity(0.25),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              _AttStat(label: 'Total',   value: '$total',   color: Colors.blueGrey),
              _divider(),
              _AttStat(label: 'Present', value: '$present', color: Colors.green),
              _divider(),
              _AttStat(label: 'Absent',  value: '$absent',  color: Colors.red),
              const Spacer(),
              TextButton.icon(
                onPressed: widget.onMarkAllPresent,
                icon: const FaIcon(FontAwesomeIcons.circleCheck, size: 14),
                label: const Text('All Present', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ]),
          ),

          // ── Search bar ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search by name, roll no, seat...',
                prefixIcon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 16),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                  icon: const FaIcon(FontAwesomeIcons.xmark, size: 14),
                  onPressed: () => setState(() => _search = ''),
                )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
            ),
          ),

          // ── Student list ───────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) {
                final student = _filtered[i];
                // Find global index for the toggle callback
                final globalIdx = widget.students.indexWhere(
                        (s) => s['seat'] == student['seat']);
                final isPresent = student['present'] as bool;
                final hasMed    = student['hasMedical'] as bool;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => widget.onToggle(globalIdx),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(children: [
                        // Seat badge
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isPresent
                                ? Colors.green.withOpacity(0.15)
                                : Colors.red.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isPresent ? Colors.green.shade300 : Colors.red.shade300,
                            ),
                          ),
                          child: Center(
                            child: Text(student['seat'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isPresent ? Colors.green.shade700 : Colors.red.shade700,
                                )),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Expanded(
                                child: Text(student['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 15)),
                              ),
                              if (hasMed)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                                    const FaIcon(FontAwesomeIcons.heartPulse,
                                        size: 10, color: Colors.blue),
                                    const SizedBox(width: 4),
                                    Text('Medical',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                                ),
                            ]),
                            const SizedBox(height: 3),
                            Text('${student['rollNo']} • ${student['course']}',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ],
                        )),
                        const SizedBox(width: 8),
                        // Toggle chip
                        GestureDetector(
                          onTap: () => widget.onToggle(globalIdx),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isPresent
                                  ? Colors.green
                                  : Colors.red.shade400,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              FaIcon(
                                isPresent
                                    ? FontAwesomeIcons.check
                                    : FontAwesomeIcons.xmark,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                isPresent ? 'Present' : 'Absent',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Submit button ───────────────────────────────────────────────
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: widget.onSubmitAttendance,
                  icon: const FaIcon(FontAwesomeIcons.paperPlane, size: 18),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text('SUBMIT ATTENDANCE',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
      height: 28, width: 1, color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 12));
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 4 — INCIDENT REPORT
// ─────────────────────────────────────────────────────────────────────────────

class _ReportTab extends StatefulWidget {
  const _ReportTab();

  @override
  State<_ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends State<_ReportTab> {
  final _formKey = GlobalKey<FormState>();
  String _incidentType = 'malpractice';
  String _severity     = 'medium';
  final _descController    = TextEditingController();
  final _studentController = TextEditingController();

  late List<Map<String, dynamic>> _reports;

  @override
  void initState() {
    super.initState();
    _reports = InvigilatorData.submittedReports
        .map((r) => Map<String, dynamic>.from(r))
        .toList();
  }

  @override
  void dispose() {
    _descController.dispose();
    _studentController.dispose();
    super.dispose();
  }

  static const _incidentTypes = {
    'malpractice':  'Malpractice / Cheating',
    'disturbance':  'Disturbance',
    'medical':      'Medical Emergency',
    'technical':    'Technical Issue',
    'other':        'Other',
  };

  static const _severityColors = {
    'low':    Colors.blue,
    'medium': Colors.orange,
    'high':   Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Submitted reports ─────────────────────────────────────────
            if (_reports.isNotEmpty) ...[
              _SectionLabel(
                  icon: FontAwesomeIcons.clipboardList,
                  label: 'Submitted Reports (${_reports.length})'),
              const SizedBox(height: 8),
              ..._reports.map((r) => _SubmittedReportCard(report: r)),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
            ],

            // ── New report form ───────────────────────────────────────────
            _SectionLabel(
                icon: FontAwesomeIcons.triangleExclamation,
                label: 'Submit New Incident Report'),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Incident type
                      DropdownButtonFormField<String>(
                        value: _incidentType,
                        decoration: const InputDecoration(
                          labelText: 'Incident Type',
                          prefixIcon: FaIcon(FontAwesomeIcons.tag, size: 18),
                        ),
                        items: _incidentTypes.entries
                            .map((e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ))
                            .toList(),
                        onChanged: (v) => setState(() => _incidentType = v!),
                      ),
                      const SizedBox(height: 16),

                      // Severity
                      const Text('Severity',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54)),
                      const SizedBox(height: 8),
                      Row(children: ['low', 'medium', 'high'].map((sev) {
                        final isSelected = _severity == sev;
                        final color = _severityColors[sev]!;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => setState(() => _severity = sev),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color.withOpacity(0.18)
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected ? color : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    sev[0].toUpperCase() + sev.substring(1),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? color : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList()),
                      const SizedBox(height: 16),

                      // Student involved (optional)
                      TextFormField(
                        controller: _studentController,
                        decoration: const InputDecoration(
                          labelText: 'Student Involved (optional)',
                          hintText: 'Seat No. or Roll No.',
                          prefixIcon: FaIcon(FontAwesomeIcons.userGraduate, size: 18),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      TextFormField(
                        controller: _descController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Description *',
                          hintText: 'Describe the incident in detail...',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 60),
                            child: FaIcon(FontAwesomeIcons.penToSquare, size: 18),
                          ),
                          alignLabelWithHint: true,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Description is required'
                            : null,
                      ),
                      const SizedBox(height: 8),

                      // Severity info
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (_severityColors[_severity]!).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: (_severityColors[_severity]!).withOpacity(0.3)),
                        ),
                        child: Row(children: [
                          FaIcon(FontAwesomeIcons.circleInfo,
                              size: 14, color: _severityColors[_severity]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getSeverityInfo(_severity),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: (_severityColors[_severity]!).withOpacity(0.9)),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 20),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submitReport,
                          icon: const FaIcon(FontAwesomeIcons.paperPlane, size: 18),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text('SUBMIT REPORT',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD32F2F),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSeverityInfo(String severity) {
    switch (severity) {
      case 'high':   return 'High severity: Admin will be notified immediately.';
      case 'medium': return 'Medium severity: Will be reviewed after the exam session.';
      default:       return 'Low severity: Logged for record purposes.';
    }
  }

  void _submitReport() {
    if (!_formKey.currentState!.validate()) return;
    final now = TimeOfDay.now();
    final timeStr =
        '${now.hourOfPeriod.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.period.name.toUpperCase()}';

    setState(() {
      _reports.insert(0, {
        'type':        _incidentType,
        'studentName': _studentController.text.isNotEmpty
            ? _studentController.text
            : 'Unknown',
        'studentSeat': _studentController.text,
        'description': _descController.text.trim(),
        'severity':    _severity,
        'time':        timeStr,
        'status':      'submitted',
      });
      _descController.clear();
      _studentController.clear();
      _incidentType = 'malpractice';
      _severity     = 'medium';
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: const [
        FaIcon(FontAwesomeIcons.circleCheck, color: Colors.white, size: 18),
        SizedBox(width: 12),
        Text('Incident report submitted successfully!'),
      ]),
      backgroundColor: Colors.green,
    ));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED SMALL WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      FaIcon(icon, size: 16, color: Colors.black54),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
    ]);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      FaIcon(icon, size: 14, color: Colors.grey[600]),
      const SizedBox(width: 10),
      SizedBox(
        width: 72,
        child: Text(label,
            style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      ),
      Expanded(
        child: Text(value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ),
    ]);
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(children: [
          Text(value,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(fontSize: 11, color: color.withOpacity(0.8))),
        ]),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickActionCard(
      {required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.7), width: 1.5),
                ),
                child: FaIcon(icon, size: 28, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, height: 1.3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    switch (status) {
      case 'confirmed':
        color = Colors.green; icon = FontAwesomeIcons.circleCheck; break;
      case 'pending':
        color = Colors.orange; icon = FontAwesomeIcons.clock; break;
      default:
        color = Colors.grey; icon = FontAwesomeIcons.circle;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        FaIcon(icon, size: 10, color: color),
        const SizedBox(width: 5),
        Text(status.toUpperCase(),
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
      ]),
    );
  }
}

class _MedicalAlertTile extends StatelessWidget {
  final Map<String, dynamic> student;
  const _MedicalAlertTile({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.withOpacity(0.25)),
      ),
      child: Row(children: [
        const FaIcon(FontAwesomeIcons.heartPulse, size: 16, color: Colors.blue),
        const SizedBox(width: 10),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(student['name'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('Seat ${student['seat']} • ${student['rollNo']}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text('Medical',
              style: TextStyle(
                  fontSize: 11, color: Colors.blue, fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }
}

// ── Hall Layout sub-widgets ──────────────────────────────────────────────────

class _SeatCell extends StatelessWidget {
  final String seatId;
  final Map<String, dynamic>? student;
  final bool isSelected;
  final VoidCallback onTap;

  const _SeatCell({
    required this.seatId,
    this.student,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (student == null) {
      return _buildCell(Colors.grey.shade200, Colors.grey.shade400, null);
    }
    final isPresent = student!['present'] as bool;
    final hasMed    = student!['hasMedical'] as bool;
    final bg = hasMed
        ? Colors.blue.withOpacity(0.2)
        : isPresent
        ? Colors.green.withOpacity(0.18)
        : Colors.red.withOpacity(0.15);
    final border = hasMed
        ? Colors.blue.shade300
        : isPresent
        ? Colors.green.shade400
        : Colors.red.shade300;

    return _buildCell(bg, border, student);
  }

  Widget _buildCell(Color bg, Color border, Map<String, dynamic>? s) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFECDCAB) : bg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? Colors.black87 : border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 2))]
              : null,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(seatId,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: s == null ? Colors.grey.shade400 : Colors.black87)),
              if (s != null && (s['hasMedical'] as bool))
                const FaIcon(FontAwesomeIcons.heartPulse, size: 8, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 11)),
    ]);
  }
}

class _StudentDetailCard extends StatelessWidget {
  final Map<String, dynamic> student;
  final VoidCallback onClose;
  const _StudentDetailCard({super.key, required this.student, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final isPresent = student['present'] as bool;
    final hasMed    = student['hasMedical'] as bool;

    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: const Color(0xFFECDCAB), width: 1.5)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFECDCAB).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const FaIcon(FontAwesomeIcons.userGraduate, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student['name'],
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 3),
                  Text(student['rollNo'],
                      style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              )),
              IconButton(
                onPressed: onClose,
                icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ]),
            const Divider(height: 20),
            Row(children: [
              _DetailChip(
                  label: 'Seat',
                  value: student['seat'],
                  icon: FontAwesomeIcons.chair,
                  color: Colors.blueGrey),
              const SizedBox(width: 8),
              _DetailChip(
                  label: 'Status',
                  value: isPresent ? 'Present' : 'Absent',
                  icon: isPresent ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
                  color: isPresent ? Colors.green : Colors.red),
            ]),
            const SizedBox(height: 10),
            _InfoRow(FontAwesomeIcons.graduationCap, 'Course', student['course']),
            if (hasMed) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(children: const [
                  FaIcon(FontAwesomeIcons.heartPulse, size: 14, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This student has medical accommodations. Check admin notes.',
                      style: TextStyle(
                          fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _DetailChip(
      {required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(children: [
          FaIcon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: TextStyle(fontSize: 10, color: color.withOpacity(0.8))),
            Text(value,
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold, color: color)),
          ]),
        ]),
      ),
    );
  }
}

// ── Report sub-widgets ───────────────────────────────────────────────────────

class _SubmittedReportCard extends StatelessWidget {
  final Map<String, dynamic> report;
  const _SubmittedReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    const severityColors = {
      'low': Colors.blue, 'medium': Colors.orange, 'high': Colors.red
    };
    final sev   = report['severity'] as String;
    final color = (severityColors[sev] ?? Colors.grey) as Color;
    final type  = report['type'] as String;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FaIcon(
                  type == 'malpractice' ? FontAwesomeIcons.userXmark
                      : type == 'medical' ? FontAwesomeIcons.kitMedical
                      : FontAwesomeIcons.triangleExclamation,
                  size: 18, color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type[0].toUpperCase() + type.substring(1),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text('Time: ${report['time']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(sev.toUpperCase(),
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.bold, color: color)),
              ),
            ]),
            const SizedBox(height: 10),
            if ((report['studentName'] as String).isNotEmpty &&
                report['studentName'] != 'Unknown')
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  FaIcon(FontAwesomeIcons.userGraduate,
                      size: 12, color: Colors.grey[500]),
                  const SizedBox(width: 6),
                  Text('Student: ${report['studentName']} (${report['studentSeat']})',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ]),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(report['description'],
                  style: const TextStyle(fontSize: 13, height: 1.4)),
            ),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const FaIcon(FontAwesomeIcons.circleCheck, size: 10, color: Colors.green),
                  const SizedBox(width: 5),
                  const Text('Submitted',
                      style: TextStyle(
                          fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
                ]),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _AttStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _AttStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label,
            style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}