import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'all_plots_page.dart';
import 'expense_tracker_screen.dart';
import 'edit_plot.dart';
import 'l10n/app_localizations.dart';
import 'models/plot_model.dart';

// Crop harvest duration map (in days)
const Map<String, Map<String, int>> cropHarvestDuration = {
  'Sorghum': {'min': 90, 'max': 120},
  'Jowar': {'min': 90, 'max': 120},
  'Eggplant': {'min': 100, 'max': 140},
  'Brinjal': {'min': 100, 'max': 140},
  'Sugarcane': {'min': 300, 'max': 540},
  'Corn': {'min': 90, 'max': 120},
  'Maize': {'min': 90, 'max': 120},
  'Rice': {'min': 100, 'max': 150},
  'Paddy': {'min': 100, 'max': 150},
  'Wheat': {'min': 110, 'max': 130},
  'Tomato': {'min': 90, 'max': 120},
  'Bell Pepper': {'min': 90, 'max': 120},
  'Capsicum': {'min': 90, 'max': 120},
  'Peanut': {'min': 100, 'max': 130},
  'Groundnut': {'min': 100, 'max': 130},
};

String calculateHarvestDate(String sowingDate, String cropName) {
  try {
    final sowing = DateTime.parse(sowingDate);
    String? matchedCrop;
    for (var crop in cropHarvestDuration.keys) {
      if (cropName.toLowerCase().contains(crop.toLowerCase()) ||
          crop.toLowerCase().contains(cropName.toLowerCase())) {
        matchedCrop = crop;
        break;
      }
    }
    if (matchedCrop == null) {
      final h = sowing.add(const Duration(days: 120));
      return '${h.year}-${h.month.toString().padLeft(2, '0')}-${h.day.toString().padLeft(2, '0')}';
    }
    final duration = cropHarvestDuration[matchedCrop]!;
    final avgDays = ((duration['min']! + duration['max']!) / 2).round();
    final h = sowing.add(Duration(days: avgDays));
    return '${h.year}-${h.month.toString().padLeft(2, '0')}-${h.day.toString().padLeft(2, '0')}';
  } catch (e) {
    debugPrint('Error calculating harvest date: $e');
    return '';
  }
}

// ── Animated fade-in widget ───────────────────────────────────────────────────

class _AnimatedFadeIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const _AnimatedFadeIn({required this.child, this.delay = Duration.zero});

  @override
  State<_AnimatedFadeIn> createState() => _AnimatedFadeInState();
}

class _AnimatedFadeInState extends State<_AnimatedFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _opacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _controller, curve: Curves.easeOutCubic));
    _scale = Tween<double>(begin: 0.95, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _opacity,
        child: SlideTransition(
            position: _slide,
            child: ScaleTransition(scale: _scale, child: widget.child)),
      );
}

// ── Main page ─────────────────────────────────────────────────────────────────

class PlotDetailsPage extends StatefulWidget {
  final Plot plot;
  const PlotDetailsPage({super.key, required this.plot});

  @override
  State<PlotDetailsPage> createState() => _PlotDetailsPageState();
}

