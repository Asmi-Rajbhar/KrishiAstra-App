import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'l10n/app_localizations.dart';
import 'services/auth_service.dart';

class ExpenseTrackerPage extends StatefulWidget {
  final String plotId; 
  final String? cropName;
  final String? farmingType;
  final String? sowingDate;
  final String? harvestDate;

  const ExpenseTrackerPage({
    Key? key,
    required this.plotId, 
    this.cropName,
    this.farmingType,
    this.sowingDate,
    this.harvestDate,
  }) : super(key: key);

  @override
  State<ExpenseTrackerPage> createState() => _ExpenseTrackerPageState();
}

class Expense {
  final String type;
  final double amount;
  final DateTime date;

  Expense({required this.type, required this.amount, required this.date});
}

class SaleRecord {
  final double quantitySold;
  final double pricePerUnit;
  final DateTime? saleDate;
  final String unit;

  SaleRecord({
    required this.quantitySold,
    required this.pricePerUnit,
    this.saleDate,
    required this.unit,
  });

  double get revenue => quantitySold * pricePerUnit;
}

class _ExpenseTrackerPageState extends State<ExpenseTrackerPage> {
  // Theme Colors
  final Color _primaryColor = const Color(0xFF0A6F3B);
  final Color _secondaryColor = const Color(0xFF0D8C4A);
  final Color _bgColor = const Color(0xFFF1F8F4);

  // Variables
  String? selectedCrop;
  String? selectedFarmingType; // Changed from selectedYieldType
  String? selectedExpenseType;
  String? selectedYieldUnit;

  DateTime? sowingDate;
  DateTime? harvestDate;
  DateTime? expenseDate;
  DateTime? saleDate;

  final TextEditingController expenseController = TextEditingController();
  final TextEditingController yieldQtyController = TextEditingController();
  final TextEditingController soldQtyController = TextEditingController();
  final TextEditingController priceUnitController = TextEditingController();

  List<Expense> expenses = [];
  List<SaleRecord> salesRecords = [];
  double totalExpense = 0;
  double totalRevenue = 0;
  double netProfit = 0;
  bool isCalculated = false;
  bool isSaving = false; 

  @override
  void initState() {
    super.initState();
    // Parse and set the dates from the passed strings
    if (widget.sowingDate != null) {
      sowingDate = _parseDate(widget.sowingDate!);
    }
    if (widget.harvestDate != null) {
      harvestDate = _parseDate(widget.harvestDate!);
    }
  }

  DateTime? _parseDate(String dateString) {
    try {
      // Try parsing common date formats
      // Format: "15 Jan 2024" or "15/01/2024" or "2024-01-15"
      final formats = [
        DateFormat('dd MMM yyyy'),
        DateFormat('dd/MM/yyyy'),
        DateFormat('yyyy-MM-dd'),
        DateFormat('d MMM yyyy'),
      ];
      
      for (var format in formats) {
        try {
          return format.parse(dateString);
        } catch (e) {
          continue;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    expenseController.dispose();
    yieldQtyController.dispose();
    soldQtyController.dispose();
    priceUnitController.dispose();
    super.dispose();
  }

  void addExpense(AppLocalizations l10n) {
    final amount = double.tryParse(expenseController.text) ?? 0;
    if (amount <= 0) {
      _showSnackBar(l10n.enterValidAmount, Colors.redAccent);
      return;
    }
    if (expenseDate == null) {
      _showSnackBar('Please select expense date', Colors.redAccent);
      return;
    }
    setState(() {
      expenses.add(Expense(
        type: selectedExpenseType ?? '',
        amount: amount,
        date: expenseDate!,
      ));
      totalExpense += amount;
      expenseController.clear();
      expenseDate = null;
      isCalculated = false;
    });
  }

  void addSaleRecord(AppLocalizations l10n) {
    final soldQty = double.tryParse(soldQtyController.text) ?? 0;
    final pricePerUnit = double.tryParse(priceUnitController.text) ?? 0;

    if (soldQty <= 0 || pricePerUnit <= 0) {
      _showSnackBar(l10n.enterSaleDetails, Colors.redAccent);
      return;
    }
    if (saleDate == null) {
      _showSnackBar('Please select sale date', Colors.redAccent);
      return;
    }

    setState(() {
      salesRecords.add(SaleRecord(
        quantitySold: soldQty,
        pricePerUnit: pricePerUnit,
        saleDate: saleDate,
        unit: selectedYieldUnit ?? 'Kg',
      ));
      soldQtyController.clear();
      priceUnitController.clear();
      saleDate = null;
      isCalculated = false;
    });
  }

  void calculateProfit(AppLocalizations l10n) async{
    if (salesRecords.isEmpty) {
      _showSnackBar('Please add at least one sale record', Colors.redAccent);
      return;
    }

    setState(() {
      totalRevenue = salesRecords.fold(0, (sum, sale) => sum + sale.revenue);
      netProfit = totalRevenue - totalExpense;
      isCalculated = true;
    });

    await _saveToFrappe(l10n); 
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  Future<void> _selectDate(BuildContext context, String dateType) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
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
        if (dateType == 'sowing') sowingDate = picked;
        if (dateType == 'harvest') harvestDate = picked;
        if (dateType == 'expense') expenseDate = picked;
        if (dateType == 'sale') saleDate = picked;
      });
    }
  }

