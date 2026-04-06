// lib/home_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'services/auth_service.dart';
import 'plot.dart';
import 'plot_details_page.dart';
import 'disease.dart';
import 'package:krishiastra/expense_tracker_screen.dart';
import 'l10n/app_localizations.dart';
import 'screens/language_selection_screen.dart';
import 'verify_page.dart';
import 'screens/profile_page.dart';
import 'agri_university.dart';
import 'all_plots_page.dart';
import 'models/plot_model.dart';
import 'plot_analytics_page.dart';
import 'expense_plot_list_page.dart';
import 'screens/agri_forecast_screen.dart';
import 'agribot_chat_page.dart';

class HomePage extends StatefulWidget {
  final String? userName;

  const HomePage({super.key, this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _checkVerificationAndNavigate() async {
    final auth = AuthService();
<<<<<<< HEAD
    final l10n = AppLocalizations.of(context)!;
=======
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09

    showDialog(
      context: context,
      barrierDismissible: false,
<<<<<<< HEAD
      builder:
          (context) => const Center(
            child: CircularProgressIndicator(color: Color(0xFF0A6F3B)),
          ),
=======
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF0A6F3B)),
      ),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
    );

    try {
      final userDetails = await auth.getCurrentUserDetails();

      if (!mounted) return;
      Navigator.pop(context);

      if (userDetails == null) {
        ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
          SnackBar(
            content: Text(l10n.fetchUserError),
=======
          const SnackBar(
            content: Text('Failed to fetch user details'),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final verifyStatus =
          userDetails['verify_status']?.toString() ?? 'Unverified';

      if (verifyStatus == 'Verified') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MapScreen()),
        );
      } else {
        _showVerificationDialog(userDetails);
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
<<<<<<< HEAD
          content: Text('${l10n.errorPrefix}$e'),
=======
          content: Text('Error: $e'),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showVerificationDialog(Map<String, dynamic> userDetails) {
<<<<<<< HEAD
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Colors.white, Color(0xFFF1F8F4)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_user_outlined,
                      size: 48,
                      color: Color(0xFFFF9800),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.verificationRequired,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.verifyPlotMessage,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(
                              color: Colors.grey[300]!,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            l10n.cancel,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => VerifyPage(
                                      fullName: userDetails['full_name'] ?? '',
                                      phoneNo: userDetails['phone_no'] ?? '',
                                      email: userDetails['email'] ?? '',
                                      password: '',
                                    ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color(0xFF0A6F3B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            l10n.verify,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
=======
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFF1F8F4)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
                  size: 48,
                  color: Color(0xFFFF9800),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Verification Required',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'You need to verify yourself before creating a plot',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyPage(
                              fullName: userDetails['full_name'] ?? '',
                              phoneNo: userDetails['phone_no'] ?? '',
                              email: userDetails['email'] ?? '',
                              password: '',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF0A6F3B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Verify',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DiseaseHomePage()),
      );
      return;
    }
    if (index == 2) {
      _checkVerificationAndNavigate();
      return;
    }

    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AgriUniversityApp()),
      );
      return;
    }

    int pageIndex;
    if (index == 0) {
      pageIndex = 0;
    } else if (index == 3) {
      pageIndex = 1;
    } else {
      pageIndex = _selectedIndex;
    }

