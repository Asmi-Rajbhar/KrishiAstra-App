// lib/screens/profile_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/profile_service.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  final ProfileService _profileService = ProfileService();
  final AuthService _authService = AuthService();
  
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _userProfile;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _loadUserProfile();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final isAuth = await _authService.isAuthenticated();
      
      if (!isAuth) {
        setState(() {
          _errorMessage = 'Session expired. Please login again.';
          _isLoading = false;
        });
        return;
      }

      final userDetails = await _authService.getCurrentUserDetails();
      
      if (userDetails == null) {
        setState(() {
          _errorMessage = 'Unable to fetch user session. Please login again.';
          _isLoading = false;
        });
        return;
      }

      final profile = await _profileService.getUserProfile();
      
      if (profile != null && profile.isNotEmpty) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
        _animationController.forward();
      } else {
        setState(() {
          _userProfile = userDetails;
          _isLoading = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      print('Exception in _loadUserProfile: $e');
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.logout, color: Color(0xFFFF5252)),
            const SizedBox(width: 12),
            Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5252),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFF0A6F3B)),
        ),
      );

      await _authService.logout();
      
      if (!mounted) return;
      
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Color _getVerificationColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return const Color(0xFF4CAF50);
      case 'pending':
        return const Color(0xFFFF9800);
      case 'rejected':
        return const Color(0xFFFF5252);
      default:
        return Colors.grey;
    }
  }

  IconData _getVerificationIcon(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return Icons.verified;
      case 'pending':
        return Icons.pending;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0A6F3B),
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          _errorMessage!,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.red[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _loadUserProfile,
                        icon: const Icon(Icons.refresh),
                        label: Text(
                          'Retry',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A6F3B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadUserProfile,
                  color: const Color(0xFF0A6F3B),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      _buildAppBar(),
                      SliverToBoxAdapter(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  _buildPersonalInfoSection(),
                                  const SizedBox(height: 10),
                                  _buildContactInfoSection(),
                                  const SizedBox(height: 10),
                                  _buildAddressSection(),
                                  const SizedBox(height: 10),
                                  _buildFarmingDetailsSection(),
                                  const SizedBox(height: 10),
                                  _buildDocumentsSection(),
                                  const SizedBox(height: 10),
                                  _buildBankDetailsSection(),
                                  const SizedBox(height: 16),
                                  _buildLogoutButton(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildAppBar() {
    final verifyStatus = _userProfile?['verify_status']?.toString() ?? 'Unverified';
    final statusColor = _getVerificationColor(verifyStatus);
    
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      backgroundColor: const Color(0xFF0A6F3B),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A6F3B), Color(0xFF0D8C4A), Color(0xFF12A55A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 44,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _userProfile?['full_name']?.toString() ?? 'User',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getVerificationIcon(verifyStatus),
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        verifyStatus,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    final verifyStatus = _userProfile?['verify_status']?.toString() ?? 'Unverified';
    final statusColor = _getVerificationColor(verifyStatus);
    
    return _buildSection(
      title: 'Personal Information',
      icon: Icons.person_outline,
      children: [
        _buildInfoRow(Icons.badge, 'Full Name', _userProfile?['full_name']),
        _buildInfoRow(Icons.school, 'Education', _userProfile?['education']),
        _buildInfoRow(
          Icons.verified_user,
          'Verification Status',
          null,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_getVerificationIcon(verifyStatus), size: 14, color: statusColor),
                const SizedBox(width: 5),
                Text(
                  verifyStatus,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return _buildSection(
      title: 'Contact Information',
      icon: Icons.contact_phone_outlined,
      children: [
        _buildInfoRow(Icons.phone, 'Phone Number', _userProfile?['phone_no']),
        _buildInfoRow(Icons.email, 'Email', _userProfile?['email'] ?? _userProfile?['user']),
      ],
    );
  }

  Widget _buildAddressSection() {
    return _buildSection(
      title: 'Address Details',
      icon: Icons.location_on_outlined,
      children: [
        _buildInfoRow(Icons.home, 'Address', _userProfile?['address']),
        _buildInfoRow(Icons.location_city, 'Village', _userProfile?['village']),
        _buildInfoRow(Icons.landscape, 'Tehsil', _userProfile?['tehsil']),
        _buildInfoRow(Icons.map, 'District', _userProfile?['district']),
        _buildInfoRow(Icons.flag, 'State', _userProfile?['state']),
        _buildInfoRow(Icons.public, 'Country', _userProfile?['country']),
        _buildInfoRow(Icons.pin_drop, 'Pincode', _userProfile?['pincode']),
        _buildInfoRow(Icons.numbers, 'DigiPin', _userProfile?['digipin']),
      ],
    );
  }

  Widget _buildFarmingDetailsSection() {
    return _buildSection(
      title: 'Farming Details',
      icon: Icons.agriculture_outlined,
      children: [
        _buildInfoRow(
          Icons.landscape,
          'Total Land Cultivated',
          _userProfile?['total_land_cultivated'] != null
              ? '${_userProfile!['total_land_cultivated']} acres'
              : null,
        ),
        _buildInfoRow(
          Icons.currency_rupee,
          'Annual Income',
          _userProfile?['annual_income'],
        ),
        _buildInfoRow(
          Icons.qr_code_scanner,
          'Agri Stack ID',
          _userProfile?['agristack_id'],
        ),
      ],
    );
  }

  Widget _buildDocumentsSection() {
    final aadhaarNo = _userProfile?['aadhaar_no']?.toString() ?? '';
    final pancardNo = _userProfile?['pancard_no']?.toString() ?? '';
    final kycDocs = _userProfile?['kyc_documents']?.toString() ?? '';
    
    final hasAadhaar = aadhaarNo.isNotEmpty && aadhaarNo != 'null';
    final hasPancard = pancardNo.isNotEmpty && pancardNo != 'null';
    final hasKYC = kycDocs.isNotEmpty && kycDocs != 'null';

    return _buildSection(
      title: 'Documents',
      icon: Icons.description_outlined,
      children: [
        _buildInfoRow(
          Icons.credit_card,
          'Aadhaar Number',
          hasAadhaar ? _maskAadhaar(aadhaarNo) : null,
          trailing: hasAadhaar
              ? const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 18)
              : const Icon(Icons.cancel, color: Color(0xFFFF5252), size: 18),
        ),
        _buildInfoRow(
          Icons.credit_card,
          'PAN Card Number',
          hasPancard ? _maskPAN(pancardNo) : null,
          trailing: hasPancard
              ? const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 18)
              : const Icon(Icons.cancel, color: Color(0xFFFF5252), size: 18),
        ),
        _buildInfoRow(
          Icons.folder,
          'KYC Documents',
          hasKYC ? 'Uploaded' : null,
          trailing: hasKYC
              ? const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 18)
              : const Icon(Icons.cancel, color: Color(0xFFFF5252), size: 18),
        ),
      ],
    );
  }

  String _maskAadhaar(String aadhaar) {
    if (aadhaar.length < 4) return aadhaar;
    final cleaned = aadhaar.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length < 4) return aadhaar;
    return 'XXXX-XXXX-${cleaned.substring(cleaned.length - 4)}';
  }

  String _maskPAN(String pan) {
    if (pan.length < 4) return pan;
    return 'XXXXXX${pan.substring(pan.length - 4)}';
  }

  Widget _buildBankDetailsSection() {
    final bankDetails = _userProfile?['bank_details'];
    final hasBankDetails = bankDetails != null && 
                           bankDetails is List && 
                           bankDetails.isNotEmpty;
    
    return _buildSection(
      title: 'Bank Details',
      icon: Icons.account_balance_outlined,
      children: [
        _buildInfoRow(
          hasBankDetails ? Icons.check_circle : Icons.cancel,
          'Bank Account',
          hasBankDetails ? 'Linked' : null,
          trailing: hasBankDetails
              ? const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 18)
              : const Icon(Icons.cancel, color: Color(0xFFFF5252), size: 18),
        ),
        if (hasBankDetails && bankDetails is List && bankDetails.isNotEmpty)
          ...bankDetails.map((bank) => Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0A6F3B).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF0A6F3B).withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBankInfoRow('Bank Name', bank['bank_name']),
                  const SizedBox(height: 5),
                  _buildBankInfoRow('Account Number', bank['account_number']),
                  const SizedBox(height: 5),
                  _buildBankInfoRow('IFSC Code', bank['ifsc_code']),
                  const SizedBox(height: 5),
                  _buildBankInfoRow('Branch', bank['branch']),
                ],
              ),
            ),
          )).toList(),
      ],
    );
  }

  Widget _buildBankInfoRow(String label, dynamic value) {
    final displayValue = value?.toString() ?? 'Not Available';
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Text(': ', style: TextStyle(color: Colors.grey, fontSize: 11)),
        Expanded(
          child: Text(
            displayValue,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A6F3B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(icon, color: const Color(0xFF0A6F3B), size: 16),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, dynamic value, {Widget? trailing}) {
    final displayValue = value?.toString() ?? 'Not Available';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: Colors.grey[600]),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                if (value != null)
                  Text(
                    displayValue,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _handleLogout,
          icon: const Icon(Icons.logout, size: 17),
          label: Text(
            'Logout',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5252),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}