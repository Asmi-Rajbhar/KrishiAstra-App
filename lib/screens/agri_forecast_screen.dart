import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/hf_prediction_service.dart';

class AgriForecastScreen extends StatefulWidget {
  const AgriForecastScreen({super.key});

  @override
  State<AgriForecastScreen> createState() => _AgriForecastScreenState();
}

class _AgriForecastScreenState extends State<AgriForecastScreen>
    with TickerProviderStateMixin {
  final TextEditingController cropController = TextEditingController();
  String selectedMonth = "January";
  String selectedSoil = "Alluvial Soil";

  bool isLoading = false;
  Map<String, dynamic>? result;

  late AnimationController _cardController;
  late AnimationController _resultController;

  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;
  late Animation<double> _resultFade;
  late Animation<Offset> _resultSlide;

  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  final List<String> soils = [
    "Alluvial Soil",
    "Red Soil",
    "Black Soil",
    "Laterite Soil",
    "Arid Soil",
    "Mountain Soil",
    "Alkaline Soil",
  ];

  final Map<String, IconData> soilIcons = {
    "Alluvial Soil": Icons.water_drop_outlined,
    "Red Soil": Icons.terrain,
    "Black Soil": Icons.dark_mode_outlined,
    "Laterite Soil": Icons.layers_outlined,
    "Arid Soil": Icons.wb_sunny_outlined,
    "Mountain Soil": Icons.landscape_outlined,
    "Alkaline Soil": Icons.science_outlined,
  };

  @override
  void initState() {
    super.initState();

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _resultController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _cardFade = CurvedAnimation(parent: _cardController, curve: Curves.easeOut);
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutCubic),
    );

    _resultFade = CurvedAnimation(
      parent: _resultController,
      curve: Curves.easeOut,
    );
    _resultSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.easeOutCubic),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      _cardController.forward();
    });
  }

  @override
  void dispose() {
    _cardController.dispose();
    _resultController.dispose();
    cropController.dispose();
    super.dispose();
  }

  Future<void> predict() async {
    setState(() {
      isLoading = true;
      result = null;
    });
    _resultController.reset();

    try {
      final data = await HFPredictionService.getPrediction(
        crop: cropController.text,
        month: selectedMonth,
        soil: selectedSoil,
      );
      setState(() {
        result = data;
        isLoading = false;
      });
      _resultController.forward();
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // ─── COLOR PALETTE ───────────────────────────────────────────────
  static const Color primary = Color(0xFF0A6F3B);
  static const Color primaryLight = Color(0xFF16A35A);
  static const Color primarySoft = Color(0xFFE8F5EE);
  static const Color bg = Color(0xFFF7FAF8);
  static const Color cardWhite = Colors.white;
  static const Color textDark = Color(0xFF1A2E23);
  static const Color textMid = Color(0xFF4B6358);
  static const Color textLight = Color(0xFF8AAA98);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  _buildInputCard(),
                  const SizedBox(height: 24),
                  _buildPredictButton(),
                  const SizedBox(height: 32),
                  if (isLoading) _buildLoadingState(),
                  if (result != null) _buildResultSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── SLIVER APP BAR ──────────────────────────────────────────────
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A6F3B), Color(0xFF0D8F4C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.agriculture, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Text(
            "AgriForecast Pro",
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.translate_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ─── INPUT CARD ──────────────────────────────────────────────────
  Widget _buildInputCard() {
    return FadeTransition(
      opacity: _cardFade,
      child: SlideTransition(
        position: _cardSlide,
        child: Container(
          decoration: BoxDecoration(
            color: cardWhite,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primarySoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Forecast Parameters",
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildLabel("Crop Name", Icons.grass_rounded),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: cropController,
                  hint: "e.g. Wheat, Rice, Cotton...",
                  icon: Icons.local_florist_outlined,
                ),
                const SizedBox(height: 20),
                _buildLabel("Sowing Month", Icons.calendar_month_rounded),
                const SizedBox(height: 8),
                _buildDropdown<String>(
                  value: selectedMonth,
                  items: months,
                  icon: Icons.calendar_today_outlined,
                  onChanged: (v) => setState(() => selectedMonth = v!),
                ),
                const SizedBox(height: 20),
                _buildLabel("Soil Type", Icons.terrain_rounded),
                const SizedBox(height: 8),
                _buildDropdown<String>(
                  value: selectedSoil,
                  items: soils,
                  icon: soilIcons[selectedSoil] ?? Icons.layers_outlined,
                  onChanged: (v) => setState(() => selectedSoil = v!),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: primary, size: 15),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textMid,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: textDark,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(color: textLight, fontSize: 14),
        prefixIcon: Icon(icon, color: primaryLight, size: 20),
        filled: true,
        fillColor: primarySoft,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: primarySoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: primary),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: textDark,
          ),
          items:
              items
                  .map(
                    (item) => DropdownMenuItem<T>(
                      value: item as T,
                      child: Row(
                        children: [
                          Icon(icon, color: primaryLight, size: 18),
                          const SizedBox(width: 10),
                          Text(item),
                        ],
                      ),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ─── PREDICT BUTTON ──────────────────────────────────────────────
  Widget _buildPredictButton() {
    return GestureDetector(
      onTap: predict,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0A6F3B), Color(0xFF1AAD5A)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_graph_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(
              "Predict Profitability",
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── LOADING STATE ───────────────────────────────────────────────
  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(primary),
              strokeWidth: 3,
              backgroundColor: primarySoft,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Analyzing your crop data...",
            style: GoogleFonts.plusJakartaSans(
              color: textMid,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── RESULT SECTION ──────────────────────────────────────────────
  Widget _buildResultSection() {
    return FadeTransition(
      opacity: _resultFade,
      child: SlideTransition(
        position: _resultSlide,
        child:
            result!["soil_suitable"] == true
                ? _buildSuitableUI()
                : _buildNotSuitableUI(),
      ),
    );
  }

  // ─── SUITABLE UI ─────────────────────────────────────────────────
  Widget _buildSuitableUI() {
    final harvest = result!["harvest_month"] as String;
    final profitScore = result!["expected_profit_score"] as double;
    final bestMonths = result!["best_sowing_months"] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusBanner(
          icon: Icons.check_circle_rounded,
          title: "Soil is Suitable",
          subtitle: "Great choice! This soil works well for your crop.",
          isSuccess: true,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.event_available_rounded,
                label: "Harvest Month",
                value: harvest,
                color: const Color(0xFF10B981),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(child: _buildScoreCard(profitScore)),
          ],
        ),
        const SizedBox(height: 28),
        _buildSectionHeader(
          "Best Sowing Windows",
          Icons.calendar_view_month_rounded,
        ),
        const SizedBox(height: 14),
        ...bestMonths.asMap().entries.map((entry) {
          final i = entry.key;
          final month = entry.value;
          final score = month["profit_score"] as double;
          return _buildMonthCard(
            month: month["sowing_month"],
            harvest: month["harvest_month"],
            score: score,
            rank: i + 1,
          );
        }).toList(),
      ],
    );
  }

  // ─── NOT SUITABLE UI ─────────────────────────────────────────────
  Widget _buildNotSuitableUI() {
    final alternatives = result!["top_alternatives"] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusBanner(
          icon: Icons.warning_amber_rounded,
          title: "Soil Not Compatible",
          subtitle: result!["message"] ?? "Consider alternatives below.",
          isSuccess: false,
        ),
        const SizedBox(height: 28),
        _buildSectionHeader("Recommended Alternatives", Icons.eco_rounded),
        const SizedBox(height: 14),
        ...alternatives.asMap().entries.map((entry) {
          final i = entry.key;
          final alt = entry.value;
          final score = alt["profit_score"] as double;
          return _buildAlternativeCard(
            crop: alt["crop"],
            harvest: alt["harvest_month"],
            score: score,
            rank: i + 1,
          );
        }).toList(),
      ],
    );
  }

  // ─── SHARED WIDGETS ───────────────────────────────────────────────

  Widget _buildStatusBanner({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSuccess,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isSuccess
                  ? [const Color(0xFFD1FAE5), const Color(0xFFECFDF5)]
                  : [const Color(0xFFFEE2E2), const Color(0xFFFFF1F2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSuccess ? const Color(0xFF6EE7B7) : const Color(0xFFFCA5A5),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  isSuccess
                      ? const Color(0xFF10B981).withOpacity(0.15)
                      : const Color(0xFFEF4444).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color:
                  isSuccess ? const Color(0xFF059669) : const Color(0xFFDC2626),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color:
                        isSuccess
                            ? const Color(0xFF065F46)
                            : const Color(0xFF991B1B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color:
                        isSuccess
                            ? const Color(0xFF047857)
                            : const Color(0xFFB91C1C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              color: textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(double score) {
    Color scoreColor =
        score > 0.7
            ? const Color(0xFF10B981)
            : score > 0.4
            ? const Color(0xFFF59E0B)
            : const Color(0xFFEF4444);

    String scoreLabel =
        score > 0.7
            ? "High"
            : score > 0.4
            ? "Medium"
            : "Low";

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: scoreColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.auto_graph_rounded, color: scoreColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            "Profit Score",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              color: textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                score.toStringAsFixed(3),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: scoreColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  scoreLabel,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: scoreColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: score),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder:
                  (context, val, _) => LinearProgressIndicator(
                    value: val,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade100,
                    color: scoreColor,
                  ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "0",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: textLight,
                ),
              ),
              Text(
                "1",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primarySoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primary, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthCard({
    required String month,
    required String harvest,
    required double score,
    required int rank,
  }) {
    final isTop = rank == 1;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (rank * 80)),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(18),
        border:
            isTop
                ? Border.all(color: primary.withOpacity(0.3), width: 1.5)
                : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isTop ? primary : primarySoft,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                "#$rank",
                style: GoogleFonts.plusJakartaSans(
                  color: isTop ? Colors.white : primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    month,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.event_available_rounded,
                        size: 13,
                        color: Color(0xFF8AAA98),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Harvest: $harvest",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: primarySoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                score.toStringAsFixed(3),
                style: GoogleFonts.plusJakartaSans(
                  color: primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlternativeCard({
    required String crop,
    required String harvest,
    required double score,
    required int rank,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (rank * 80)),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: primarySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.eco_rounded, color: primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crop,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.event_available_rounded,
                        size: 13,
                        color: Color(0xFF8AAA98),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Harvest: $harvest",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: primarySoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    score.toStringAsFixed(3),
                    style: GoogleFonts.plusJakartaSans(
                      color: primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: score),
                    duration: Duration(milliseconds: 800 + (rank * 150)),
                    curve: Curves.easeOutCubic,
                    builder:
                        (context, val, _) => SizedBox(
                          width: 70,
                          child: LinearProgressIndicator(
                            value: val,
                            minHeight: 4,
                            backgroundColor: Colors.grey.shade100,
                            color: primary,
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}