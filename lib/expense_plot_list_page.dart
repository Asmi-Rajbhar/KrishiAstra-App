import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/plot_model.dart';
import 'expense_tracker_screen.dart';
import 'plot_analytics_page.dart';

class ExpensePlotListPage extends StatelessWidget {
  final List<Plot> plots;

  const ExpensePlotListPage({Key? key, required this.plots}) : super(key: key);

  static const Color _primary = Color(0xFF0A6F3B);
  static const Color _trackerColor = Color(0xFF2196F3);
  static const Color _analyticsColor = Color(0xFF009688);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: _primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0A6F3B), Color(0xFF0D8C4A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.attach_money,
                                  color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expense Tracker',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${plots.length} plot${plots.length == 1 ? '' : 's'} available',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.85),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Info banner ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Row(
                children: [
                  _infoChip(
                    Icons.edit_note_rounded,
                    'Tracker',
                    'Add expenses & sales',
                    _trackerColor,
                  ),
                  const SizedBox(width: 10),
                  _infoChip(
                    Icons.bar_chart_rounded,
                    'Analytics',
                    'Monthly & yearly view',
                    _analyticsColor,
                  ),
                ],
              ),
            ),
          ),

          // ── Section label ─────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Select a Plot',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          // ── Plot cards ───────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _PlotCard(
                  plot: plots[index],
                  index: index,
                ),
                childCount: plots.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(
      IconData icon, String title, String subtitle, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// INDIVIDUAL PLOT CARD
// ═══════════════════════════════════════════════════════════════
class _PlotCard extends StatelessWidget {
  final Plot plot;
  final int index;

  const _PlotCard({required this.plot, required this.index});

  static const Color _primary = Color(0xFF0A6F3B);
  static const Color _trackerColor = Color(0xFF2196F3);
  static const Color _analyticsColor = Color(0xFF009688);

  static const Map<String, String> _cropEmojis = {
    'Wheat': '🌾',
    'Rice': '🌾',
    'Corn': '🌽',
    'Tomato': '🍅',
    'Potato': '🥔',
    'Cotton': '🌸',
    'Sugarcane': '🎋',
    'Sorghum': '🌾',
    'Millet': '🌾',
  };

  static const List<Color> _accentColors = [
    Color(0xFF0A6F3B),
    Color(0xFF2196F3),
    Color(0xFF9C27B0),
    Color(0xFFFF9800),
    Color(0xFFE91E63),
  ];

  @override
  Widget build(BuildContext context) {
    final cropName = plot.crop ?? 'Crop';
    final emoji = _cropEmojis[cropName] ?? '🌱';
    final accent = _accentColors[index % _accentColors.length];
    final plotLabel = plot.name ?? 'Plot ${index + 1}';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Top: plot info ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(emoji,
                        style: const TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plotLabel,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          _tag(Icons.grass_outlined, cropName, accent),
                          const SizedBox(width: 6),
                          if (plot.area != null)
                            _tag(Icons.straighten_outlined,
                                '${plot.area} Acre', Colors.grey),
                        ],
                      ),
                      if (plot.sowingDate != null &&
                          plot.sowingDate!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _tag(Icons.calendar_today_outlined,
                                'Sown: ${plot.sowingDate}', Colors.orange),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: accent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Divider ───────────────────────────────────────────
          Divider(height: 1, color: Colors.grey[100]),

          // ── Bottom: action buttons ────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Row(
              children: [
                // FIX: Use plot.id (Frappe doc name) not plot.name (human label)
                Expanded(
                  child: _ActionButton(
                    icon: Icons.edit_note_rounded,
                    label: 'Add Expense / Sale',
                    sublabel: 'Expense Tracker',
                    color: _trackerColor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExpenseTrackerPage(
                          plotId: plot.id,          // ← FIX: was plot.name
                          cropName: plot.crop,
                          farmingType: plot.farmingType,
                          sowingDate: plot.sowingDate,
                          harvestDate: plot.harvestDate,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Analytics button — PlotAnalyticsPage uses plot.id internally via _plotFrappeId
                Expanded(
                  child: _ActionButton(
                    icon: Icons.bar_chart_rounded,
                    label: 'Monthly & Yearly',
                    sublabel: 'View Analytics',
                    color: _analyticsColor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlotAnalyticsPage(plot: plot),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color.withOpacity(0.7)),
        const SizedBox(width: 3),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ACTION BUTTON WIDGET
// ═══════════════════════════════════════════════════════════════
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25), width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sublabel,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      color: Colors.grey[500],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}