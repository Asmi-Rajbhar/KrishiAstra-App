import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/plot_model.dart';
import 'services/auth_service.dart';

class EditPlotDetailsPreview extends StatefulWidget {
  final Plot plot;

  const EditPlotDetailsPreview({super.key, required this.plot});

  @override
  State<EditPlotDetailsPreview> createState() =>
      _EditPlotDetailsPreviewState();
}

class _EditPlotDetailsPreviewState extends State<EditPlotDetailsPreview> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  late TextEditingController _farmNameController;
  late TextEditingController _cropNameController;
  late TextEditingController _varietyController;
  late TextEditingController _sowingDateController;
  late TextEditingController _harvestDateController;
  late TextEditingController _customSoilTypeController;

  String? _selectedIrrigation;
  String? _selectedFarmingType;
  String? _selectedSoilType;
  bool _isSoilTypeCustom = false;
  bool _isLoading = false;

  static const List<String> _irrigationOptions = [
    'Drip',
    'Sprinkler',
    'Flood',
    'Canal',
    'Rainfed',
  ];

  static const List<String> _farmingOptions = [
    'Organic',
    'Conventional',
    'Hydroponic',
    'No-Till',
  ];

  static const List<String> _soilOptions = [
    'Alluvial Soil',
    'Black Soil (Regur Soil)',
    'Red Soil',
    'Laterite Soil',
    'Arid (Desert) Soil',
    'Mountain (Forest) Soil',
    'Saline and Alkaline Soil',
    'Other (type it)',
  ];

  @override
  void initState() {
    super.initState();

    _farmNameController       = TextEditingController(text: widget.plot.name);
    _cropNameController       = TextEditingController(text: widget.plot.crop);
    _varietyController        = TextEditingController(text: widget.plot.variety);
    _sowingDateController     = TextEditingController(text: widget.plot.sowingDate);
    _harvestDateController    = TextEditingController(text: widget.plot.harvestDate);
    _customSoilTypeController = TextEditingController();

    _selectedIrrigation  = _validOption(widget.plot.irrigationType, _irrigationOptions);
    _selectedFarmingType = _validOption(widget.plot.farmingType, _farmingOptions);

    // Pre-populate soil type
    final existingSoil = widget.plot.soilType;
    if (existingSoil.isEmpty) {
      _selectedSoilType = null;
    } else if (_soilOptions.contains(existingSoil)) {
      _selectedSoilType = existingSoil;
    } else {
      _selectedSoilType = 'Other (type it)';
      _isSoilTypeCustom = true;
      _customSoilTypeController.text = existingSoil;
    }
  }

  String? _validOption(String value, List<String> options) =>
      options.contains(value) ? value : null;

  @override
  void dispose() {
    _farmNameController.dispose();
    _cropNameController.dispose();
    _varietyController.dispose();
    _sowingDateController.dispose();
    _harvestDateController.dispose();
    _customSoilTypeController.dispose();
    super.dispose();
  }

  // ── Date helpers ──────────────────────────────────────────────

  /// Converts "dd-mm-yyyy" display format → "yyyy-mm-dd" for Frappe.
  String? _toIsoDate(String input) {
    input = input.trim();
    if (input.isEmpty) return null;
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(input)) return input;
    final parts = input.split('-');
    if (parts.length == 3 && parts[0].length != 4) {
      final d = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final y = int.tryParse(parts[2]);
      if (d != null && m != null && y != null) {
        return '${y.toString().padLeft(4, '0')}'
            '-${m.toString().padLeft(2, '0')}'
            '-${d.toString().padLeft(2, '0')}';
      }
    }
    return input;
  }

  Future<void> _selectDate(
      TextEditingController controller, String title) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: title,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0A6F3B),
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        controller.text =
            '${picked.day.toString().padLeft(2, '0')}'
            '-${picked.month.toString().padLeft(2, '0')}'
            '-${picked.year}';
      });
    }
  }

  // ── Save ─────────────────────────────────────────────────────

  Future<void> _confirmUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final soilType = _isSoilTypeCustom
        ? _customSoilTypeController.text.trim()
        : (_selectedSoilType ?? '');

    if (soilType.isEmpty) {
      _showSnackbar('Please select or enter a soil type', Colors.orange);
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0A6F3B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.check_circle_outline,
                color: Color(0xFF0A6F3B), size: 24),
          ),
          const SizedBox(width: 12),
          Text('Confirm Update',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        ]),
        content: Text('Are you sure you want to update plot details?',
            style: GoogleFonts.inter(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600, color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A6F3B),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Update',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      final result = await _auth.editPlot(
        plotId:           widget.plot.id,
        plotName:         _farmNameController.text.trim(),
        cropName:         _cropNameController.text.trim(),
        cropVariety:      _varietyController.text.trim(),
        sowingDate:       _toIsoDate(_sowingDateController.text),
        harvestDate:      _toIsoDate(_harvestDateController.text),
        typeOfIrrigation: _selectedIrrigation,
        typeOfFarming:    _selectedFarmingType,
        soilType:         soilType,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result is String) {
        _showSnackbar(result, Colors.red);
        return;
      }

      if (result is Map) {
        if (result['status'] == 'error') {
          _showSnackbar(
              result['message']?.toString() ?? 'Failed to update plot',
              Colors.red);
          return;
        }

        if (result['status'] == 'ok') {
          // Show success snackbar briefly, then pop with the updated plot Map
          // so PlotDetailsPage can rebuild immediately without a network call.
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text('Plot updated successfully',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            ]),
            backgroundColor: const Color(0xFF0A6F3B),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ));

          // ── KEY CHANGE: return the updated plot map, not just `true` ──
          final updatedPlotData = result['plot'] as Map<String, dynamic>?;
          Navigator.pop(context, updatedPlotData);
          return;
        }
      }

      _showSnackbar('Unexpected server response', Colors.orange);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnackbar('Error updating plot: $e', Colors.red);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  // ── Build ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Text('Edit Plot Details',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w700, color: Colors.white)),
        backgroundColor: const Color(0xFF0A6F3B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _sectionTitle('Plot Information'),
                _textField(
                    controller: _farmNameController,
                    label: 'Farm Name',
                    icon: Icons.villa_outlined),
                _textField(
                    controller: _cropNameController,
                    label: 'Crop Name',
                    icon: Icons.grass),
                _textField(
                    controller: _varietyController,
                    label: 'Crop Variety',
                    icon: Icons.science_outlined),
                _textField(
                  controller: _sowingDateController,
                  label: 'Sowing Date',
                  icon: Icons.calendar_month_outlined,
                  readOnly: true,
                  onTap: () =>
                      _selectDate(_sowingDateController, 'Select Sowing Date'),
                ),
                _textField(
                  controller: _harvestDateController,
                  label: 'Expected Harvest Date',
                  icon: Icons.event_outlined,
                  readOnly: true,
                  onTap: () => _selectDate(
                      _harvestDateController, 'Select Harvest Date'),
                ),
                _dropdown(
                  label: 'Irrigation Type',
                  icon: Icons.water_drop_outlined,
                  value: _selectedIrrigation,
                  items: _irrigationOptions,
                  onChanged: (v) => setState(() => _selectedIrrigation = v),
                ),
                _dropdown(
                  label: 'Farming Type',
                  icon: Icons.eco_outlined,
                  value: _selectedFarmingType,
                  items: _farmingOptions,
                  onChanged: (v) => setState(() => _selectedFarmingType = v),
                ),
                _soilTypeField(),
                const SizedBox(height: 100),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.35),
              child: const Center(
                  child:
                      CircularProgressIndicator(color: Color(0xFF0A6F3B))),
            ),
        ],
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  // ── UI helpers ────────────────────────────────────────────────

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(title,
            style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87)),
      );

  InputDecoration _inputDecoration({bool greenBorder = false}) =>
      InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: greenBorder
                ? const BorderSide(color: Color(0xFF0A6F3B), width: 1.5)
                : BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: Color(0xFF0A6F3B), width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red, width: 2)),
      );

  Widget _fieldLabel(IconData icon, String label) => Row(children: [
        Icon(icon, size: 18, color: const Color(0xFF0A6F3B)),
        const SizedBox(width: 8),
        Text(label,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87)),
      ]);

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _fieldLabel(icon, label),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            validator: (v) =>
                v == null || v.isEmpty ? '$label is required' : null,
            style:
                GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
            decoration: _inputDecoration().copyWith(
              suffixIcon:
                  readOnly ? const Icon(Icons.calendar_today, size: 18) : null,
            ),
          ),
        ]),
      );

  Widget _dropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _fieldLabel(icon, label),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: value,
            items: items
                .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500, fontSize: 14))))
                .toList(),
            onChanged: onChanged,
            validator: (v) => v == null ? 'Please select $label' : null,
            decoration: _inputDecoration(),
            icon: const Icon(Icons.keyboard_arrow_down,
                color: Color(0xFF0A6F3B)),
          ),
        ]),
      );

  Widget _soilTypeField() => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _fieldLabel(Icons.landscape_outlined, 'Soil Type'),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedSoilType,
            items: _soilOptions
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: e == 'Other (type it)'
                                ? const Color(0xFF0A6F3B)
                                : Colors.black87,
                            fontStyle: e == 'Other (type it)'
                                ? FontStyle.italic
                                : FontStyle.normal,
                          )),
                    ))
                .toList(),
            onChanged: (v) => setState(() {
              _selectedSoilType = v;
              _isSoilTypeCustom = v == 'Other (type it)';
              if (!_isSoilTypeCustom) _customSoilTypeController.clear();
            }),
            validator: (v) => v == null ? 'Please select a soil type' : null,
            decoration: _inputDecoration(),
            icon: const Icon(Icons.keyboard_arrow_down,
                color: Color(0xFF0A6F3B)),
          ),
          if (_isSoilTypeCustom) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _customSoilTypeController,
              style:
                  GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
              decoration: _inputDecoration(greenBorder: true).copyWith(
                hintText: 'Describe your soil type...',
                hintStyle: GoogleFonts.inter(
                    color: Colors.grey[400], fontWeight: FontWeight.w500),
                prefixIcon: const Icon(Icons.edit_outlined,
                    color: Color(0xFF0A6F3B), size: 20),
              ),
              validator: (v) =>
                  _isSoilTypeCustom && (v == null || v.trim().isEmpty)
                      ? 'Please describe the soil type'
                      : null,
            ),
          ],
        ]),
      );

  Widget _bottomBar() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5))
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _isLoading ? null : _confirmUpdate,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isLoading
                      ? [Colors.grey.shade400, Colors.grey.shade500]
                      : [const Color(0xFF0A6F3B), const Color(0xFF0D8A4A)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF0A6F3B).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6))
                ],
              ),
              child: Center(
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5))
                    : Text('Update Plot',
                        style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.3)),
              ),
            ),
          ),
        ),
      );
}