  Future<void> _saveToFrappe(AppLocalizations l10n) async {
    setState(() { isSaving = true; });

    // Prepare expense data
    List<Map<String, dynamic>> expenseData = expenses.map((exp) {
      return {
        'type': exp.type,  // → expense_type in backend
        'amount': exp.amount,
        'date': DateFormat('yyyy-MM-dd').format(exp.date),  // → expense_date
      };
    }).toList();

    // Prepare sales data
    final totalYield = double.tryParse(yieldQtyController.text) ?? 0;
    List<Map<String, dynamic>> salesData = salesRecords.map((sale) {
      return {
        'total_yield': totalYield,  // Your DocType field
        'unit': sale.unit,
        'quantity_sold': sale.quantitySold,
        'price_per_unit': sale.pricePerUnit,
        'sale_date': sale.saleDate != null 
            ? DateFormat('yyyy-MM-dd').format(sale.saleDate!)
            : DateFormat('yyyy-MM-dd').format(DateTime.now()),
      };
    }).toList();

    try {
      final auth = AuthService();
      final result = await auth.saveTransaction(
        plotId: widget.plotId,  // Using the plot ID
        expenses: expenseData,
        sales: salesData,
      );

      setState(() { isSaving = false; });

      if (result['success'] == true) {
        _showSnackBar(
          'Data saved successfully!\n${result['message']}',
          Colors.green,
        );
      } else {
        _showSnackBar('Error: ${result['message']}', Colors.redAccent);
      }
    } catch (e) {
      setState(() { isSaving = false; });
      _showSnackBar('Failed to save: $e', Colors.redAccent);
    }
  }

  @override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  final List<String> crops = [
    l10n.cropRice,
    l10n.cropWheat,
    l10n.cropCorn,
    l10n.cropSorghum,
    l10n.cropMillet,
    l10n.cropSugarcane,
    l10n.cropTomato,
    l10n.cropPotato,
    l10n.cropBrinjal,
    l10n.cropCapsicum,
  ];

  final List<String> yieldTypes = [
    l10n.yieldTypeGrain,
    l10n.yieldTypeVegetable,
    l10n.yieldTypeFruit,
    l10n.yieldTypeFiber,
  ];

  List<String> farmingTypeOptions;
  if (widget.farmingType != null) {
    farmingTypeOptions = [widget.farmingType!];
    selectedFarmingType = widget.farmingType;
  } else {
    farmingTypeOptions = yieldTypes;
    if (selectedFarmingType == null || !farmingTypeOptions.contains(selectedFarmingType)) {
      selectedFarmingType = farmingTypeOptions[0];
    }
  }

