import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentRegistrationPage extends StatefulWidget {
  const StudentRegistrationPage({super.key});

  @override
  State<StudentRegistrationPage> createState() => _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _registerNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Dropdown values
  String? _selectedCourse;
  String? _selectedDepartment;
  int? _selectedSemester;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // Course options
  final List<String> _courses = [
    'B.Tech CS',
    'B.Tech EC',
    'B.Tech ME',
    'B.Tech CE',
    'B.Tech EE',
    'B.Tech IT',
    'M.Tech CS',
    'M.Tech IT',
    'M.Tech EE',
  ];

  // Department options
  final List<String> _departments = [
    'CSE',
    'ECE',
    'MECH',
    'CIVIL',
    'EEE',
    'IT'
  ];

  // Semester options
  final List<int> _semesters = [1, 2, 3, 4, 5, 6, 7, 8];

  // ✅ SECURITY: Allowed email domains (GEC Kannur format)
  final List<String> _allowedEmailDomains = [
    '@gecskp.ac.in',           // GEC  official domain
  ];

  // Email should be in format: pkdYYdeptNNN@gecskp.ac.in
  // Example: pkd23cs001@gecskp.ac.in
  final RegExp _emailPattern = RegExp(
    r'^pkd(20|21|22|23|24|25|26)(cs|ec|me|ce|ee)\d{3}@gecskp\.ac\.in$',
    caseSensitive: false,
  );

  // ✅ SECURITY: Register number pattern validation
  // Format: YYBNNN (Admission Year + B for B.Tech + Admission Number)
  // Example: 23B067, 24B001, 22B150
  final RegExp _registerNumberPattern = RegExp(
    r'^(20|21|22|23|24|25|26)B\d{3}$',
    caseSensitive: false,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _registerNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ✅ SECURITY: Validate email domain and format
  bool _isValidCollegeEmail(String email) {
    // Check domain
    final hasDomain = _allowedEmailDomains.any((domain) => email.toLowerCase().endsWith(domain));
    if (!hasDomain) return false;

    // Check format: pkdYYdeptNNN@gecskp.ac.in
    return _emailPattern.hasMatch(email.toLowerCase());
  }

  // ✅ SECURITY: Validate register number format
  bool _isValidRegisterNumber(String regNo) {
    return _registerNumberPattern.hasMatch(regNo.toUpperCase());
  }

  // ✅ SECURITY: Extract year from register number
  int? _getYearFromRegisterNumber(String regNo) {
    final match = _registerNumberPattern.firstMatch(regNo.toUpperCase());
    if (match != null) {
      final yearStr = match.group(1); // Gets "20", "21", "22", "23", etc.
      return int.parse('20$yearStr'); // Converts to 2020, 2021, 2022, etc.
    }
    return null;
  }

  // ✅ SECURITY: Extract department from email
  String? _getDepartmentFromEmail(String email) {
    final match = _emailPattern.firstMatch(email.toLowerCase());
    if (match != null) {
      final deptCode = match.group(2); // Gets "cs", "ec", "me", etc.
      return _getDepartmentFromCode(deptCode?.toUpperCase() ?? '');
    }
    return null;
  }

  // ✅ SECURITY: Map department code to full name
  String? _getDepartmentFromCode(String code) {
    switch (code.toUpperCase()) {
      case 'CS':
        return 'CSE';
      case 'EC':
        return 'ECE';
      case 'ME':
        return 'MECH';
      case 'CE':
        return 'CIVIL';
      case 'EE':
        return 'EEE';
      case 'IT':
        return 'IT';
      default:
        return null;
    }
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ✅ SECURITY CHECK 1: Validate email domain and format
      if (!_isValidCollegeEmail(_emailController.text.trim())) {
        throw Exception(
          'Invalid email format.\n\n'
          'Expected format: pkdYYdeptNNN@gecskp.ac.in\n'
          'Example: pkd23cs001@gecskp.ac.in\n\n'
          'YY = admission year (20-26)\n'
          'dept = cs/ec/me/ce/ee\n'
          'NNN = admission number (001-999)'
        );
      }

      // ✅ SECURITY CHECK 2: Validate register number format
      if (!_isValidRegisterNumber(_registerNumberController.text.trim())) {
        throw Exception(
          'Invalid register number format.\n\n'
          'Expected format: YYBNNN\n'
          'Example: 23B067\n\n'
          'YY = admission year (20-26)\n'
          'B = B.Tech indicator\n'
          'NNN = admission number (001-999)'
        );
      }

      // ✅ SECURITY CHECK 3: Check year validity
      final regYear = _getYearFromRegisterNumber(_registerNumberController.text.trim());
      final currentYear = DateTime.now().year;
      if (regYear != null && (regYear < currentYear - 5 || regYear > currentYear + 1)) {
        throw Exception(
          'Invalid registration year in register number. Must be within 5 years.'
        );
      }

      // ✅ SECURITY CHECK 4: Verify email department matches selected department
      final email = _emailController.text.trim().toLowerCase();
      final emailDept = _getDepartmentFromEmail(email);
      if (emailDept != null && emailDept != _selectedDepartment) {
        throw Exception(
          'Email department does not match selected department.\n'
          'Your email suggests $emailDept but you selected $_selectedDepartment'
        );
      }

      // Step 1: Check if register number already exists
      final existingStudent = await _db
          .collection('students')
          .doc(_registerNumberController.text.trim().toUpperCase())
          .get();

      if (existingStudent.exists) {
        throw Exception('Register number already registered');
      }

      // ✅ SECURITY CHECK 5: Check if email already used
      final emailQuery = await _db
          .collection('students')
          .where('email', isEqualTo: _emailController.text.trim())
          .limit(1)
          .get();

      if (emailQuery.docs.isNotEmpty) {
        throw Exception('Email already registered');
      }

      // Step 2: Create Firebase Auth account
      final credential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final uid = credential.user!.uid;

      // ✅ SEND EMAIL VERIFICATION
      try {
        await credential.user!.sendEmailVerification();
      } catch (e) {
        print('Email verification send failed: $e');
      }

      // ✅ AUTO-APPROVAL with EMAIL VERIFICATION:
      // Students with valid college emails are auto-approved
      // They must verify email before full access
      final isAutoApproved = true;
      final emailVerified = credential.user!.emailVerified;

      // Step 3: Add to users collection (for authentication)
      await _db.collection('users').doc(uid).set({
        'email': _emailController.text.trim(),
        'role': 'student',
        'name': _nameController.text.trim(),
        'registerNumber': _registerNumberController.text.trim().toUpperCase(),
        'createdAt': FieldValue.serverTimestamp(),
        'approved': isAutoApproved,
        'approvalStatus': isAutoApproved ? 'approved' : 'pending',
        'emailVerified': emailVerified,
        'emailVerificationSent': true,
        'autoApproved': isAutoApproved,
        'approvalMethod': isAutoApproved ? 'auto' : 'manual',
      });

      // Step 4: Add to students collection (detailed student data)
      await _db
          .collection('students')
          .doc(_registerNumberController.text.trim().toUpperCase())
          .set({
        'registerNumber': _registerNumberController.text.trim().toUpperCase(),
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'course': _selectedCourse,
        'department': _selectedDepartment,
        'semester': _selectedSemester,
        'exams': [], // Will be assigned by admin later
        'createdAt': FieldValue.serverTimestamp(),
        'uid': uid,
        'approved': isAutoApproved,
        'approvalStatus': isAutoApproved ? 'approved' : 'pending',
        'registrationYear': regYear,
        'emailVerified': emailVerified,
        'autoApproved': isAutoApproved,
      });

      // ✅ ONLY create pending approval if NOT auto-approved
      if (!isAutoApproved) {
        await _db.collection('pendingApprovals').add({
          'type': 'student_registration',
          'studentId': uid,
          'registerNumber': _registerNumberController.text.trim().toUpperCase(),
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'course': _selectedCourse,
          'department': _selectedDepartment,
          'semester': _selectedSemester,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Success!
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isAutoApproved
                  ? '✅ Registration successful!\n\n'
                    '📧 Verification email sent to ${_emailController.text.trim()}\n\n'
                    'Please check your email and click the verification link.\n'
                    'You can login immediately, but some features require verified email.'
                  : '✅ Registration submitted!\n'
                    'Your account is pending admin approval.\n'
                    'You will be notified via email once approved.'
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: isAutoApproved ? 7 : 5),
          ),
        );

        // Sign out and go back to login
        await _auth.signOut();

        if (mounted) {
          Navigator.pop(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Registration failed';
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Email already registered. Try logging in instead.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak. Use at least 6 characters.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address format.';
          break;
        default:
          errorMessage = e.message ?? 'Registration failed';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('STUDENT REGISTRATION'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.userGraduate,
                    size: 64,
                    color: Color(0xFFECDCAB),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Create Student Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Fill in your details to register',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          // Name
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Full Name *',
                              prefixIcon: FaIcon(
                                FontAwesomeIcons.user,
                                size: 20,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              if (value.length < 3) {
                                return 'Name must be at least 3 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Email
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'College Email Address *',
                              prefixIcon: FaIcon(
                                FontAwesomeIcons.envelope,
                                size: 20,
                              ),
                              helperText: 'Format: pkdYYdeptNNN@gecskp.ac.in',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@') || !value.contains('.')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Register Number
                          TextFormField(
                            controller: _registerNumberController,
                            decoration: const InputDecoration(
                              labelText: 'Register Number *',
                              prefixIcon: FaIcon(
                                FontAwesomeIcons.idCard,
                                size: 20,
                              ),
                              helperText: 'Format: YYBNNN (e.g., 23B067)',
                            ),
                            textCapitalization: TextCapitalization.characters,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your register number';
                              }
                              if (value.length < 5) {
                                return 'Invalid register number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Course Dropdown
                          DropdownButtonFormField<String>(
                            initialValue: _selectedCourse,
                            decoration: const InputDecoration(
                              labelText: 'Course *',
                              prefixIcon: FaIcon(
                                FontAwesomeIcons.graduationCap,
                                size: 20,
                              ),
                            ),
                            items: _courses
                                .map((course) => DropdownMenuItem(
                                      value: course,
                                      child: Text(course),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() => _selectedCourse = value);
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select your course';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Department Dropdown
                          DropdownButtonFormField<String>(
                            initialValue: _selectedDepartment,
                            decoration: const InputDecoration(
                              labelText: 'Department *',
                              prefixIcon: FaIcon(
                                FontAwesomeIcons.building,
                                size: 20,
                              ),
                            ),
                            items: _departments
                                .map((dept) => DropdownMenuItem(
                                      value: dept,
                                      child: Text(dept),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() => _selectedDepartment = value);
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select your department';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Semester Dropdown
                          DropdownButtonFormField<int>(
                            initialValue: _selectedSemester,
                            decoration: const InputDecoration(
                              labelText: 'Current Semester *',
                              prefixIcon: FaIcon(
                                FontAwesomeIcons.calendar,
                                size: 20,
                              ),
                            ),
                            items: _semesters
                                .map((sem) => DropdownMenuItem(
                                      value: sem,
                                      child: Text('Semester $sem'),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() => _selectedSemester = value);
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select your semester';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password *',
                              prefixIcon: const FaIcon(
                                FontAwesomeIcons.lock,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: FaIcon(
                                  _obscurePassword
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              helperText: 'At least 6 characters',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Confirm Password
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password *',
                              prefixIcon: const FaIcon(
                                FontAwesomeIcons.lock,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: FaIcon(
                                  _obscureConfirmPassword
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),

                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegistration,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'REGISTER',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          if (_isLoading) ...[
                            const SizedBox(height: 16),
                            const CircularProgressIndicator(),
                            const SizedBox(height: 8),
                            const Text(
                              'Creating your account...',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Login here',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFECDCAB),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