    setState(() {
      _selectedIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final pages = <Widget>[
      DashboardContent(userName: widget.userName),
      const FertilizerPage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
<<<<<<< HEAD
              l10n.welcome,
=======
              'Welcome, ',
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              widget.userName ?? 'Ramesh',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text('!', style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
<<<<<<< HEAD
            icon: const Icon(
              Icons.person_outline,
              color: Colors.black87,
              size: 24,
            ),
=======
            icon: const Icon(Icons.person_outline,
                color: Colors.black87, size: 24),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          IconButton(
<<<<<<< HEAD
            icon: const Icon(Icons.language, color: Colors.black87, size: 24),
=======
            icon: const Icon(Icons.language,
                color: Colors.black87, size: 24),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
<<<<<<< HEAD
                  builder: (context) => const LanguageSelectionScreen(),
                ),
=======
                    builder: (context) => const LanguageSelectionScreen()),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Icons.dashboard_rounded, l10n.dashboard),
                _buildNavItem(1, Icons.local_florist_rounded, l10n.disease),
                _buildAddButton(),
                _buildNavItem(3, Icons.science_rounded, l10n.fertilizer),
<<<<<<< HEAD
                _buildNavItem(4, Icons.school_rounded, l10n.university),
=======
                _buildNavItem(4, Icons.school_rounded, 'University'),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = false;
    if (index == 0 && _selectedIndex == 0) isSelected = true;
    if (index == 3 && _selectedIndex == 1) isSelected = true;
    if (index == 4 && _selectedIndex == 2) isSelected = true;

    return Flexible(
      flex: 1,
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
<<<<<<< HEAD
            color:
                isSelected
                    ? const Color(0xFF0A6F3B).withOpacity(0.1)
                    : Colors.transparent,
=======
            color: isSelected
                ? const Color(0xFF0A6F3B).withOpacity(0.1)
                : Colors.transparent,
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
<<<<<<< HEAD
              Icon(
                icon,
                color: isSelected ? const Color(0xFF0A6F3B) : Colors.grey[400],
                size: 24,
              ),
=======
              Icon(icon,
                  color:
                      isSelected ? const Color(0xFF0A6F3B) : Colors.grey[400],
                  size: 24),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
<<<<<<< HEAD
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color:
                        isSelected ? const Color(0xFF0A6F3B) : Colors.grey[400],
=======
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF0A6F3B)
                        : Colors.grey[400],
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () => _onItemTapped(2),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0A6F3B), Color(0xFF0D8C4A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0A6F3B).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DASHBOARD CONTENT
// ═══════════════════════════════════════════════════════════════
class DashboardContent extends StatefulWidget {
  final String? userName;

  const DashboardContent({super.key, this.userName});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent>
    with TickerProviderStateMixin {
  String? fullName;
  Map<String, dynamic>? currentUserDetails;

  bool _isLoading = true;
<<<<<<< HEAD
  String? _errorMessageKey;
=======
  String? _errorMessage;
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
  Map<String, dynamic>? _weatherData;

  List<Plot> myPlots = [];
  bool plotsLoading = true;
  String? plotError;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();

    if (widget.userName != null && widget.userName!.isNotEmpty) {
      fullName = widget.userName;
    }

    _loadUser();
    _fetchWeatherData();
    loadPlots();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final auth = AuthService();
    final cachedName = await auth.getStoredFullName();
    if (cachedName != null && cachedName.isNotEmpty) {
      if (mounted) setState(() => fullName = cachedName);
    }

    final userData = await auth.getCurrentUserDetails();
    if (userData != null && mounted) {
      final fetchedName = userData['full_name']?.toString() ?? '';
      final phoneNo = userData['phone_no']?.toString() ?? '';

      if (fetchedName.isNotEmpty) {
        setState(() {
          fullName = fetchedName;
          currentUserDetails = userData;
        });
        await auth.updateStoredFullName(fetchedName);
      } else if (phoneNo.isNotEmpty) {
        setState(() {
          fullName = phoneNo;
          currentUserDetails = userData;
        });
      }
    }
  }

  Future<void> loadPlots() async {
    setState(() {
      plotsLoading = true;
      plotError = null;
    });

    try {
      final auth = AuthService();
      final list = await auth.fetchPlots();
      final loaded = list.map<Plot>((p) => Plot.fromJson(p)).toList();
      if (!mounted) return;
      setState(() {
        myPlots = loaded;
        plotsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        plotError = e.toString();
        plotsLoading = false;
      });
    }
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
<<<<<<< HEAD
      _errorMessageKey = null;
=======
      _errorMessage = null;
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
    });

    const apiKey = 'a32ad422c06b469fa290bd839f1a6665';
    const latitude = '19.0760';
    const longitude = '72.8777';
    const url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (mounted) {
        if (response.statusCode == 200) {
          setState(() {
            _weatherData = json.decode(response.body);
            _isLoading = false;
          });
        } else {
          setState(() {
<<<<<<< HEAD
            _errorMessageKey = 'weatherLoadError';
=======
            _errorMessage = 'Failed to load weather data.';
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
<<<<<<< HEAD
          _errorMessageKey = 'connectionError';
=======
          _errorMessage = 'An error occurred. Please check your connection.';
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshAll() async {
    await Future.wait([_fetchWeatherData(), loadPlots(), _loadUser()]);
  }

  // ─── Weather helpers ────────────────────────────────────────
<<<<<<< HEAD
  String _getTemperature(AppLocalizations l10n) =>
      _weatherData?['main']?['temp']?.toStringAsFixed(0) ?? l10n.notAvailable;
  String _getHumidity(AppLocalizations l10n) =>
      _weatherData?['main']?['humidity']?.toString() ?? l10n.notAvailable;
  String _getWindSpeed(AppLocalizations l10n) {
    final speed = _weatherData?['wind']?['speed'];
    return speed != null ? (speed * 3.6).toStringAsFixed(1) : l10n.notAvailable;
  }

  String _getWeatherDescription(AppLocalizations l10n) {
    String desc =
        _weatherData?['weather']?[0]?['description'] ?? l10n.notAvailable;
    return desc != l10n.notAvailable && desc.isNotEmpty
        ? desc[0].toUpperCase() + desc.substring(1)
        : desc;
  }

  IconData _getWeatherIcon() {
    final main = _weatherData?['weather']?[0]?['main']?.toLowerCase() ?? '';
=======
  String _getTemperature() =>
      _weatherData?['main']?['temp']?.toStringAsFixed(0) ?? 'N/A';
  String _getHumidity() =>
      _weatherData?['main']?['humidity']?.toString() ?? 'N/A';
  String _getWindSpeed() {
    final speed = _weatherData?['wind']?['speed'];
    return speed != null ? (speed * 3.6).toStringAsFixed(1) : 'N/A';
  }

  String _getWeatherDescription() {
    String desc =
        _weatherData?['weather']?[0]?['description'] ?? 'N/A';
    return desc.isNotEmpty ? desc[0].toUpperCase() + desc.substring(1) : 'N/A';
  }

  IconData _getWeatherIcon() {
    final main =
        _weatherData?['weather']?[0]?['main']?.toLowerCase() ?? '';
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
    switch (main) {
      case 'clouds':
        return Icons.cloud_outlined;
      case 'rain':
        return Icons.grain_rounded;
      case 'drizzle':
        return Icons.water_drop_outlined;
      case 'thunderstorm':
        return Icons.thunderstorm_outlined;
      case 'snow':
        return Icons.ac_unit_rounded;
      case 'clear':
        return Icons.wb_sunny_outlined;
      default:
        return Icons.wb_cloudy_outlined;
    }
  }

<<<<<<< HEAD
  // Dynamic Crop Name Translator Helper ✨
  String _getLocalizedCropName(String? cropString, AppLocalizations l10n) {
    if (cropString == null || cropString.isEmpty) return l10n.cropFallback;
    switch (cropString.toLowerCase()) {
      case 'wheat':
        return l10n.cropWheat;
      case 'rice':
        return l10n.cropRice;
      case 'corn':
        return l10n.cropCorn;
      case 'tomato':
        return l10n.cropTomato;
      case 'potato':
        return l10n.cropPotato;
      case 'brinjal':
        return l10n.cropBrinjal;
      case 'capsicum':
        return l10n.cropCapsicum;
      case 'sorghum':
        return l10n.cropSorghum;
      case 'millet':
        return l10n.cropMillet;
      case 'sugarcane':
        return l10n.cropSugarcane;
      case 'cotton':
        return l10n.cropCotton;
      default:
        return cropString;
    }
  }

=======
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
  // ═══════════════════════════════════════════════════════════════
  // PLOT PICKER BOTTOM SHEET — used by Expense Tracker card
  // ═══════════════════════════════════════════════════════════════
  void _showExpenseTrackerPlotPicker() {
<<<<<<< HEAD
    final l10n = AppLocalizations.of(context)!;
    if (myPlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.noPlotsFound),
=======
    if (myPlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No plots found. Please add a plot first.'),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
<<<<<<< HEAD
      MaterialPageRoute(builder: (_) => ExpensePlotListPage(plots: myPlots)),
=======
      MaterialPageRoute(
        builder: (_) => ExpensePlotListPage(plots: myPlots),
      ),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: const Color(0xFFF5F5F5),
      child: RefreshIndicator(
        onRefresh: _refreshAll,
        color: const Color(0xFF0A6F3B),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildWeatherCard(context, l10n),
                const SizedBox(height: 24),
                _buildMyCropsSection(context, l10n),
                const SizedBox(height: 24),
                _buildSmartFarmingSection(context, l10n),
                const SizedBox(height: 24),
                _buildMarketPolicySection(context, l10n),
                const SizedBox(height: 24),
                _buildRecommendedVideosSection(context, l10n),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Weather Card ────────────────────────────────────────────
  Widget _buildWeatherCard(BuildContext context, AppLocalizations l10n) {
<<<<<<< HEAD
    String displayedErrorMessage = l10n.weatherUnavailable;
    if (_errorMessageKey == 'weatherLoadError')
      displayedErrorMessage = l10n.weatherLoadError;
    if (_errorMessageKey == 'connectionError')
      displayedErrorMessage = l10n.connectionError;

=======
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A6F3B), Color(0xFF0D8C4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A6F3B).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
<<<<<<< HEAD
      child:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
              : _errorMessageKey != null
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, color: Colors.white, size: 28),
                    const SizedBox(height: 6),
                    Text(
                      displayedErrorMessage,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.whatsTheWeather,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_getTemperature(l10n)}°",
                                style: GoogleFonts.inter(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                              Text(
                                'C',
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _getWeatherDescription(l10n),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Icon(_getWeatherIcon(), color: Colors.white, size: 80),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _weatherMiniStat(
                        Icons.water_drop_outlined,
                        '${_getHumidity(l10n)}%',
                        l10n.humidityLabel,
                      ),
                      _weatherMiniStat(
                        Icons.air,
                        '${_getWindSpeed(l10n)} km/h',
                        l10n.windLabel,
                      ),
                    ],
                  ),
                ],
              ),
=======
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2.5))
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off,
                          color: Colors.white, size: 28),
                      const SizedBox(height: 6),
                      Text(
                        l10n.weatherUnavailable,
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "What's the weather?",
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${_getTemperature()}°",
                                  style: GoogleFonts.inter(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      height: 1),
                                ),
                                Text('C',
                                    style: GoogleFonts.inter(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white)),
                              ],
                            ),
                            Text(
                              _getWeatherDescription(),
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Icon(_getWeatherIcon(),
                            color: Colors.white, size: 80),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _weatherMiniStat(Icons.water_drop_outlined,
                            '${_getHumidity()}%', 'Humidity'),
                        _weatherMiniStat(Icons.air,
                            '${_getWindSpeed()} km/h', 'Wind'),
                      ],
                    ),
                  ],
                ),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
    );
  }

  Widget _weatherMiniStat(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.white.withOpacity(0.9)),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< HEAD
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
=======
            Text(value,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.8))),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
          ],
        ),
      ],
    );
  }

  // ─── My Crops ────────────────────────────────────────────────
  Widget _buildMyCropsSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
