// lib/plot_details_form_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'services/auth_service.dart';
import 'l10n/app_localizations.dart';

class PlotDetailsFormPage extends StatefulWidget {
  final double areaInAcres;
  final double centerLatitude;
  final double centerLongitude;

  const PlotDetailsFormPage({
    super.key,
    required this.areaInAcres,
    required this.centerLatitude,
    required this.centerLongitude,
  });

  @override
  _PlotDetailsFormPageState createState() => _PlotDetailsFormPageState();
}

class _PlotDetailsFormPageState extends State<PlotDetailsFormPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _farmNameController = TextEditingController();
  final _cropNameController = TextEditingController();
  final _varietyController = TextEditingController();
  final _sowingDateController = TextEditingController();
  final _customSoilTypeController = TextEditingController();

  DateTime? _selectedSowingDate; // Safely stores exact backend date

  String? _selectedIrrigation; // Stores English key for backend
  String? _selectedFarmingType; // Stores English key for backend
  String? _selectedSoilType; // Stores English key for backend
  bool _isSoilTypeCustom = false;

  // The EXACT English values that get sent to your server
  final List<String> _irrigationKeys = ['Drip', 'Sprinkler', 'Flood', 'Canal'];
  final List<String> _farmingKeys = [
    'Organic',
    'Conventional',
    'Hydroponic',
    'No-Till',
  ];
  final List<String> _soilKeys = [
    'Alluvial Soil',
    'Black Soil (Regur Soil)',
    'Red Soil',
    'Laterite Soil',
    'Arid (Desert) Soil',
    'Mountain (Forest) Soil',
    'Saline and Alkaline Soil',
    'Other (type it)',
  ];

  late AnimationController _headerAnimController;
  late Animation<double> _headerAnimation;

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOutCubic,
    );
    _headerAnimController.forward();
  }

  @override
  void dispose() {
    _headerAnimController.dispose();
    _farmNameController.dispose();
    _cropNameController.dispose();
    _varietyController.dispose();
    _sowingDateController.dispose();
    _customSoilTypeController.dispose();
    super.dispose();
  }

  // Helpers to get localized display strings for dropdowns 🌟
  String _getLocalizedIrrigation(String key, AppLocalizations l10n) {
    switch (key) {
      case 'Drip':
        return l10n.drip;
      case 'Sprinkler':
        return l10n.sprinkler;
      case 'Flood':
        return l10n.flood;
      case 'Canal':
        return l10n.canal;
      default:
        return key;
    }
  }

  String _getLocalizedFarming(String key, AppLocalizations l10n) {
    switch (key) {
      case 'Organic':
        return l10n.organic;
      case 'Conventional':
        return l10n.conventional;
      case 'Hydroponic':
        return l10n.hydroponic;
      case 'No-Till':
        return l10n.noTill;
      default:
        return key;
    }
  }

  String _getLocalizedSoil(String key, AppLocalizations l10n) {
    switch (key) {
      case 'Alluvial Soil':
        return l10n.soilAlluvial;
      case 'Black Soil (Regur Soil)':
        return l10n.soilBlack;
      case 'Red Soil':
        return l10n.soilRed;
      case 'Laterite Soil':
        return l10n.soilLaterite;
      case 'Arid (Desert) Soil':
        return l10n.soilArid;
      case 'Mountain (Forest) Soil':
        return l10n.soilMountain;
      case 'Saline and Alkaline Soil':
        return l10n.soilSaline;
      case 'Other (type it)':
        return l10n.soilOther;
      default:
        return key;
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0A6F3B),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedSowingDate = picked;
        // Uses standard numbers for the date format
        String standardDate =
            "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
        _sowingDateController.text = standardDate;
      });
    }
  }

  Future<void> _savePlotDetails(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSowingDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.invalidDateError)));
      return;
    }

    // Formats the backend date safely (YYYY-MM-DD)
    final isoDate =
        "${_selectedSowingDate!.year}-${_selectedSowingDate!.month.toString().padLeft(2, '0')}-${_selectedSowingDate!.day.toString().padLeft(2, '0')}";

    final plotName = _farmNameController.text.trim();
    final cropName = _cropNameController.text.trim();
    final cropVariety = _varietyController.text.trim();
    final latitude = widget.centerLatitude.toStringAsFixed(6);
    final longitude = widget.centerLongitude.toStringAsFixed(6);
    final totalAcres = widget.areaInAcres;

    // We send the English Keys directly to the backend!
    final irrigation = _selectedIrrigation ?? '';
    final farmingType = _selectedFarmingType ?? '';
    final soilType =
        _isSoilTypeCustom
            ? _customSoilTypeController.text.trim()
            : (_selectedSoilType ?? '');

    if (irrigation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectIrrigationError),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (farmingType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectFarmingError),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (soilType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectSoilError),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await _auth.createPlot(
        plotName: plotName,
        latitude: latitude,
        longitude: longitude,
        totalAcres: totalAcres,
        cropName: cropName,
        cropVariety: cropVariety,
        sowingDate: isoDate,
        typeOfIrrigation: irrigation,
        typeOfFarming: farmingType,
        soilType: soilType,
      );

      if (mounted) Navigator.of(context).pop();

      if (result is String) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result), backgroundColor: Colors.red),
        );
        return;
      }

      if (result is Map) {
        final message = result['message'];
        if (message is Map && message['status'] == 'error') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message['message'] ?? l10n.unexpectedServerError),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (message is Map && message['status'] == 'ok') {
          _showSuccessAndNavigate(l10n);
          return;
        }

        if (result['status'] == 'ok' || result.containsKey('name')) {
          _showSuccessAndNavigate(l10n);
          return;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.unexpectedServerError),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorSavingPlot}$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSuccessAndNavigate(AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.plotSavedMsg,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0A6F3B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(l10n),
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildPlotInfoSection(l10n),
                  _buildFormSection(l10n),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(l10n),
    );
  }

  Widget _buildSliverAppBar(AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF0A6F3B),
      iconTheme: const IconThemeData(color: Colors.white),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: FadeTransition(
          opacity: _headerAnimation,
          child: Text(
            l10n.addPlotDetails,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 0.3,
            ),
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A6F3B), Color(0xFF0D8A4A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: 20,
                child: Opacity(
                  opacity: 0.1,
                  child: const Icon(
                    Icons.agriculture,
                    size: 150,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlotInfoSection(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A6F3B), Color(0xFF0D8A4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A6F3B).withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.plotLocation,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.centerLatitude.toStringAsFixed(6)}, ${widget.centerLongitude.toStringAsFixed(6)}',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.square_foot,
                          color: Color(0xFF0A6F3B),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.totalArea,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${widget.areaInAcres.toStringAsFixed(3)} ${l10n.acres}',
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.1,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A6F3B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.edit_note,
                  color: Color(0xFF0A6F3B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.plotInfo,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _farmNameController,
            label: l10n.farmName,
            hint: l10n.farmNameHint,
            icon: Icons.villa_outlined,
            l10n: l10n,
          ),
          _buildTextField(
            controller: _cropNameController,
            label: l10n.cropName,
            hint: l10n.cropNameHint,
            icon: Icons.grass,
            l10n: l10n,
          ),
          _buildTextField(
            controller: _varietyController,
            label: l10n.cropVariety,
            hint: l10n.cropVarietyHint,
            icon: Icons.science_outlined,
            l10n: l10n,
          ),
          _buildDatePickerField(l10n),
          _buildIrrigationDropdown(l10n),
          _buildFarmingDropdown(l10n),
          _buildSoilTypeField(l10n),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required AppLocalizations l10n,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF0A6F3B)),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAF9),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF0A6F3B),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return l10n.fieldRequired;
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIrrigationDropdown(AppLocalizations l10n) {
    return _buildDropdownBase(
      label: l10n.irrigationTypeLabel,
      value: _selectedIrrigation,
      icon: Icons.water_drop_outlined,
      l10n: l10n,
      items:
          _irrigationKeys.map((key) {
            return DropdownMenuItem<String>(
              value: key,
              child: Text(
                _getLocalizedIrrigation(key, l10n),
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
      onChanged: (value) => setState(() => _selectedIrrigation = value),
    );
  }

  Widget _buildFarmingDropdown(AppLocalizations l10n) {
    return _buildDropdownBase(
      label: l10n.farmingTypeLabel,
      value: _selectedFarmingType,
      icon: Icons.eco_outlined,
      l10n: l10n,
      items:
          _farmingKeys.map((key) {
            return DropdownMenuItem<String>(
              value: key,
              child: Text(
                _getLocalizedFarming(key, l10n),
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
      onChanged: (value) => setState(() => _selectedFarmingType = value),
    );
  }

  Widget _buildDropdownBase({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
    required AppLocalizations l10n,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF0A6F3B)),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: value,
            items: items,
            onChanged: onChanged,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: l10n.selectOptionHint,
              hintStyle: GoogleFonts.inter(
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAF9),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF0A6F3B),
                  width: 2,
                ),
              ),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF0A6F3B),
            ),
            validator: (value) => value == null ? l10n.selectOptionError : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSoilTypeField(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.landscape_outlined,
                size: 18,
                color: Color(0xFF0A6F3B),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.soilType,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedSoilType,
            items:
                _soilKeys.map((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(
                      _getLocalizedSoil(key, l10n),
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color:
                            key == 'Other (type it)'
                                ? const Color(0xFF0A6F3B)
                                : Colors.black87,
                        fontStyle:
                            key == 'Other (type it)'
                                ? FontStyle.italic
                                : FontStyle.normal,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSoilType = value;
                _isSoilTypeCustom = value == 'Other (type it)';
                if (!_isSoilTypeCustom) _customSoilTypeController.clear();
              });
            },
            decoration: InputDecoration(
              hintText: l10n.selectSoilType,
              hintStyle: GoogleFonts.inter(
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAF9),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF0A6F3B),
                  width: 2,
                ),
              ),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF0A6F3B),
            ),
            validator: (value) => value == null ? l10n.selectSoilError : null,
          ),

          if (_isSoilTypeCustom) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _customSoilTypeController,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: l10n.describeSoilType,
                hintStyle: GoogleFonts.inter(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAF9),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                prefixIcon: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF0A6F3B),
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF0A6F3B),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF0A6F3B),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
              ),
              validator: (value) {
                if (_isSoilTypeCustom &&
                    (value == null || value.trim().isEmpty)) {
                  return l10n.pleaseDescribeSoil;
                }
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDatePickerField(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: Color(0xFF0A6F3B),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.sowingDate,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _sowingDateController,
            readOnly: true,
            onTap: _selectDate,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: l10n.sowingDateHint,
              hintStyle: GoogleFonts.inter(
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAF9),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A6F3B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_month,
                  color: Color(0xFF0A6F3B),
                  size: 20,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF0A6F3B),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? l10n.selectDateError
                        : null,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0A6F3B), Color(0xFF0D8A4A)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0A6F3B).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _savePlotDetails(l10n),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.savePlotDetails,
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
