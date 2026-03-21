import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'service/auth_service.dart';
import 'admin_dashboard_page.dart';
import 'student_dashboard_page.dart';
import 'invigilator_dashboard_page.dart';
import 'student_registration_page.dart';

class LoginPage extends StatefulWidget {
  final String role;

  const LoginPage({Key? key, required this.role}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }



  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final result = await AuthService().login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      setState(() => _isLoading = false);

      if (result['success'] == true) {
        if (result['role'] != widget.role) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access denied for this role')),
          );
          return;
        }

        Widget dashboard;
        switch (result['role']) {
          case 'admin':
            dashboard = const AdminDashboardPage();
            break;
          case 'student':
            dashboard = const StudentDashboardPage();
            break;
          case 'invigilator':
            dashboard = const InvigilatorDashboardPage();
            break;
          default:
            return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => dashboard),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['error'] ?? 'Login failed')),
        );
      }
    }
  }


  // ✅ CHANGED: Return type to IconData to support FontAwesome
  IconData _getRoleIcon() {
    switch (widget.role) {
      case 'admin':
        return FontAwesomeIcons.userShield; // ✅ CHANGED: https://fontawesome.com/icons/user-shield
      case 'student':
        return FontAwesomeIcons.userGraduate; // ✅ CHANGED: https://fontawesome.com/icons/user-graduate
      case 'invigilator':
        return FontAwesomeIcons.clipboardUser; // ✅ CHANGED: https://fontawesome.com/icons/clipboard-user
      default:
        return FontAwesomeIcons.user; // ✅ CHANGED: https://fontawesome.com/icons/user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.role.toUpperCase()} LOGIN'),
        leading: IconButton( // ✅ CHANGED: Custom back button with FontAwesome
          icon: const FaIcon(FontAwesomeIcons.arrowLeft), // https://fontawesome.com/icons/arrow-left
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
                  FaIcon( // ✅ CHANGED: Icon to FaIcon
                    _getRoleIcon(),
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome ${widget.role.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Login to continue',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email / ID',
                              prefixIcon: FaIcon( // ✅ CHANGED: Icon to FaIcon
                                FontAwesomeIcons.envelope, // ✅ CHANGED: https://fontawesome.com/icons/envelope
                                size: 20,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email or ID';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const FaIcon( // ✅ CHANGED: Icon to FaIcon
                                FontAwesomeIcons.lock, // ✅ CHANGED: https://fontawesome.com/icons/lock
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: FaIcon( // ✅ CHANGED: Icon to FaIcon
                                  _obscurePassword
                                      ? FontAwesomeIcons.eye // ✅ CHANGED: https://fontawesome.com/icons/eye
                                      : FontAwesomeIcons.eyeSlash, // ✅ CHANGED: https://fontawesome.com/icons/eye-slash
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Handle forgot password
                              },
                              child: const Text('Forgot Password?'),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Text('LOGIN'),
                              ),
                            ),
                          ),
                          if (_isLoading) ...[
                            const SizedBox(height: 16),
                            const CircularProgressIndicator(),
                            const SizedBox(height: 8),
                            const Text(
                              'Logging in...',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // ✅ NEW: Register button for students
                  if (widget.role == 'student') ...[
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StudentRegistrationPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Register here',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFECDCAB),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}