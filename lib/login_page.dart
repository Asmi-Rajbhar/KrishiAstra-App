// lib/login_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'services/auth_service.dart';
import 'l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _performLogin() async {
    if (!_formKey.currentState!.validate()) return;

<<<<<<< HEAD
    // Fetch l10n here so it can be used safely in the snackbars!
    final l10n = AppLocalizations.of(context)!;

=======
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final phoneNo = _phoneController.text.trim();
      final password = _passwordController.text.trim();

      final error = await _auth.login(phoneNo, password);

      // Hide loading
      if (mounted) Navigator.of(context).pop();

      if (error == null) {
        // Login successful - fetch user data dynamically using sid
        final userData = await _auth.getCurrentUserDetails();
<<<<<<< HEAD

        // Get cached full name for immediate display
        final cachedFullName = await _auth.getStoredFullName();

=======
        
        // Get cached full name for immediate display
        final cachedFullName = await _auth.getStoredFullName();
        
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
        final fullName = userData?['full_name'] ?? cachedFullName ?? '';
        final phoneNumber = userData?['phone_no'] ?? phoneNo;

        if (!mounted) return;
<<<<<<< HEAD

        // Show welcome message translated!
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${l10n.welcomeUser} ${fullName.isNotEmpty ? fullName : phoneNumber}',
            ),
=======
        
        // Show welcome message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome ${fullName.isNotEmpty ? fullName : phoneNumber}'),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to HomePage - it will fetch data dynamically
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
<<<<<<< HEAD
            builder:
                (context) => HomePage(
                  userName: fullName.isNotEmpty ? fullName : phoneNumber,
                ),
=======
            builder: (context) => HomePage(
              userName: fullName.isNotEmpty ? fullName : phoneNumber,
            ),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
          ),
        );
      } else {
        // Login failed - show error
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      // Hide loading if still visible
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
<<<<<<< HEAD
            content: Text('${l10n.unexpectedError} $e'),
=======
            content: Text('An unexpected error occurred: $e'),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1C6B3C),
              const Color(0xFF2D8F54),
              const Color(0xFF1C6B3C),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Logo with shadow
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset("assets/images/logo.png", height: 70),
                    ),
                    const SizedBox(height: 30),

                    // Login Card
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Title
                              ShaderMask(
<<<<<<< HEAD
                                shaderCallback:
                                    (bounds) => LinearGradient(
                                      colors: [
                                        const Color(0xFF1C6B3C),
                                        const Color(0xFF2D8F54),
                                      ],
                                    ).createShader(bounds),
=======
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    const Color(0xFF1C6B3C),
                                    const Color(0xFF2D8F54),
                                  ],
                                ).createShader(bounds),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                                child: Text(
                                  l10n.welcomeBack,
                                  style: GoogleFonts.poppins(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Subtitle
                              Text(
                                l10n.loginSubtitle,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Phone Number field
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  style: GoogleFonts.poppins(fontSize: 15),
                                  decoration: InputDecoration(
<<<<<<< HEAD
                                    hintText:
                                        l10n.phoneHint, // Updated to l10n!
=======
                                    hintText: "Enter phone number",
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                                    hintStyle: GoogleFonts.poppins(
                                      color: Colors.grey[400],
                                    ),
                                    prefixIcon: Container(
                                      margin: const EdgeInsets.all(12),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
<<<<<<< HEAD
                                        color: const Color(
                                          0xFF1C6B3C,
                                        ).withOpacity(0.1),
=======
                                        color: const Color(0xFF1C6B3C).withOpacity(0.1),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.phone_outlined,
                                        color: Color(0xFF1C6B3C),
                                        size: 20,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.1),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF1C6B3C),
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                  ),
<<<<<<< HEAD
                                  validator:
                                      (value) =>
                                          value!.isEmpty
                                              ? l10n.phoneError
                                              : null, // Updated to l10n!
=======
                                  validator: (value) => value!.isEmpty ? "Please enter phone number" : null,
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Password field
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  style: GoogleFonts.poppins(fontSize: 15),
                                  decoration: InputDecoration(
                                    hintText: l10n.passwordHint,
                                    hintStyle: GoogleFonts.poppins(
                                      color: Colors.grey[400],
                                    ),
                                    prefixIcon: Container(
                                      margin: const EdgeInsets.all(12),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
<<<<<<< HEAD
                                        color: const Color(
                                          0xFF1C6B3C,
                                        ).withOpacity(0.1),
=======
                                        color: const Color(0xFF1C6B3C).withOpacity(0.1),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.lock_outline,
                                        color: Color(0xFF1C6B3C),
                                        size: 20,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.grey[600],
                                        size: 22,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.1),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF1C6B3C),
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                  ),
<<<<<<< HEAD
                                  validator:
                                      (value) =>
                                          value!.isEmpty
                                              ? l10n.passwordError
                                              : null,
=======
                                  validator: (value) => value!.isEmpty ? l10n.passwordError : null,
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Forgot password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          l10n.passwordResetSent,
                                          style: GoogleFonts.poppins(),
                                        ),
<<<<<<< HEAD
                                        backgroundColor: const Color(
                                          0xFF1C6B3C,
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
=======
                                        backgroundColor: const Color(0xFF1C6B3C),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    l10n.forgotPassword,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: const Color(0xFF1C6B3C),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Login Button
                              Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
<<<<<<< HEAD
                                    colors: [
                                      Color(0xFF1C6B3C),
                                      Color(0xFF2D8F54),
                                    ],
=======
                                    colors: [Color(0xFF1C6B3C), Color(0xFF2D8F54)],
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
<<<<<<< HEAD
                                      color: const Color(
                                        0xFF1C6B3C,
                                      ).withOpacity(0.3),
=======
                                      color: const Color(0xFF1C6B3C).withOpacity(0.3),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: _performLogin,
                                  child: Text(
                                    l10n.loginBtn,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Divider
                              Row(
                                children: [
                                  Expanded(
<<<<<<< HEAD
                                    child: Divider(
                                      color: Colors.grey[300],
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
=======
                                    child: Divider(color: Colors.grey[300], thickness: 1),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                                    child: Text(
                                      l10n.orDivider,
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
<<<<<<< HEAD
                                    child: Divider(
                                      color: Colors.grey[300],
                                      thickness: 1,
                                    ),
=======
                                    child: Divider(color: Colors.grey[300], thickness: 1),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Sign up link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    l10n.newToApp,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RegisterPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      l10n.signUpFree,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: const Color(0xFF1C6B3C),
                                        fontWeight: FontWeight.w700,
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
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
