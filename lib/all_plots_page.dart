// lib/all_plots_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/auth_service.dart';
import 'plot_details_page.dart';
import 'l10n/app_localizations.dart';
import 'models/plot_model.dart';

class AllPlotsPage extends StatefulWidget {
  const AllPlotsPage({super.key});

  @override
  State<AllPlotsPage> createState() => _AllPlotsPageState();
}

class _AllPlotsPageState extends State<AllPlotsPage>
    with SingleTickerProviderStateMixin {
  List<Plot> myPlots = [];
  bool isLoading = true;
  String? errorMessage;
  String searchQuery = '';
  String sortBy = 'name';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPlots();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPlots() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final auth = AuthService();
      final list = await auth.fetchPlots();
      final loaded = list.map<Plot>((p) => Plot.fromJson(p)).toList();
      if (!mounted) return;
      setState(() {
        myPlots = loaded;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  List<Plot> get activePlots =>
      myPlots.where((p) => p.status == 'Active').toList();

  List<Plot> get inactivePlots =>
      myPlots.where((p) => p.status == 'Inactive').toList();

  List<Plot> _getFilteredAndSortedPlots(List<Plot> plots) {
    var filtered = plots.where((plot) {
      if (searchQuery.isEmpty) return true;
      final q = searchQuery.toLowerCase();
      return plot.name.toLowerCase().contains(q) ||
          plot.crop.toLowerCase().contains(q) ||
          plot.location.toLowerCase().contains(q);
    }).toList();

    switch (sortBy) {
      case 'area':
        filtered.sort((a, b) => b.area.compareTo(a.area));
        break;
      case 'crop':
        filtered.sort((a, b) => a.crop.compareTo(b.crop));
        break;
      case 'name':
      default:
        filtered.sort((a, b) => a.name.compareTo(b.name));
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalArea = myPlots.fold<double>(0, (s, p) => s + p.area);
    final activeArea = activePlots.fold<double>(0, (s, p) => s + p.area);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          l10n.myPlots,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A6F3B), Color(0xFF0D8C4A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.6),
          labelStyle: GoogleFonts.poppins(
              fontSize: 15, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(
              fontSize: 15, fontWeight: FontWeight.w500),
          tabs: [
            Tab(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 18),
                    const SizedBox(width: 6),
                    Text('Active (${activePlots.length})'),
                  ]),
            ),
            Tab(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.archive_outlined, size: 18),
                    const SizedBox(width: 6),
                    Text('Inactive (${inactivePlots.length})'),
                  ]),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [Color(0xFFF1F8F4), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Stats header ──────────────────────────────────────────────
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF667eea).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10))
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(Icons.landscape_outlined,
                        myPlots.length.toString(), l10n.totalPlots),
                    Container(
                        width: 1,
                        height: 50,
                        color: Colors.white.withOpacity(0.3)),
                    _buildStatItem(Icons.square_foot,
                        totalArea.toStringAsFixed(1), l10n.acres),
                    Container(
                        width: 1,
                        height: 50,
                        color: Colors.white.withOpacity(0.3)),
                    _buildStatItem(Icons.check_circle,
                        activeArea.toStringAsFixed(1), 'Active ${l10n.acres}'),
                  ],
                ),
              ),

              // ── Search + Sort ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: TextField(
                        onChanged: (v) => setState(() => searchQuery = v),
                        decoration: InputDecoration(
                          hintText: 'Search plots...',
                          hintStyle: GoogleFonts.poppins(
                              color: Colors.grey[400], fontSize: 14),
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey[400]),
                        ),
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  PopupMenuButton<String>(
                    onSelected: (v) => setState(() => sortBy = v),
                    itemBuilder: (context) => [
                      _buildSortMenuItem(
                          'name', 'Sort by Name', Icons.sort_by_alpha),
                      _buildSortMenuItem(
                          'area', 'Sort by Area', Icons.square_foot),
                      _buildSortMenuItem('crop', 'Sort by Crop', Icons.grass),
                    ],
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child:
                          Icon(Icons.filter_list, color: Colors.grey[600]),
                    ),
                  ),
                ]),
              ),

              const SizedBox(height: 20),

              // ── Tab content ───────────────────────────────────────────────
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF0A6F3B)))
                    : errorMessage != null
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline,
                                  size: 64, color: Colors.red[300]),
                              const SizedBox(height: 16),
                              Text('Failed to load plots',
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700])),
                              const SizedBox(height: 8),
                              Text(errorMessage!,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[600]),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: _loadPlots,
                                icon: const Icon(Icons.refresh),
                                label: Text('Retry',
                                    style: GoogleFonts.poppins()),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFF0A6F3B),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                              ),
                            ],
                          ))
                        : TabBarView(
                            controller: _tabController,
                            children: [
                              _buildPlotsList(activePlots, l10n, true),
                              _buildPlotsList(inactivePlots, l10n, false),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildSortMenuItem(
          String value, String label, IconData icon) =>
      PopupMenuItem(
        value: value,
        child: Row(children: [
          Icon(icon,
              color: sortBy == value
                  ? const Color(0xFF0A6F3B)
                  : Colors.grey[600],
              size: 20),
          const SizedBox(width: 12),
          Text(label,
              style: GoogleFonts.poppins(
                  color: sortBy == value
                      ? const Color(0xFF0A6F3B)
                      : Colors.grey[800],
                  fontWeight: sortBy == value
                      ? FontWeight.w600
                      : FontWeight.w500)),
        ]),
      );

  Widget _buildPlotsList(
      List<Plot> plots, AppLocalizations l10n, bool isActive) {
    final display = _getFilteredAndSortedPlots(plots);

    if (display.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            searchQuery.isNotEmpty
                ? Icons.search_off
                : isActive
                    ? Icons.landscape_outlined
                    : Icons.archive_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            searchQuery.isNotEmpty
                ? 'No plots found'
                : isActive
                    ? 'No active plots'
                    : 'No inactive plots',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isNotEmpty
                ? 'Try a different search term'
                : isActive
                    ? 'All your plots are inactive'
                    : 'All your plots are active',
            style: GoogleFonts.poppins(
                fontSize: 14, color: Colors.grey[600]),
          ),
        ]),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPlots,
      color: const Color(0xFF0A6F3B),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: display.length,
        itemBuilder: (context, index) =>
            _buildPlotCard(context, display[index], index, l10n, isActive),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) =>
      Column(children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500)),
      ]);

  Color _soilColor(String soilType) {
    final lower = soilType.toLowerCase();
    if (lower.contains('alluvial')) return const Color(0xFF2196F3);
    if (lower.contains('black') || lower.contains('regur'))
      return const Color(0xFF424242);
    if (lower.contains('red')) return const Color(0xFFE53935);
    if (lower.contains('laterite')) return const Color(0xFFBF360C);
    if (lower.contains('arid') || lower.contains('desert'))
      return const Color(0xFFF9A825);
    if (lower.contains('mountain') || lower.contains('forest'))
      return const Color(0xFF2E7D32);
    if (lower.contains('saline') || lower.contains('alkaline'))
      return const Color(0xFF6A1B9A);
    return const Color(0xFF8B6914);
  }

  Widget _buildPlotCard(
    BuildContext context,
    Plot plot,
    int index,
    AppLocalizations l10n,
    bool isActive,
  ) {
    final soilColor = _soilColor(plot.soilType);

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) => Transform.translate(
        offset: Offset(0, 20 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? const Color(0xFF0A6F3B).withOpacity(0.2)
                : Colors.grey[300]!,
            width: isActive ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 4))
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            // ── KEY CHANGE: await the push; refresh list when we return ──
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlotDetailsPage(plot: plot),
                ),
              );
              // PlotDetailsPage may have edited the plot — re-fetch so the
              // card shows the latest data (soil type, crop name, etc.)
              _loadPlots();
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // ── Plot image with status dot ──────────────────────────
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ColorFiltered(
                          colorFilter: isActive
                              ? const ColorFilter.mode(
                                  Colors.transparent, BlendMode.multiply)
                              : ColorFilter.mode(
                                  Colors.grey.shade400, BlendMode.saturation),
                          child: Image.asset(
                            plot.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12)),
                              child: Icon(Icons.image_not_supported_outlined,
                                  color: Colors.grey[400], size: 32),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF4CAF50)
                                : Colors.grey[600],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4)
                            ],
                          ),
                          child: Icon(
                              isActive ? Icons.check : Icons.archive,
                              color: Colors.white,
                              size: 14),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  // ── Plot details ──────────────────────────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + farming type badge
                        Row(children: [
                          Expanded(
                            child: Text(
                              plot.name,
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isActive
                                      ? Colors.black87
                                      : Colors.grey[600]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: plot.farmingType == 'Organic'
                                  ? const Color(0xFF4CAF50).withOpacity(0.1)
                                  : const Color(0xFF2196F3).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              plot.farmingType,
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: plot.farmingType == 'Organic'
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xFF2196F3),
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 5),

                        // Crop
                        Row(children: [
                          Icon(Icons.grass, size: 13, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(plot.crop,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ]),
                        const SizedBox(height: 4),

                        // Area + Irrigation
                        Row(children: [
                          Icon(Icons.square_foot,
                              size: 13, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('${plot.area} ${l10n.acres}',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(width: 8),
                          Icon(Icons.water_drop,
                              size: 13, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              plot.irrigationType.split(' ')[0],
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 4),

                        // Soil type badge
                        if (plot.soilType.isNotEmpty)
                          Row(children: [
                            Icon(Icons.landscape_outlined,
                                size: 13, color: soilColor),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: soilColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: soilColor.withOpacity(0.25)),
                                ),
                                child: Text(
                                  plot.soilType,
                                  style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: soilColor,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ]),

                        // Harvest date for inactive plots
                        if (!isActive) ...[
                          const SizedBox(height: 4),
                          Row(children: [
                            Icon(Icons.calendar_today,
                                size: 13, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Harvested: ${plot.harvestDate}',
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ]),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios,
                      size: 14, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}