import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'admin_dashboard_page.dart';
import 'student_dashboard_page.dart';
import 'invigilator_dashboard_page.dart';
import 'student_register_page.dart';
import 'admin_register_page.dart';
import 'invigilator_register_page.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      Widget dashboard;
      switch (widget.role) {
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
    }
  }

  void _handleSignUp() {
    Widget registerPage;
    switch (widget.role) {
      case 'admin':
        registerPage = const AdminRegisterPage();
        break;
      case 'student':
        registerPage = const StudentRegisterPage();
        break;
      case 'invigilator':
        registerPage = const InvigilatorRegisterPage();
        break;
      default:
        return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => registerPage),
    );
  }

  IconData _getRoleIcon() {
    switch (widget.role) {
      case 'admin':
        return FontAwesomeIcons.userShield;
      case 'student':
        return FontAwesomeIcons.userGraduate;
      case 'invigilator':
        return FontAwesomeIcons.clipboardUser;
      default:
        return FontAwesomeIcons.user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.role.toUpperCase()} LOGIN'),
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
                  FaIcon(
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
                          // ── Email field ──
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email / ID',
                              prefixIcon: FaIcon(
                                FontAwesomeIcons.envelope,
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
                          // ── Password field ──
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
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
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          // ── Forgot Password ──
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text('Forgot Password?'),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // ── LOGIN button ──
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _handleLogin,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Text('LOGIN'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // ── Sign Up row ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                onPressed: _handleSignUp,
                                child: const Text('Sign Up'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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