class _PlotDetailsPageState extends State<PlotDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ── Mutable local copy of the plot ──────────────────────────────────────────
  // This is the KEY change: instead of always reading widget.plot (immutable),
  // we keep a local _plot that we can update when the edit screen returns data.
  late Plot _plot;

  @override
  void initState() {
    super.initState();
    _plot = widget.plot; // initialise from the passed-in plot
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Navigate to edit and apply returned data locally ─────────────────────

  Future<void> _navigateToEditPlot() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditPlotDetailsPreview(plot: _plot),
      ),
    );

    // result is the updated plot Map returned by edit_plot.dart on success.
    // Rebuild _plot from it so all widgets on this page refresh instantly —
    // no extra network call needed.
    if (result is Map<String, dynamic> && mounted) {
      setState(() {
        _plot = Plot.fromJson({
          ...result,
          // edit_plot endpoint doesn't return status; preserve the existing one
          'status': _plot.status,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 280.0,
              floating: false,
              pinned: true,
              stretch: true,
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
                    onPressed: () =>
                        // Pop with true so AllPlotsPage knows to refresh list
                        Navigator.pop(context, true),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 20, bottom: 70),
                title: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  // Use _plot so the name updates after an edit
                  child: Text(
                    _plot.name,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      _plot.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF0A6F3B),
                        child: const Icon(Icons.landscape,
                            color: Colors.white60, size: 80),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAF9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF0A6F3B),
                    unselectedLabelColor: Colors.grey[600],
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(
                          width: 3, color: Color(0xFF0A6F3B)),
                      insets: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    labelStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: 0.2),
                    unselectedLabelStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w600, fontSize: 15),
                    tabs: [
                      Tab(text: l10n.overview),
                      Tab(text: l10n.climateSoil),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Pass _plot (mutable local copy) — NOT widget.plot
            _buildOverviewTab(_plot, l10n),
            ClimateTab(plot: _plot),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _fab(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Add Expense',
              heroTag: 'addExpense',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpenseTrackerPage(
                      plotId: _plot.id,
                      cropName: _plot.crop,
                      farmingType: _plot.farmingType,
                      sowingDate: _plot.sowingDate,
                      harvestDate: _plot.harvestDate,
                    ),
                  ),
                );
              },
            ),
            _fab(
              icon: Icons.edit_outlined,
              label: l10n.editPlot,
              heroTag: 'editPlot',
              onPressed: _navigateToEditPlot,
            ),
          ],
        ),
      ),
    );
  }

  Widget _fab({
    required IconData icon,
    required String label,
    required String heroTag,
    required VoidCallback onPressed,
  }) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF0A6F3B).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8))
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: onPressed,
          backgroundColor: const Color(0xFF0A6F3B),
          foregroundColor: Colors.white,
          heroTag: heroTag,
          elevation: 0,
          icon: Icon(icon, size: 20),
          label: Text(label,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: 0.3)),
        ),
      );

  // ── Overview tab ──────────────────────────────────────────────────────────

  Widget _buildOverviewTab(Plot plot, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      child: Column(
        children: [
          _AnimatedFadeIn(
            delay: const Duration(milliseconds: 100),
            child: _buildInfoCard(l10n.plotInfo, Icons.location_on_outlined, [
              _InfoRow(label: l10n.location, value: plot.location),
              _InfoRow(
                  label: l10n.area,
                  value: '${plot.area} ${l10n.acres}'),
              _InfoRow(
                  label: l10n.soilType,
                  value: plot.soilType,
                  highlight: true),
              _InfoRow(
                  label: l10n.irrigation, value: plot.irrigationType),
            ]),
          ),
          const SizedBox(height: 20),
          _AnimatedFadeIn(
            delay: const Duration(milliseconds: 200),
            child:
                _buildInfoCard(l10n.cropPlantation, Icons.eco_outlined, [
              _InfoRow(label: l10n.cropName, value: plot.crop),
              _InfoRow(label: l10n.variety, value: plot.variety),
              _InfoRow(label: l10n.sowingDate, value: plot.sowingDate),
              _InfoRow(
                  label: l10n.expectedHarvest, value: plot.harvestDate),
              _InfoRow(label: l10n.farmingType, value: plot.farmingType),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      String title, IconData icon, List<_InfoRow> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 30,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                const Color(0xFF0A6F3B).withOpacity(0.08),
                const Color(0xFF0A6F3B).withOpacity(0.03),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: const Color(0xFF0A6F3B),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      letterSpacing: 0.2)),
            ]),
          ),
          // Rows
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: rows
                  .map((row) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: row.highlight
                            ? _buildHighlightedRow(row.label, row.value)
                            : _buildNormalRow(row.label, row.value),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalRow(String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 5,
              child: Text(label,
                  style: GoogleFonts.inter(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.4))),
          Expanded(
              flex: 6,
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4))),
        ],
      );

  Widget _buildHighlightedRow(String label, String value) {
    IconData soilIcon = Icons.landscape_outlined;
    Color soilColor = const Color(0xFF8B6914);
    final lower = value.toLowerCase();
    if (lower.contains('alluvial')) {
      soilColor = const Color(0xFF2196F3);
      soilIcon = Icons.water_outlined;
    } else if (lower.contains('black') || lower.contains('regur')) {
      soilColor = const Color(0xFF424242);
      soilIcon = Icons.circle;
    } else if (lower.contains('red')) {
      soilColor = const Color(0xFFE53935);
      soilIcon = Icons.terrain;
    } else if (lower.contains('laterite')) {
      soilColor = const Color(0xFFBF360C);
      soilIcon = Icons.layers_outlined;
    } else if (lower.contains('arid') || lower.contains('desert')) {
      soilColor = const Color(0xFFF9A825);
      soilIcon = Icons.wb_sunny_outlined;
    } else if (lower.contains('mountain') || lower.contains('forest')) {
      soilColor = const Color(0xFF2E7D32);
      soilIcon = Icons.forest_outlined;
    } else if (lower.contains('saline') || lower.contains('alkaline')) {
      soilColor = const Color(0xFF6A1B9A);
      soilIcon = Icons.science_outlined;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 5,
            child: Text(label,
                style: GoogleFonts.inter(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4))),
        Expanded(
          flex: 6,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: soilColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: soilColor.withOpacity(0.3)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(soilIcon, size: 13, color: soilColor),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(value,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: soilColor,
                          height: 1.3),
                      overflow: TextOverflow.ellipsis),
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Data class ────────────────────────────────────────────────────────────────

class _InfoRow {
  final String label;
  final String value;
  final bool highlight;
  const _InfoRow(
      {required this.label, required this.value, this.highlight = false});
}

// ── Climate tab ───────────────────────────────────────────────────────────────

class ClimateTab extends StatefulWidget {
  final Plot plot;
  const ClimateTab({super.key, required this.plot});

  @override
  State<ClimateTab> createState() => _ClimateTabState();
}

class _ClimateTabState extends State<ClimateTab> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    const apiKey = 'a32ad422c06b469fa290bd839f1a6665';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${widget.plot.latitude}&lon=${widget.plot.longitude}&appid=$apiKey&units=metric';
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
            _errorMessage = 'Failed to load weather data.';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'An error occurred. Check connection.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(
              color: Color(0xFF0A6F3B), strokeWidth: 3));
    }
    if (_errorMessage != null) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(16)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.error_outline, color: Colors.red.shade700, size: 48),
            const SizedBox(height: 16),
            Text(l10n.connectionError,
                style: GoogleFonts.inter(
                    color: Colors.red.shade700,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
          ]),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _AnimatedFadeIn(
            delay: const Duration(milliseconds: 100),
            child: _buildWeatherHighlightCard(l10n)),
        const SizedBox(height: 28),
        _AnimatedFadeIn(
            delay: const Duration(milliseconds: 200),
            child: _buildSectionHeader(
                l10n.weatherDetails, Icons.wb_cloudy_outlined)),
        const SizedBox(height: 16),
        _AnimatedFadeIn(
            delay: const Duration(milliseconds: 300),
            child: _buildWeatherDetailsGrid(l10n)),
        const SizedBox(height: 28),
        _AnimatedFadeIn(
            delay: const Duration(milliseconds: 400),
            child:
                _buildSectionHeader(l10n.soilCondition, Icons.terrain)),
        const SizedBox(height: 16),
        _AnimatedFadeIn(
            delay: const Duration(milliseconds: 500),
            child: _buildSoilDetailsGrid(l10n)),
      ]),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) => Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: const Color(0xFF0A6F3B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: const Color(0xFF0A6F3B), size: 20),
        ),
        const SizedBox(width: 12),
        Text(title,
            style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: 0.2)),
      ]);

  Widget _buildWeatherHighlightCard(AppLocalizations l10n) {
    final temp =
        _weatherData?['main']?['temp']?.toStringAsFixed(1) ?? 'N/A';
    String desc =
        _weatherData?['weather']?[0]?['description'] ?? 'NA';
    desc = desc.isNotEmpty
        ? desc[0].toUpperCase() + desc.substring(1)
        : 'N/A';
    final feelsLike =
        _weatherData?['main']?['feels_like']?.toStringAsFixed(0) ??
            'N/A';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF4A90E2).withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 12))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$temp°C',
                        style: GoogleFonts.inter(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1)),
                    const SizedBox(height: 8),
                    Text(desc,
                        style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.95),
                            letterSpacing: 0.3)),
                  ]),
            ),
            Icon(_getWeatherIcon(),
                size: 80, color: Colors.white.withOpacity(0.9)),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.thermostat_outlined,
                color: Colors.white.withOpacity(0.9), size: 18),
            const SizedBox(width: 6),
            Text('${l10n.feelsLike} $feelsLike°C',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.95))),
          ]),
        ),
      ]),
    );
  }

  Widget _buildWeatherDetailsGrid(AppLocalizations l10n) {
    final humidity =
        _weatherData?['main']?['humidity']?.toString() ?? 'N/A';
    final pressure =
        _weatherData?['main']?['pressure']?.toString() ?? 'N/A';
    final windSpeed = _weatherData?['wind']?['speed'] != null
        ? (_weatherData!['wind']['speed'] * 3.6).toStringAsFixed(1)
        : 'N/A';
    final cloudiness =
        _weatherData?['clouds']?['all']?.toString() ?? 'N/A';
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.5,
      children: [
        _buildDetailItem(Icons.water_drop_outlined, l10n.humidity,
            '$humidity%', const Color(0xFF4A90E2)),
        _buildDetailItem(Icons.compress_outlined, l10n.pressure,
            '$pressure hPa', const Color(0xFFFF9500)),
        _buildDetailItem(Icons.air, l10n.windSpeed, '$windSpeed km/h',
            const Color(0xFF8E8E93)),
        _buildDetailItem(Icons.cloud_outlined, l10n.cloudiness,
            '$cloudiness%', const Color(0xFFAF52DE)),
      ],
    );
  }

  Widget _buildSoilDetailsGrid(AppLocalizations l10n) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.5,
        children: [
          _buildDetailItem(
              Icons.opacity, l10n.moisture, '0.61', const Color(0xFF34C759)),
          _buildDetailItem(Icons.thermostat_outlined, l10n.temperature,
              '24°C', const Color(0xFFFF3B30)),
          _buildDetailItem(Icons.science_outlined, l10n.phLevel, '6.5',
              const Color(0xFF0A6F3B)),
          _buildDetailItem(
              Icons.grass, l10n.nitrogen, '45 ppm', const Color(0xFF8B6914)),
        ],
      );

  Widget _buildDetailItem(
      IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  letterSpacing: 0.2),
              overflow: TextOverflow.ellipsis,
              maxLines: 1),
          const SizedBox(height: 2),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  letterSpacing: 0.2),
              overflow: TextOverflow.ellipsis,
              maxLines: 1),
        ],
      ),
    );
  }

  IconData _getWeatherIcon() {
    final main =
        _weatherData?['weather']?[0]?['main']?.toLowerCase() ?? '';
    switch (main) {
      case 'clouds':
        return Icons.cloud_queue;
      case 'rain':
        return Icons.grain;
      case 'drizzle':
        return Icons.water_drop;
      case 'thunderstorm':
        return Icons.thunderstorm;
      case 'snow':
        return Icons.ac_unit;
      case 'clear':
        return Icons.wb_sunny;
      default:
        return Icons.wb_cloudy;
    }
  }
}