  final List<String> expenseTypes = [
    l10n.expSeeds,
    l10n.expFertilizer,
    l10n.expLabor,
    l10n.expIrrigation,
    l10n.expMachinery,
    l10n.expTransport,
    l10n.expOther,
  ];

  final List<String> yieldUnits = [
    l10n.unitKg,
    l10n.unitQuintal,
    l10n.unitTon,
  ];

  if (selectedCrop == null || !crops.contains(selectedCrop)) {
    if (widget.cropName != null) {
      selectedCrop = _findMatchingCrop(widget.cropName!, crops);
    } else {
      selectedCrop = crops[0];
    }
  }
  
  if (selectedExpenseType == null || !expenseTypes.contains(selectedExpenseType)) {
    selectedExpenseType = expenseTypes[0];
  }
  if (selectedYieldUnit == null || !yieldUnits.contains(selectedYieldUnit)) {
    selectedYieldUnit = yieldUnits[0];
  }

  return Scaffold(
    backgroundColor: _bgColor,
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      title: Text(
        l10n.profitTrackerTitle,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_primaryColor, _secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    ),
    body: Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Plot ID Info Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _primaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: _primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Saving to Plot: ${widget.plotId}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 1. Crop Details Section
                _buildSectionCard(
                  title: l10n.cropDetails,
                  icon: Icons.grass,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            label: l10n.selectCrop,
                            value: selectedCrop!,
                            items: crops,
                            onChanged: (val) => setState(() => selectedCrop = val!),
                            isDisabled: widget.cropName != null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdown(
                            label: 'Farming Type',
                            value: selectedFarmingType!,
                            items: farmingTypeOptions,
                            onChanged: (val) => setState(() => selectedFarmingType = val!),
                            isDisabled: widget.farmingType != null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDatePicker(
                            l10n.sowingDate,
                            sowingDate,
                            'sowing',
                            isDisabled: widget.sowingDate != null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDatePicker(
                            l10n.harvestDate,
                            harvestDate,
                            'harvest',
                            isDisabled: widget.harvestDate != null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 2. Expenses Section
                _buildSectionCard(
                  title: l10n.addExpense,
                  icon: Icons.account_balance_wallet_outlined,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildDropdown(
                            label: l10n.expenseType,
                            value: selectedExpenseType!,
                            items: expenseTypes,
                            onChanged: (val) => setState(() => selectedExpenseType = val!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: _buildTextField(
                            label: l10n.amount,
                            controller: expenseController,
                            isNumber: true,
                            icon: Icons.currency_rupee,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildDatePicker(
                            'Expense Date',
                            expenseDate,
                            'expense',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          child: ElevatedButton(
                            onPressed: () => addExpense(l10n),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Expense List Summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.expenseList,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                '${l10n.totalExpense}: ₹${totalExpense.toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          if (expenses.isEmpty)
                            Text(
                              l10n.noExpenses,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: expenses.length,
                              itemBuilder: (context, index) {
                                final exp = expenses[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              exp.type,
                                              style: GoogleFonts.poppins(fontSize: 13),
                                            ),
                                            Text(
                                              DateFormat('dd/MM/yyyy').format(exp.date),
                                              style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '₹${exp.amount.toStringAsFixed(0)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 3. Yield & Sale Section
                _buildSectionCard(
                  title: l10n.yieldAndSale,
                  icon: Icons.shopping_bag_outlined,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildTextField(
                            label: l10n.totalYield,
                            controller: yieldQtyController,
                            isNumber: true,
                            icon: Icons.scale,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: _buildDropdown(
                            label: l10n.yieldUnit,
                            value: selectedYieldUnit!,
                            items: yieldUnits,
                            onChanged: (val) => setState(() => selectedYieldUnit = val!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Sales Records',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: l10n.quantitySold,
                            controller: soldQtyController,
                            isNumber: true,
                            icon: Icons.shopping_cart_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            label: l10n.pricePerUnit,
                            controller: priceUnitController,
                            isNumber: true,
                            icon: Icons.currency_rupee,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildDatePicker(
                            l10n.saleDate,
                            saleDate,
                            'sale',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          child: ElevatedButton(
                            onPressed: () => addSaleRecord(l10n),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Sales Records List
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sales List',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Total: ₹${salesRecords.fold(0.0, (sum, sale) => sum + sale.revenue).toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          if (salesRecords.isEmpty)
                            Text(
                              'No sales recorded',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: salesRecords.length,
                              itemBuilder: (context, index) {
                                final sale = salesRecords[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${sale.quantitySold.toStringAsFixed(1)} ${sale.unit} @ ₹${sale.pricePerUnit.toStringAsFixed(2)}',
                                              style: GoogleFonts.poppins(fontSize: 13),
                                            ),
                                            if (sale.saleDate != null)
                                              Text(
                                                DateFormat('dd/MM/yyyy').format(sale.saleDate!),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '₹${sale.revenue.toStringAsFixed(0)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // 4. Calculate Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => calculateProfit(l10n),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      elevation: 8,
                      shadowColor: _primaryColor.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      l10n.calculateProfit,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // 5. Result Section
                if (isCalculated) ...[
                  const SizedBox(height: 30),
                  _buildResultCard(l10n),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        
        // Loading overlay
        if (isSaving)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: _primaryColor),
                      const SizedBox(height: 16),
                      Text(
                        'Saving to Frappe...',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}


  // Helper method to find matching crop
  String _findMatchingCrop(String cropName, List<String> crops) {
    // Direct match
    if (crops.contains(cropName)) return cropName;
    
    // Case-insensitive partial match
    final lowerCropName = cropName.toLowerCase();
    for (var crop in crops) {
      if (crop.toLowerCase().contains(lowerCropName) ||
          lowerCropName.contains(crop.toLowerCase())) {
        return crop;
      }
    }
    
    return crops[0]; // Default to first option if no match
  }

  // Helper method to find matching yield type
  String _findMatchingYieldType(String yieldType, List<String> yieldTypes) {
    // Direct match
    if (yieldTypes.contains(yieldType)) return yieldType;
    
    // Case-insensitive partial match
    final lowerYieldType = yieldType.toLowerCase();
    for (var type in yieldTypes) {
      if (type.toLowerCase().contains(lowerYieldType) ||
          lowerYieldType.contains(type.toLowerCase())) {
        return type;
      }
    }
    
    return yieldTypes[0]; // Default to first option if no match
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: _primaryColor, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    bool isDisabled = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDisabled ? Colors.grey[200] : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: isDisabled ? Colors.grey : _primaryColor,
              ),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDisabled ? Colors.grey[600] : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: isDisabled ? null : onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime? date,
    String dateType, {
    bool isDisabled = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: isDisabled ? null : () => _selectDate(context, dateType),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: isDisabled ? Colors.grey[200] : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date == null
                        ? 'dd/mm/yyyy'
                        : DateFormat('dd/MM/yyyy').format(date),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: date == null
                          ? Colors.grey[400]
                          : (isDisabled ? Colors.grey[600] : Colors.black87),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: isDisabled ? Colors.grey : _primaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isNumber = false,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            hintText: '0.00',
            hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
            prefixIcon: icon != null
                ? Icon(icon, size: 18, color: Colors.grey[500])
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(AppLocalizations l10n) {
    bool isProfit = netProfit >= 0;
    Color resultColor = isProfit ? const Color(0xFF4CAF50) : const Color(0xFFE53935);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isProfit
              ? [const Color(0xFF4CAF50), const Color(0xFF2E7D32)]
              : [const Color(0xFFEF5350), const Color(0xFFC62828)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: resultColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            l10n.profitResult,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isProfit ? l10n.netProfit : l10n.netLoss,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '₹${netProfit.abs().toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${l10n.totalRevenue}: ₹${totalRevenue.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}