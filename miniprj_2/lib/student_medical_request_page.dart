import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentMedicalRequestPage extends StatefulWidget {
  const StudentMedicalRequestPage({super.key});

  @override
  State<StudentMedicalRequestPage> createState() =>
      _StudentMedicalRequestPageState();
}

class _StudentMedicalRequestPageState
    extends State<StudentMedicalRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _detailsController = TextEditingController();
  String? _selectedExam;
  String? _selectedAccommodation;
  bool _submitted = false;

  final List<String> _upcomingExams = [
    'CS301 – Data Structures (15 Mar)',
    'CS302 – Operating Systems (18 Mar)',
    'CS304 – Computer Networks (20 Mar)',
    'CS305 – Compiler Design (22 Mar)',
  ];

  final List<String> _accommodations = [
    'Extra time (+30 min)',
    'Scribe / Writer',
    'Separate room',
    'Ground floor hall',
    'Other',
  ];

  // Past requests
  final List<Map<String, dynamic>> _pastRequests = [
    {
      'exam': 'CS201 – Data Structures',
      'date': '10 Nov 2025',
      'status': 'approved',
      'accommodation': 'Extra time (+30 min)',
    },
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate() &&
        _selectedExam != null &&
        _selectedAccommodation != null) {
      setState(() => _submitted = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medical accommodation request submitted!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all required fields.'),
            backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEDICAL REQUEST'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Request Accommodation',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Submit a medical accommodation request for your exams',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                // ─── New Request Form ──────────────────────────────────────
                Card(
                  elevation: 4,
                  shadowColor: Colors.black26,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:
                                const Color(0xFFECDCAB).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const FaIcon(
                                  FontAwesomeIcons.notesMedical,
                                  size: 22,
                                  color: Colors.black87),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'New Request',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Exam selector
                        const Text('Exam *',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _selectedExam,
                          isExpanded: true, // ✅ FIX: prevents text overflow in dropdown
                          decoration: InputDecoration(
                            // ✅ FIX: constrain the prefix icon box so FaIcon
                            //         centres properly instead of drifting up
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 44,
                              minHeight: 44,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: FaIcon(FontAwesomeIcons.bookOpen,
                                  size: 16, color: Colors.black54),
                            ),
                            hintText: 'Select exam',
                          ),
                          items: _upcomingExams
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis, // ✅ FIX: long strings don't overflow
                            ),
                          ))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedExam = val),
                          validator: (_) => _selectedExam == null
                              ? 'Please select an exam'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Medical reason
                        const Text('Medical Condition / Reason *',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _reasonController,
                          decoration: InputDecoration(
                            // ✅ FIX: same prefixIconConstraints pattern
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 44,
                              minHeight: 44,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: FaIcon(FontAwesomeIcons.hospitalUser,
                                  size: 16, color: Colors.black54),
                            ),
                            hintText: 'e.g., Fracture, Visual impairment...',
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Please enter reason'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Accommodation type
                        const Text('Accommodation Needed *',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _selectedAccommodation,
                          isExpanded: true, // ✅ FIX: prevents overflow
                          decoration: InputDecoration(
                            // ✅ FIX: constrained + padded prefix icon
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 44,
                              minHeight: 44,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: FaIcon(FontAwesomeIcons.handHoldingHeart,
                                  size: 16, color: Colors.black54),
                            ),
                            hintText: 'Select accommodation',
                          ),
                          items: _accommodations
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis, // ✅ FIX
                            ),
                          ))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedAccommodation = val),
                          validator: (_) => _selectedAccommodation == null
                              ? 'Please select accommodation'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Additional details
                        const Text('Additional Details (optional)',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _detailsController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText:
                            'Any additional information for the admin...',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Attach certificate info
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECDCAB).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color:
                                const Color(0xFFECDCAB).withOpacity(0.5)),
                          ),
                          child: Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.fileMedical,
                                  size: 18, color: Colors.black87),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Please submit a doctor\'s certificate to the exam office within 2 days of request.',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _submitted ? null : _submitRequest,
                            icon: const FaIcon(
                                FontAwesomeIcons.paperPlane,
                                size: 16),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Text('SUBMIT REQUEST'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ─── Past Requests ──────────────────────────────────────────
                if (_pastRequests.isNotEmpty) ...[
                  const Text(
                    'Past Requests',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ..._pastRequests.map((req) => _buildPastRequest(req)),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPastRequest(Map<String, dynamic> req) {
    final isApproved = req['status'] == 'approved';
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isApproved
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FaIcon(
                isApproved
                    ? FontAwesomeIcons.circleCheck
                    : FontAwesomeIcons.clock,
                size: 20,
                color: isApproved ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    req['exam'],
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${req['accommodation']}  •  ${req['date']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isApproved
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isApproved ? Colors.green : Colors.orange,
                  width: 1,
                ),
              ),
              child: Text(
                isApproved ? 'APPROVED' : 'PENDING',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isApproved ? Colors.green : Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}