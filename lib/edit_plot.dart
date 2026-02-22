import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/plot_model.dart';

class EditPlotDetailsPreview extends StatefulWidget {
  final Plot plot;
  
  const EditPlotDetailsPreview({super.key, required this.plot});

  @override
  State<EditPlotDetailsPreview> createState() =>
      _EditPlotDetailsPreviewState();
}

class _EditPlotDetailsPreviewState extends State<EditPlotDetailsPreview> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _farmNameController;
  late TextEditingController _cropNameController;
  late TextEditingController _varietyController;
  late TextEditingController _sowingDateController;
  late TextEditingController _harvestDateController;

  String? _selectedIrrigation;
  String? _selectedFarmingType;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with plot data
    _farmNameController = TextEditingController(text: widget.plot.name);
    _cropNameController = TextEditingController(text: widget.plot.crop);
    _varietyController = TextEditingController(text: widget.plot.variety);
    _sowingDateController = TextEditingController(text: widget.plot.sowingDate);
    _harvestDateController = TextEditingController(text: widget.plot.harvestDate);
    
    _selectedIrrigation = widget.plot.irrigationType;
    _selectedFarmingType = widget.plot.farmingType;
  }

  @override
  void dispose() {
    _farmNameController.dispose();
    _cropNameController.dispose();
    _varietyController.dispose();
    _sowingDateController.dispose();
    _harvestDateController.dispose();
    super.dispose();
  }

  // ================= DATE PICKER =================
  Future<void> _selectDate(TextEditingController controller, String title) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: title,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0A6F3B),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        controller.text =
            "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      });
    }
  }

  // ================= CONFIRM DIALOG =================
  Future<void> _confirmUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0A6F3B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Color(0xFF0A6F3B),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Confirm Update',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to update plot details?',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A6F3B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Update',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // TODO: Implement actual update logic here
      // You can send the updated data to your backend API
      
      // Show success message
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'Plot updated successfully',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF0A6F3B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      
      // Return true to indicate successful update
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Text(
          'Edit Plot Details',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0A6F3B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _sectionTitle('Plot Information'),
            _textField(
              controller: _farmNameController,
              label: 'Farm Name',
              icon: Icons.villa_outlined,
            ),
            _textField(
              controller: _cropNameController,
              label: 'Crop Name',
              icon: Icons.grass,
            ),
            _textField(
              controller: _varietyController,
              label: 'Crop Variety',
              icon: Icons.science_outlined,
            ),
            _textField(
              controller: _sowingDateController,
              label: 'Sowing Date',
              icon: Icons.calendar_month_outlined,
              readOnly: true,
              onTap: () => _selectDate(_sowingDateController, 'Select Sowing Date'),
            ),
            _textField(
              controller: _harvestDateController,
              label: 'Expected Harvest Date',
              icon: Icons.event_outlined,
              readOnly: true,
              onTap: () => _selectDate(_harvestDateController, 'Select Harvest Date'),
            ),
            _dropdown(
              label: 'Irrigation Type',
              icon: Icons.water_drop_outlined,
              value: _selectedIrrigation,
              items: const ['Drip', 'Sprinkler', 'Flood', 'Canal', 'Rainfed'],
              onChanged: (v) => setState(() => _selectedIrrigation = v),
            ),
            _dropdown(
              label: 'Farming Type',
              icon: Icons.eco_outlined,
              value: _selectedFarmingType,
              items: const [
                'Organic',
                'Conventional',
                'Hydroponic',
                'No-Till'
              ],
              onChanged: (v) => setState(() => _selectedFarmingType = v),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  // ================= UI HELPERS =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            validator: (v) =>
                v == null || v.isEmpty ? '$label is required' : null,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
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
                borderSide: const BorderSide(color: Colors.red),
              ),
              suffixIcon: readOnly
                  ? const Icon(Icons.calendar_today, size: 18)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: value,
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            validator: (v) => v == null ? 'Please select $label' : null,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
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
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _confirmUpdate,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0A6F3B), Color(0xFF0D8A4A)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0A6F3B).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Update Plot',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}