<<<<<<< HEAD
              Text(
                l10n.myCropsTitle,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllPlotsPage(),
                      ),
                    ),
                child: Text(
                  l10n.viewAll,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0A6F3B),
                  ),
                ),
=======
              Text('My Crops',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87)),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllPlotsPage()),
                ),
                child: Text('View All',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0A6F3B))),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
<<<<<<< HEAD
          child:
              plotsLoading
                  ? const Center(child: CircularProgressIndicator())
                  : myPlots.isEmpty
                  ? Center(
                    child: Text(
                      l10n.noCropsAdded,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                  : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: myPlots.length > 3 ? 3 : myPlots.length,
                    itemBuilder:
                        (context, index) =>
                            _buildCropCard(myPlots[index], l10n),
                  ),
=======
          child: plotsLoading
              ? const Center(child: CircularProgressIndicator())
              : myPlots.isEmpty
                  ? Center(
                      child: Text('No crops added yet',
                          style: GoogleFonts.inter(
                              fontSize: 14, color: Colors.grey[600])))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount:
                          myPlots.length > 3 ? 3 : myPlots.length,
                      itemBuilder: (context, index) =>
                          _buildCropCard(myPlots[index]),
                    ),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
        ),
      ],
    );
  }

<<<<<<< HEAD
  Widget _buildCropCard(Plot plot, AppLocalizations l10n) {
=======
  Widget _buildCropCard(Plot plot) {
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
    final cropImages = {
      'Wheat': '🌾',
      'Rice': '🌾',
      'Corn': '🌽',
      'Tomato': '🍅',
      'Potato': '🥔',
      'Cotton': '🌸',
    };
<<<<<<< HEAD

    // Getting the raw english name for image lookup, but displayed name is translated
    String rawCropName = plot.crop ?? 'Crop';
    String displayedCropName = _getLocalizedCropName(plot.crop, l10n);

    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlotDetailsPage(plot: plot),
            ),
          ),
