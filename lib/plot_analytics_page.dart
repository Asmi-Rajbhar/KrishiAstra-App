import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'services/auth_service.dart';
import 'models/plot_model.dart';

class PlotAnalyticsPage extends StatefulWidget {
  final Plot plot;
  const PlotAnalyticsPage({Key? key, required this.plot}) : super(key: key);

  @override
  State<PlotAnalyticsPage> createState() => _PlotAnalyticsPageState();
}

class _PlotAnalyticsPageState extends State<PlotAnalyticsPage>
    with SingleTickerProviderStateMixin {
  // ── Colors ──────────────────────────────────────────────────
  static const Color _primary      = Color(0xFF1B6E35);
  static const Color _salesColor   = Color(0xFF1565C0);
  static const Color _expenseColor = Color(0xFFBF360C);
  static const Color _profitColor  = Color(0xFF2E7D32);
  static const Color _lossColor    = Color(0xFFC62828);
  static const Color _bgColor      = Color(0xFFF1F8F3);

  late TabController _tabController;
  bool    _isLoading = false;
  String? _error;
  String  _viewType  = 'monthly';

  List<int> _availableYears = [];
  int?      _selectedYear;

  List<Map<String, dynamic>> _salesData   = [];
  List<Map<String, dynamic>> _expenseData = [];

  Map<int, double> _revenueByPeriod = {};
  Map<int, double> _expenseByPeriod = {};
  double _totalRevenue = 0;
  double _totalExpense = 0;

  // Year picker
  final TextEditingController _yearSearchCtrl = TextEditingController();
  List<int>     _filteredYears    = [];
  bool          _showYearDropdown = false;
  final LayerLink    _yearLayerLink    = LayerLink();
  OverlayEntry? _yearOverlay;

  static const List<String> _monthNames = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const List<String> _monthNamesFull = [
    '', 'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  String get _plotFrappeId => widget.plot.id ?? widget.plot.name ?? '';
  String get _plotDisplayName => widget.plot.name ?? widget.plot.id ?? 'Plot';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedYear  = DateTime.now().year;
    _yearSearchCtrl.text = _selectedYear.toString();
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _yearSearchCtrl.dispose();
    _removeOverlay();
    super.dispose();
  }

  // ── Overlay helpers ───────────────────────────────────────────
  void _removeOverlay() { _yearOverlay?.remove(); _yearOverlay = null; }

  void _showOverlay() {
    _removeOverlay();
    _yearOverlay = OverlayEntry(
      builder: (_) => Positioned(
        width: 180,
        child: CompositedTransformFollower(
          link: _yearLayerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 50),
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: _filteredYears.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(18),
                      child: Text('No years found',
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: Colors.grey[500]),
                          textAlign: TextAlign.center))
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _filteredYears.length,
                      itemBuilder: (_, i) {
                        final yr    = _filteredYears[i];
                        final isSel = yr == _selectedYear;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedYear = yr;
                              _yearSearchCtrl.text = yr.toString();
                              _showYearDropdown = false;
                            });
                            _removeOverlay();
                            _fetchData();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 13),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? _primary.withOpacity(0.09)
                                  : Colors.transparent,
                              borderRadius: i == 0
                                  ? const BorderRadius.vertical(
                                      top: Radius.circular(14))
                                  : i == _filteredYears.length - 1
                                      ? const BorderRadius.vertical(
                                          bottom: Radius.circular(14))
                                      : BorderRadius.zero,
                            ),
                            child: Row(children: [
                              if (isSel) ...[
                                const Icon(Icons.check,
                                    size: 14, color: _primary),
                                const SizedBox(width: 6),
                              ],
                              Text(yr.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: isSel
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSel ? _primary : Colors.black87,
                                  )),
                            ]),
                          ),
                        );
                      }),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_yearOverlay!);
  }

  List<int> get _allYearsList => _availableYears.isNotEmpty
      ? _availableYears
      : List.generate(5, (i) => DateTime.now().year - i);

  void _onYearSearchChanged(String q) {
    setState(() {
      _filteredYears = q.isEmpty
          ? List.from(_allYearsList)
          : _allYearsList.where((y) => y.toString().contains(q)).toList();
    });
    _yearOverlay != null
        ? _yearOverlay!.markNeedsBuild()
        : _showOverlay();
  }

  // ── Fetch ──────────────────────────────────────────────────────
  Future<void> _fetchData() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final plotId = _plotFrappeId;
      if (plotId.isEmpty) {
        setState(() {
          _error = 'Plot ID not found. Please go back and try again.';
          _isLoading = false;
        });
        return;
      }

      final auth   = AuthService();
      final result = await auth.getPlotAnalytics(
        plotId:   plotId,
        viewType: _viewType,
        year: _viewType == 'monthly' ? _selectedYear.toString() : null,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        _salesData   = List<Map<String, dynamic>>.from(result['sales']    ?? []);
        _expenseData = List<Map<String, dynamic>>.from(result['expenses'] ?? []);

        final years = List<Map<String, dynamic>>.from(
            result['available_years'] ?? []);
        _availableYears = years
            .map<int>((y) => int.tryParse(y['yr'].toString()) ?? 0)
            .where((y) => y > 0)
            .toList();

        _filteredYears = List.from(_allYearsList);

        if (_availableYears.isNotEmpty &&
            !_availableYears.contains(_selectedYear)) {
          _selectedYear = _availableYears.first;
          _yearSearchCtrl.text = _selectedYear.toString();
        }
        _processData();
      } else {
        setState(() =>
            _error = result['message']?.toString() ?? 'Could not load data. Please try again.');
      }
    } catch (e) {
      if (mounted) setState(() => _error = 'Connection failed. Check your internet and retry.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _processData() {
    _revenueByPeriod = {};
    _expenseByPeriod = {};
    for (final s in _salesData) {
      final p = int.tryParse(s['period'].toString()) ?? 0;
      _revenueByPeriod[p] = (_revenueByPeriod[p] ?? 0) +
          (double.tryParse(s['total_revenue'].toString()) ?? 0);
    }
    for (final e in _expenseData) {
      final p = int.tryParse(e['period'].toString()) ?? 0;
      _expenseByPeriod[p] = (_expenseByPeriod[p] ?? 0) +
          (double.tryParse(e['total_expense'].toString()) ?? 0);
    }
    _totalRevenue = _revenueByPeriod.values.fold(0, (a, b) => a + b);
    _totalExpense = _expenseByPeriod.values.fold(0, (a, b) => a + b);
    setState(() {});
  }

  bool get _hasNoData =>
      _revenueByPeriod.isEmpty && _expenseByPeriod.isEmpty;

  List<int> get _periods {
    if (_viewType == 'monthly') return List.generate(12, (i) => i + 1);
    final all = {..._revenueByPeriod.keys, ..._expenseByPeriod.keys}.toList()..sort();
    return all.isEmpty ? [DateTime.now().year] : all;
  }

  String _periodLabel(int p) =>
      _viewType == 'monthly' ? _monthNames[p] : p.toString();

  String _periodLabelFull(int p) =>
      _viewType == 'monthly' ? _monthNamesFull[p] : p.toString();

  // ── Build ──────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _removeOverlay();
        setState(() => _showYearDropdown = false);
      },
      child: Scaffold(
        backgroundColor: _bgColor,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _plotDisplayName,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: Colors.white),
              ),
              Text(
                'Income & Expense Report',
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.85)),
              ),
            ],
          ),
          backgroundColor: _primary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle:
                GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13),
            unselectedLabelStyle:
                GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 13),
            tabs: const [
              Tab(icon: Icon(Icons.bar_chart_rounded, size: 18), text: 'Charts'),
              Tab(icon: Icon(Icons.table_rows_rounded, size: 18), text: 'Details'),
            ],
          ),
        ),
        body: Column(children: [
          _buildControls(),
          Expanded(
            child: _isLoading
                ? _buildLoading()
                : _error != null
                    ? _buildError()
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildChartView(),
                          _buildTableView(),
                        ],
                      ),
          ),
        ]),
      ),
    );
  }

  // ── Loading ────────────────────────────────────────────────────
  Widget _buildLoading() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const CircularProgressIndicator(color: _primary, strokeWidth: 3),
        const SizedBox(height: 16),
        Text('Loading your farm data…',
            style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500)),
      ]),
    );
  }

  // ── Controls bar ──────────────────────────────────────────────
  Widget _buildControls() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(children: [
        // Monthly / Yearly toggle
        Container(
          decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[200]!)),
          child: Row(children: [
            _toggleBtn('📅 Monthly', 'monthly'),
            _toggleBtn('📆 Yearly', 'yearly'),
          ]),
        ),
        const SizedBox(width: 10),

        // Year picker
        if (_viewType == 'monthly')
          Expanded(
            child: CompositedTransformTarget(
              link: _yearLayerLink,
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: _bgColor,
                  border: Border.all(
                      color: _showYearDropdown
                          ? _primary
                          : Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.calendar_month_rounded,
                      size: 17, color: _primary),
                  const SizedBox(width: 7),
                  Expanded(
                    child: TextField(
                      controller: _yearSearchCtrl,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: 'Year',
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.grey[400]),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onTap: () {
                        setState(() {
                          _filteredYears    = List.from(_allYearsList);
                          _showYearDropdown = true;
                        });
                        _showOverlay();
                      },
                      onChanged: _onYearSearchChanged,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_showYearDropdown) {
                        _removeOverlay();
                        setState(() => _showYearDropdown = false);
                      } else {
                        setState(() {
                          _filteredYears    = List.from(_allYearsList);
                          _showYearDropdown = true;
                        });
                        _showOverlay();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        _showYearDropdown
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: _primary, size: 22,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),

        if (_viewType == 'yearly') const Spacer(),
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: _primary, size: 22),
          onPressed: _fetchData,
          tooltip: 'Refresh',
        ),
      ]),
    );
  }

  Widget _toggleBtn(String label, String value) {
    final isSel = _viewType == value;
    return GestureDetector(
      onTap: () {
        if (_viewType != value) {
          setState(() => _viewType = value);
          _fetchData();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSel ? _primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSel ? Colors.white : Colors.grey[600],
            )),
      ),
    );
  }

  // ── Error ──────────────────────────────────────────────────────
  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08), shape: BoxShape.circle),
            child: const Icon(Icons.wifi_off_rounded,
                size: 56, color: Colors.redAccent),
          ),
          const SizedBox(height: 20),
          Text('Could Not Load Data',
              style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87)),
          const SizedBox(height: 8),
          Text(_error!,
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _fetchData,
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            label: Text('Try Again',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ]),
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
                color: _primary.withOpacity(0.07), shape: BoxShape.circle),
            child: Text('🌾',
                style: const TextStyle(fontSize: 52)),
          ),
          const SizedBox(height: 24),
          Text('No Records Yet',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87)),
          const SizedBox(height: 10),
          Text(
            _viewType == 'monthly'
                ? 'No income or expense records found\nfor the year $_selectedYear.'
                : 'No income or expense records\nhave been added yet.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600],
                height: 1.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Use the Expense Tracker to add\nyour farm income and expenses.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
          ),
          const SizedBox(height: 26),
          OutlinedButton.icon(
            onPressed: _fetchData,
            icon: const Icon(Icons.refresh_rounded, color: _primary, size: 18),
            label: Text('Refresh',
                style: GoogleFonts.poppins(
                    color: _primary, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _primary),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 26, vertical: 11),
            ),
          ),
        ]),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // CHART VIEW
  // ══════════════════════════════════════════════════════════════
  Widget _buildChartView() {
    if (_hasNoData) return _buildEmptyState();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 32),
      child: Column(children: [
        // Top summary hero
        _buildHeroProfitCard(),
        const SizedBox(height: 14),
        // 3 summary tiles
        _buildSummaryTiles(),
        const SizedBox(height: 18),
        // Tip box
        _buildFarmerTipCard(),
        const SizedBox(height: 18),
        // Bar chart
        _buildBarChartCard(),
        const SizedBox(height: 18),
        // Profit line
        _buildProfitLineChart(),
        const SizedBox(height: 18),
        // Expense breakdown
        _buildExpenseBreakdown(),
      ]),
    );
  }

  // Big hero card showing net result
  Widget _buildHeroProfitCard() {
    final profit   = _totalRevenue - _totalExpense;
    final isProfit = profit >= 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isProfit
              ? [const Color(0xFF1B6E35), const Color(0xFF2E9651)]
              : [const Color(0xFFB71C1C), const Color(0xFFE53935)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isProfit ? _profitColor : _lossColor).withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(isProfit ? '📈' : '📉',
              style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 10),
          Text(
            isProfit ? 'You Made a Profit!' : 'You Are at a Loss',
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
        ]),
        const SizedBox(height: 6),
        Text(
          _viewType == 'monthly'
              ? 'For the year $_selectedYear'
              : 'Overall all years',
          style: GoogleFonts.poppins(
              fontSize: 12, color: Colors.white.withOpacity(0.8)),
        ),
        const SizedBox(height: 16),
        Row(children: [
          Text(
            '₹${_fmtFull(profit.abs())}',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isProfit ? 'NET PROFIT' : 'NET LOSS',
              style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
        ]),
        if (_totalRevenue > 0) ...[
          const SizedBox(height: 12),
          // Mini profit margin indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (_totalExpense / _totalRevenue).clamp(0.0, 1.0),
              backgroundColor: Colors.white.withOpacity(0.3),
              color: Colors.white,
              minHeight: 7,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${((_totalExpense / _totalRevenue) * 100).toStringAsFixed(0)}% of income spent on expenses',
            style: GoogleFonts.poppins(
                fontSize: 11, color: Colors.white.withOpacity(0.85)),
          ),
        ],
      ]),
    );
  }

  Widget _buildSummaryTiles() {
    return Row(children: [
      Expanded(
          child: _summaryTile(
              emoji: '🌾',
              label: 'Total Income',
              value: '₹${_fmtFull(_totalRevenue)}',
              sub: 'from crop sales',
              color: _salesColor)),
      const SizedBox(width: 10),
      Expanded(
          child: _summaryTile(
              emoji: '💸',
              label: 'Total Spent',
              value: '₹${_fmtFull(_totalExpense)}',
              sub: 'on farm expenses',
              color: _expenseColor)),
    ]);
  }

  Widget _summaryTile({
    required String emoji,
    required String label,
    required String value,
    required String sub,
    required Color color,
  }) =>
      Container(
        padding: const EdgeInsets.all(14),
        decoration: _cardDeco(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          ]),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(sub,
              style: GoogleFonts.poppins(
                  fontSize: 10, color: Colors.grey[500])),
        ]),
      );

  // Farmer tip box — shows advice based on profit/loss
  Widget _buildFarmerTipCard() {
    final profit   = _totalRevenue - _totalExpense;
    final isProfit = profit >= 0;
    final ratio    = _totalRevenue > 0
        ? (_totalExpense / _totalRevenue)
        : 0.0;

    String emoji, title, message;
    Color  bgColor, borderColor;

    if (_totalRevenue == 0 && _totalExpense == 0) return const SizedBox();

    if (isProfit && ratio < 0.5) {
      emoji = '🎉'; title = 'Great Work!';
      message =
          'Your expenses are well under control. Less than half your income is being spent on expenses.';
      bgColor = const Color(0xFFE8F5E9); borderColor = const Color(0xFF81C784);
    } else if (isProfit && ratio < 0.8) {
      emoji = '👍'; title = 'Doing Well';
      message =
          'You are making a profit. Try to reduce expenses further to increase your savings.';
      bgColor = const Color(0xFFF1F8E9); borderColor = const Color(0xFFAED581);
    } else if (isProfit) {
      emoji = '⚠️'; title = 'Watch Your Expenses';
      message =
          'You are still in profit, but expenses are high. Look for ways to cut costs next season.';
      bgColor = const Color(0xFFFFFDE7); borderColor = const Color(0xFFFFD54F);
    } else {
      emoji = '🚨'; title = 'Action Needed';
      message =
          'Your expenses are more than your income. Consider ways to increase your crop sales or reduce costs.';
      bgColor = const Color(0xFFFFEBEE); borderColor = const Color(0xFFEF9A9A);
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.3),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87)),
            const SizedBox(height: 3),
            Text(message,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.5)),
          ]),
        ),
      ]),
    );
  }

  // Bar chart
  Widget _buildBarChartCard() {
    final periods = _periods;
    final maxY = [
      ..._revenueByPeriod.values,
      ..._expenseByPeriod.values,
      1.0
    ].reduce((a, b) => a > b ? a : b) * 1.25;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDeco(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionHeader(
          '📊',
          _viewType == 'monthly'
              ? 'Month-wise Income & Expense'
              : 'Year-wise Income & Expense',
          subtitle: _viewType == 'monthly' ? 'Year $_selectedYear' : 'All Years',
        ),
        const SizedBox(height: 12),
        Row(children: [
          _legendDot(_salesColor, '🌾 Income'),
          const SizedBox(width: 18),
          _legendDot(_expenseColor, '💸 Expense'),
        ]),
        const SizedBox(height: 20),
        SizedBox(
          height: 210,
          child: BarChart(BarChartData(
            maxY: maxY,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, _, rod, rodIdx) {
                  final p   = periods[group.x.toInt()];
                  final lbl = rodIdx == 0 ? '🌾 Income' : '💸 Expense';
                  return BarTooltipItem(
                    '$lbl\n${_periodLabelFull(p)}\n₹${_fmtFull(rod.toY)}',
                    GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  );
                },
              ),
            ),
            titlesData: _barTitles(periods),
            gridData: FlGridData(
              drawVerticalLine: false,
              getDrawingHorizontalLine: (v) =>
                  FlLine(color: Colors.grey[200]!, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(periods.length, (i) {
              final p = periods[i];
              final w = _viewType == 'monthly' ? 7.0 : 16.0;
              return BarChartGroupData(x: i, barRods: [
                BarChartRodData(
                    toY: _revenueByPeriod[p] ?? 0,
                    color: _salesColor,
                    width: w,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4))),
                BarChartRodData(
                    toY: _expenseByPeriod[p] ?? 0,
                    color: _expenseColor,
                    width: w,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4))),
              ], barsSpace: 3);
            }),
          )),
        ),
      ]),
    );
  }

  FlTitlesData _barTitles(List<int> periods) => FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 46,
            getTitlesWidget: (v, _) => Text('₹${_fmtShort(v)}',
                style: GoogleFonts.poppins(
                    fontSize: 9, color: Colors.grey[500])),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, _) {
              final idx = v.toInt();
              if (idx < 0 || idx >= periods.length) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(_periodLabel(periods[idx]),
                    style: GoogleFonts.poppins(
                        fontSize: 9, color: Colors.grey[600])),
              );
            },
          ),
        ),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      );

  // Profit/Loss line chart
  Widget _buildProfitLineChart() {
    final periods = _periods;
    final spots   = periods.asMap().entries.map((e) {
      final profit = (_revenueByPeriod[e.value] ?? 0) -
          (_expenseByPeriod[e.value] ?? 0);
      return FlSpot(e.key.toDouble(), profit);
    }).toList();
    final vals = spots.map((s) => s.y).toList();
    final minY =
        (vals.isEmpty ? 0.0 : vals.reduce((a, b) => a < b ? a : b)) * 1.2;
    final maxY =
        (vals.isEmpty ? 1.0 : vals.reduce((a, b) => a > b ? a : b)) * 1.2;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDeco(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionHeader('📈', 'Profit & Loss Over Time',
            subtitle: 'Above zero = profit, below = loss'),
        const SizedBox(height: 20),
        SizedBox(
          height: 190,
          child: LineChart(LineChartData(
            minY: minY < 0 ? minY : 0,
            maxY: maxY > 0 ? maxY : 1,
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (spots) => spots.map((s) {
                  final isPos = s.y >= 0;
                  return LineTooltipItem(
                    '${isPos ? '✅ Profit' : '❌ Loss'}\n'
                    '${_periodLabelFull(periods[s.x.toInt()])}\n'
                    '₹${_fmtFull(s.y.abs())}',
                    GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  );
                }).toList(),
              ),
            ),
            gridData: FlGridData(
              drawVerticalLine: false,
              getDrawingHorizontalLine: (v) => FlLine(
                color: v == 0 ? Colors.grey[400]! : Colors.grey[200]!,
                strokeWidth: v == 0 ? 1.8 : 1,
                dashArray: v == 0 ? null : [4, 4],
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: _barTitles(periods),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: _profitColor,
                barWidth: 3,
                dotData: FlDotData(
                  getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                    radius: 5,
                    color: spot.y >= 0 ? _profitColor : _lossColor,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _profitColor.withOpacity(0.25),
                      _profitColor.withOpacity(0.02),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ),
      ]),
    );
  }

  // Expense breakdown pie
  Widget _buildExpenseBreakdown() {
    final Map<String, double> byType = {};
    for (final e in _expenseData) {
      final type = e['expense_type']?.toString().trim();
      final key  = (type == null || type.isEmpty) ? 'Other' : type;
      byType[key] = (byType[key] ?? 0) +
          (double.tryParse(e['total_expense'].toString()) ?? 0);
    }
    if (byType.isEmpty) return const SizedBox();

    final colors = [
      const Color(0xFF1565C0),
      const Color(0xFFE65100),
      const Color(0xFF6A1B9A),
      const Color(0xFF2E7D32),
      const Color(0xFFC62828),
      const Color(0xFF00838F),
      const Color(0xFFF57F17),
    ];
    final entries = byType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = byType.values.fold(0.0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDeco(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionHeader('🗂️', 'Where Did You Spend?',
            subtitle: 'Breakdown by expense category'),
        const SizedBox(height: 20),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: 160,
            width: 160,
            child: PieChart(PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 38,
              sections: List.generate(entries.length, (i) {
                final e   = entries[i];
                final pct = total > 0 ? e.value / total * 100 : 0;
                return PieChartSectionData(
                  value: e.value,
                  color: colors[i % colors.length],
                  radius: 52,
                  title: '${pct.toStringAsFixed(0)}%',
                  titleStyle: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                );
              }),
            )),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(entries.length, (i) {
                final e = entries[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                            color: colors[i % colors.length],
                            shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.key,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87),
                                overflow: TextOverflow.ellipsis),
                            Text('₹${_fmtFull(e.value)}',
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.grey[600])),
                          ]),
                    ),
                  ]),
                );
              }),
            ),
          ),
        ]),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // TABLE / DETAIL VIEW
  // ══════════════════════════════════════════════════════════════
  Widget _buildTableView() {
    if (_hasNoData) return _buildEmptyState();
    final periods = _periods;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 32),
      child: Column(children: [
        _buildHeroProfitCard(),
        const SizedBox(height: 14),
        _buildSummaryTiles(),
        const SizedBox(height: 18),

        // Monthly best/worst callouts
        if (_viewType == 'monthly') _buildBestWorstMonths(),
        if (_viewType == 'monthly') const SizedBox(height: 18),

        // Detail table
        Container(
          decoration: _cardDeco(),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: _sectionHeader(
                    '📋',
                    _viewType == 'monthly'
                        ? 'Month-wise Details — $_selectedYear'
                        : 'Year-wise Details',
                  ),
                ),
                _tableHeader(),
                ...periods.asMap().entries.map((e) {
                  final p      = e.value;
                  final rev    = _revenueByPeriod[p] ?? 0;
                  final exp    = _expenseByPeriod[p] ?? 0;
                  final profit = rev - exp;
                  return _tableRow(
                    label:   _periodLabelFull(p),
                    revenue: rev,
                    expense: exp,
                    profit:  profit,
                    isAlt:   e.key % 2 == 1,
                  );
                }),
                _tableTotalRow(),
              ]),
        ),
      ]),
    );
  }

  // Best and worst month callout cards
  Widget _buildBestWorstMonths() {
    if (_revenueByPeriod.isEmpty && _expenseByPeriod.isEmpty) {
      return const SizedBox();
    }

    // Best profit month
    int?   bestMonth; double bestProfit = double.negativeInfinity;
    int?   worstMonth; double worstProfit = double.infinity;

    for (int m = 1; m <= 12; m++) {
      final rev = _revenueByPeriod[m] ?? 0;
      final exp = _expenseByPeriod[m] ?? 0;
      if (rev == 0 && exp == 0) continue;
      final profit = rev - exp;
      if (profit > bestProfit) { bestProfit = profit; bestMonth = m; }
      if (profit < worstProfit) { worstProfit = profit; worstMonth = m; }
    }

    if (bestMonth == null) return const SizedBox();

    return Row(children: [
      Expanded(
        child: _calloutCard(
          emoji: '🏆',
          title: 'Best Month',
          month: _monthNamesFull[bestMonth!],
          amount: bestProfit,
          isPositive: true,
          color: const Color(0xFFE8F5E9),
          borderColor: const Color(0xFF81C784),
        ),
      ),
      const SizedBox(width: 10),
      if (worstMonth != null && worstMonth != bestMonth)
        Expanded(
          child: _calloutCard(
            emoji: '📉',
            title: 'Hardest Month',
            month: _monthNamesFull[worstMonth!],
            amount: worstProfit,
            isPositive: worstProfit >= 0,
            color: const Color(0xFFFFEBEE),
            borderColor: const Color(0xFFEF9A9A),
          ),
        ),
    ]);
  }

  Widget _calloutCard({
    required String emoji,
    required String title,
    required String month,
    required double amount,
    required bool isPositive,
    required Color color,
    required Color borderColor,
  }) =>
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87)),
          ]),
          const SizedBox(height: 6),
          Text(month,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
          Text(
            '${isPositive ? '+' : ''}₹${_fmtFull(amount)}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isPositive ? _profitColor : _lossColor,
            ),
          ),
        ]),
      );

  Widget _tableHeader() => Container(
        color: _primary.withOpacity(0.07),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          Expanded(
              flex: 3,
              child: Text(
                  _viewType == 'monthly' ? 'Month' : 'Year',
                  style: _hdrStyle())),
          Expanded(
              flex: 2,
              child: Text('🌾 Income',
                  style: _hdrStyle(), textAlign: TextAlign.right)),
          Expanded(
              flex: 2,
              child: Text('💸 Spent',
                  style: _hdrStyle(), textAlign: TextAlign.right)),
          Expanded(
              flex: 2,
              child: Text('📊 P/L',
                  style: _hdrStyle(), textAlign: TextAlign.right)),
        ]),
      );

  Widget _tableRow({
    required String label,
    required double revenue,
    required double expense,
    required double profit,
    required bool isAlt,
  }) {
    final hasData = revenue > 0 || expense > 0;
    final isPos   = profit >= 0;
    return Container(
      color: isAlt ? const Color(0xFFF7FBF8) : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(children: [
        Expanded(
            flex: 3,
            child: Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: hasData ? FontWeight.w600 : FontWeight.w400,
                    color: hasData ? Colors.black87 : Colors.grey[400]))),
        Expanded(
            flex: 2,
            child: Text(
                revenue > 0 ? '₹${_fmtShort(revenue)}' : '—',
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: revenue > 0 ? _salesColor : Colors.grey[400],
                    fontWeight: FontWeight.w600))),
        Expanded(
            flex: 2,
            child: Text(
                expense > 0 ? '₹${_fmtShort(expense)}' : '—',
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: expense > 0 ? _expenseColor : Colors.grey[400],
                    fontWeight: FontWeight.w600))),
        Expanded(
          flex: 2,
          child: Text(
            !hasData
                ? '—'
                : '${isPos ? '+' : '-'}₹${_fmtShort(profit.abs())}',
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: !hasData
                  ? Colors.grey[400]
                  : isPos
                      ? _profitColor
                      : _lossColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _tableTotalRow() {
    final netProfit = _totalRevenue - _totalExpense;
    final isPos     = netProfit >= 0;
    return Container(
      color: _primary.withOpacity(0.07),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Expanded(
            flex: 3,
            child: Text('TOTAL',
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _primary))),
        Expanded(
            flex: 2,
            child: Text('₹${_fmtShort(_totalRevenue)}',
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: _salesColor,
                    fontWeight: FontWeight.w800))),
        Expanded(
            flex: 2,
            child: Text('₹${_fmtShort(_totalExpense)}',
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: _expenseColor,
                    fontWeight: FontWeight.w800))),
        Expanded(
          flex: 2,
          child: Text(
            '${isPos ? '+' : '-'}₹${_fmtShort(netProfit.abs())}',
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isPos ? _profitColor : _lossColor,
            ),
          ),
        ),
      ]),
    );
  }

  // ── Shared helpers ────────────────────────────────────────────
  BoxDecoration _cardDeco() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      );

  Widget _sectionHeader(String emoji, String title, {String? subtitle}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87)),
            ),
          ]),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 28),
              child: Text(subtitle,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: Colors.grey[500])),
            ),
          ]
        ],
      );

  Widget _legendDot(Color color, String label) => Row(children: [
        Container(
            width: 11,
            height: 11,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12, color: Colors.grey[700],
                fontWeight: FontWeight.w500)),
      ]);

  TextStyle _hdrStyle() => GoogleFonts.poppins(
      fontSize: 11, fontWeight: FontWeight.w700, color: _primary);

  // ₹12,34,567 full format with commas (Indian style)
  String _fmtFull(double v) {
    if (v == 0) return '0';
    final abs = v.abs();
    final sign = v < 0 ? '-' : '';
    // Simple Indian number format
    final intPart = abs.toInt();
    final s = intPart.toString();
    if (s.length <= 3) {
      return '$sign$s';
    } else if (s.length <= 5) {
      return '$sign${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
    } else {
      final last3 = s.substring(s.length - 3);
      final rest  = s.substring(0, s.length - 3);
      final buf   = StringBuffer();
      int count = 0;
      for (int i = rest.length - 1; i >= 0; i--) {
        if (count > 0 && count % 2 == 0) buf.write(',');
        buf.write(rest[i]);
        count++;
      }
      return '$sign${buf.toString().split('').reversed.join()},$last3';
    }
  }

  // Short format for chart axes
  String _fmtShort(double v) {
    if (v.abs() >= 10000000) return '${(v / 10000000).toStringAsFixed(1)}Cr';
    if (v.abs() >= 100000) return '${(v / 100000).toStringAsFixed(1)}L';
    if (v.abs() >= 1000)   return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}