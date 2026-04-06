import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const String baseUrl =
      'http://110.225.251.16:4445'; // Change to your server IP if needed

  final _formKey = GlobalKey<FormState>();

  // Basic field controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  /// Call Frappe API to register farmer with basic info only
  Future<String?> _registerBasicAccount() async {
    final url = Uri.parse(
      '$baseUrl/api/method/krishiastra_app.api.register.register_farmer_basic',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'full_name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'phone_no': _phoneController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final msg = data['message'];

        if (msg is Map && msg['status'] == 'ok') {
          return null; // success
        } else if (msg is String) {
          return msg;
        } else if (msg is Map && msg['message'] != null) {
          return msg['message'].toString();
        } else {
          return "Unknown server response";
        }
      } else {
        // Try to decode Frappe error body
        try {
          final data = jsonDecode(response.body);
          if (data is Map && data['_server_messages'] != null) {
            final serverMessagesJson = data['_server_messages'];
            final List decodedList = jsonDecode(serverMessagesJson);
            if (decodedList.isNotEmpty) {
              final firstMsg = jsonDecode(decodedList[0]);
              if (firstMsg['message'] != null) {
                return firstMsg['message'].toString();
              }
            }
          }
        } catch (_) {}
        return "Server error: ${response.statusCode}";
      }
    } catch (e) {
      return "Network error: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0F4C2A),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0F4C2A), Color(0xFF1C6B3C)],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                // Logo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset("assets/images/logo.png", height: 70),
                ),
                const SizedBox(height: 20),

                // Main card container
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 32,
                            horizontal: 24,
                          ),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF1C6B3C), Color(0xFF2A8F52)],
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                l10n.createAccount,
                                style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.joinCommunity,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        l10n.alreadyHaveAccount,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Form content
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.createYourAccountSubtitle,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),

                              buildField(
                                l10n.fullName,
                                _nameController,
                                Icons.badge_outlined,
                                l10n,
                              ),
                              buildField(
                                l10n.phoneNum,
                                _phoneController,
                                Icons.phone_outlined,
                                l10n,
                                keyboardType: TextInputType.phone,
                              ),
                              buildField(
                                l10n.email,
                                _emailController,
                                Icons.email_outlined,
                                l10n,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              buildPasswordField(
                                l10n.password,
                                _passwordController,
                                false,
                                l10n,
                              ),
                              buildPasswordField(
                                l10n.confirmPassword,
                                _confirmPasswordController,
                                true,
                                l10n,
                              ),

                              const SizedBox(height: 24),
                              // Register button
                              Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF1C6B3C),
                                      Color(0xFF2A8F52),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF1C6B3C,
                                      ).withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate())
                                      return;

                                    // Check password match
                                    if (_passwordController.text.trim() !=
                                        _confirmPasswordController.text
                                            .trim()) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            l10n.passwordsDoNotMatch,
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    // Show loading message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.creatingAccount),
                                        backgroundColor: Color(0xFF1C6B3C),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );

                                    // Call the registration API
                                    final error = await _registerBasicAccount();

                                    if (!mounted) return;

                                    if (error == null) {
                                      // Show success message
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            l10n.accountCreatedSuccess,
                                          ),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );

                                      // Navigate back to login page after delay
                                      await Future.delayed(
                                        const Duration(seconds: 2),
                                      );
                                      if (!mounted) return;
                                      Navigator.pop(context);
                                    } else {
                                      // Show error
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(error),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    l10n.registerBtn,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(
    String label,
    TextEditingController controller,
    IconData icon,
    AppLocalizations l10n, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF1C6B3C), size: 20),
          filled: true,
          fillColor: Colors.grey[50],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1C6B3C), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator:
            (value) => value!.isEmpty ? "${l10n.pleaseEnter} $label" : null,
      ),
    );
  }

  Widget buildPasswordField(
    String label,
    TextEditingController controller,
    bool isConfirm,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: isConfirm ? _obscureConfirmPassword : _obscurePassword,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Color(0xFF1C6B3C),
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              (isConfirm ? _obscureConfirmPassword : _obscurePassword)
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey[600],
              size: 20,
            ),
            onPressed: () {
              setState(() {
                if (isConfirm) {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                } else {
                  _obscurePassword = !_obscurePassword;
                }
              });
            },
          ),
          filled: true,
          fillColor: Colors.grey[50],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1C6B3C), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator:
            (value) => value!.isEmpty ? "${l10n.pleaseEnter} $label" : null,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