=======
    String cropName = plot.crop ?? 'Crop';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlotDetailsPage(plot: plot)),
      ),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
<<<<<<< HEAD
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
=======
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4))
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF0A6F3B).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
<<<<<<< HEAD
                child: Text(
                  cropImages[rawCropName] ?? '🌱',
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              displayedCropName,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${plot.area.toStringAsFixed(2)} ${l10n.acres}',
              style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[600]),
            ),
=======
                  child: Text(cropImages[cropName] ?? '🌱',
                      style: const TextStyle(fontSize: 28))),
            ),
            const SizedBox(height: 8),
            Text(cropName,
                style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text('${plot.area.toStringAsFixed(2)} Acre',
                style: GoogleFonts.inter(
                    fontSize: 10, color: Colors.grey[600])),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
          ],
        ),
      ),
    );
  }

  // ─── Smart Farming ───────────────────────────────────────────
  Widget _buildSmartFarmingSection(
<<<<<<< HEAD
    BuildContext context,
    AppLocalizations l10n,
  ) {
=======
      BuildContext context, AppLocalizations l10n) {
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
<<<<<<< HEAD
          child: Text(
            l10n.smartFarmingTitle,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
=======
          child: Text('Smart Farming',
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87)),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildSmartFarmingCard(
                  icon: Icons.add_chart,
<<<<<<< HEAD
                  title: l10n.myPlots,
                  color: const Color(0xFF0A6F3B),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllPlotsPage(),
                        ),
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildExpenseTrackerCard(l10n)),
=======
                  title: 'My Plots',
                  color: const Color(0xFF0A6F3B),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllPlotsPage()),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // ── UPDATED: Expense Tracker card ──────────────────
              Expanded(
                child: _buildExpenseTrackerCard(),
              ),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildSmartFarmingCard(
                  icon: Icons.psychology,
<<<<<<< HEAD
                  title: l10n.cropwellExpert,
                  color: const Color(0xFFFF9800),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AgribotChatPage(),
                      ),
                    );
=======
                  title: 'Cropwell Expert',
                  color: const Color(0xFFFF9800),
                
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AgribotChatPage()),);
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSmartFarmingCard(
                  icon: Icons.bug_report,
<<<<<<< HEAD
                  title: l10n.cropPredictor,
                  color: const Color(0xFF9C27B0),
                  onTap: () => {},
=======
                  title: 'Crop Predictor',
                  color: const Color(0xFF9C27B0),
                  onTap: () => {}
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── NEW: Expense Tracker Card with "Tracker" + "Analytics" labels ──
<<<<<<< HEAD
  Widget _buildExpenseTrackerCard(AppLocalizations l10n) {
=======
  Widget _buildExpenseTrackerCard() {
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
    const Color cardColor = Color(0xFF2196F3);

    return GestureDetector(
      onTap: _showExpenseTrackerPlotPicker,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.attach_money, color: cardColor, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
<<<<<<< HEAD
              l10n.expenseTracker,
=======
              'Expense Tracker',
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // Sub-labels hint
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
<<<<<<< HEAD
                _miniChip(l10n.trackerLabel, const Color(0xFF2196F3)),
                const SizedBox(width: 4),
                _miniChip(l10n.analyticsLabel, const Color(0xFF009688)),
=======
                _miniChip('Tracker', const Color(0xFF2196F3)),
                const SizedBox(width: 4),
                _miniChip('Analytics', const Color(0xFF009688)),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSmartFarmingCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Market & Policy ─────────────────────────────────────────
  Widget _buildMarketPolicySection(
<<<<<<< HEAD
    BuildContext context,
    AppLocalizations l10n,
  ) {
=======
      BuildContext context, AppLocalizations l10n) {
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
<<<<<<< HEAD
          child: Text(
            l10n.marketPolicyTitle,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
=======
          child: Text('Market & Policy',
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87)),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildMarketCard(
                  icon: Icons.agriculture,
<<<<<<< HEAD
                  title: l10n.priceTrendAnalysis,
=======
                  title: 'Price Trend Analysis',
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                  color: const Color(0xFF4CAF50),
                  onTap: () {
                    Navigator.push(
                      context,
<<<<<<< HEAD
                      MaterialPageRoute(
                        builder: (context) => const AgriForecastScreen(),
                      ),
                    );
=======
                      MaterialPageRoute(builder: (context) => const AgriForecastScreen()),);
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMarketCard(
                  icon: Icons.assessment,
<<<<<<< HEAD
                  title: l10n.cropSchemeSuitability,
=======
                  title: 'Crop & Scheme Suitability',
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                  color: const Color(0xFFFF5722),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMarketCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
<<<<<<< HEAD
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
=======
            Text(title,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
          ],
        ),
      ),
    );
  }

  // ─── Recommended Videos ──────────────────────────────────────
  Widget _buildRecommendedVideosSection(
<<<<<<< HEAD
    BuildContext context,
    AppLocalizations l10n,
  ) {
=======
      BuildContext context, AppLocalizations l10n) {
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
<<<<<<< HEAD
              Text(
                l10n.recommendedVideos,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
=======
              Text('Recommended Videos',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87)),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
              Icon(Icons.arrow_forward, size: 20, color: Colors.grey[600]),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildVideoCard(
                thumbnail: '🌱',
<<<<<<< HEAD
                title: l10n.videoTitle1,
=======
                title:
                    'Best practices for sugarcane irrigation in summer',
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                onTap: () {},
              ),
              _buildVideoCard(
                thumbnail: '🌾',
<<<<<<< HEAD
                title: l10n.videoTitle2,
=======
                title: 'Smart farming techniques for higher yield',
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                onTap: () {},
              ),
              _buildVideoCard(
                thumbnail: '🌻',
<<<<<<< HEAD
                title: l10n.videoTitle3,
=======
                title: 'Organic farming methods',
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCard({
    required String thumbnail,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF0A6F3B).withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
<<<<<<< HEAD
                  top: Radius.circular(16),
                ),
=======
                    top: Radius.circular(16)),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
<<<<<<< HEAD
                  Text(thumbnail, style: const TextStyle(fontSize: 48)),
=======
                  Text(thumbnail,
                      style: const TextStyle(fontSize: 48)),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
<<<<<<< HEAD
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Color(0xFF0A6F3B),
                        size: 20,
                      ),
=======
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8)
                        ],
                      ),
                      child: const Icon(Icons.play_arrow,
                          color: Color(0xFF0A6F3B), size: 20),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
<<<<<<< HEAD
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
=======
              child: Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Fertilizer Page (unchanged) ─────────────────────────────
class FertilizerPage extends StatelessWidget {
  const FertilizerPage({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Center(child: Text(AppLocalizations.of(context)!.fertilizerRec));
  }
}
=======
    return Center(
        child: Text(AppLocalizations.of(context)!.fertilizerRec));
  }
}
>>>>>>> 3ee9cc9039fcd5a2f59b6f5d225fb84b4aa2ce09
