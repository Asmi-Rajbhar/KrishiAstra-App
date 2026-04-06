import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'l10n/app_localizations.dart';
import 'services/auth_service.dart';

class VerifyPage extends StatefulWidget {
  final String fullName;
  final String phoneNo;
  final String email;
  final String password;

  const VerifyPage({
    super.key,
    required this.fullName,
    required this.phoneNo,
    required this.email,
    required this.password,
  });

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  static const String baseUrl = 'http://110.225.251.16:4445';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _digipinController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _landController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _agristackController = TextEditingController();

  // Validation states for real-time feedback
  String? _aadhaarError;
  String? _panError;
  String? _agristackError;
  String? _pinError;
  String? _digipinError;

  bool _aadhaarValid = false;
  bool _panValid = false;
  bool _agristackValid = false;
  bool _pinValid = false;
  bool _digipinValid = false;

  final List<Map<String, dynamic>> _bankAccounts = [
    {
      "account": TextEditingController(),
      "ifsc": TextEditingController(),
      "passbook": null,
      "ifscError": null,
      "ifscValid": false,
    },
  ];

  bool _termsAccepted = false;
  List<PlatformFile> _kycFiles = [];
  bool _isExistingUser = false;
  final ImagePicker _imagePicker = ImagePicker();

  // Location data - ALL loaded at once
  List<Map<String, dynamic>> _allCountries = [];
  List<Map<String, dynamic>> _allStates = [];
  List<Map<String, dynamic>> _allDistricts = [];
  List<Map<String, dynamic>> _allTehsils = [];
  List<Map<String, dynamic>> _allVillages = [];

  // Filtered lists for dropdowns
  List<Map<String, dynamic>> _filteredStates = [];
  List<Map<String, dynamic>> _filteredDistricts = [];
  List<Map<String, dynamic>> _filteredTehsils = [];
  List<Map<String, dynamic>> _filteredVillages = [];

  bool _isLoadingLocations = false;
  bool _locationsLoaded = false;

  // Dropdown values
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedTehsil;
  String? _selectedVillage;

  // Static cache for location data
  static List<Map<String, dynamic>>? _cachedCountries;
  static List<Map<String, dynamic>>? _cachedStates;
  static List<Map<String, dynamic>>? _cachedDistricts;
  static List<Map<String, dynamic>>? _cachedTehsils;
  static List<Map<String, dynamic>>? _cachedVillages;

  @override
  void initState() {
    super.initState();
    _isExistingUser = widget.password.isEmpty;
    _loadAllLocations();
    if (_isExistingUser) {
      _loadExistingUserData();
    }

    // Add listeners for real-time validation
    _aadhaarController.addListener(_validateAadhaar);
    _panController.addListener(_validatePan);
    _agristackController.addListener(_validateAgristack);
    _pinController.addListener(_validatePin);
    _digipinController.addListener(_validateDigipin);
  }

  // ============================================
  // REAL-TIME VALIDATION METHODS
  // ============================================

  void _validateAadhaar() {
    setState(() {
      String value = _aadhaarController.text.trim();

      if (value.isEmpty) {
        _aadhaarError = null;
        _aadhaarValid = false;
      } else if (value.length != 12) {
        _aadhaarError = "Aadhaar must be exactly 12 digits";
        _aadhaarValid = false;
      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        _aadhaarError = "Aadhaar must contain only digits";
        _aadhaarValid = false;
      } else {
        _aadhaarError = null;
        _aadhaarValid = true;
      }
    });
  }

  void _validatePan() {
    setState(() {
      String value = _panController.text.trim().toUpperCase();

      if (value.isEmpty) {
        _panError = null;
        _panValid = false;
      } else if (value.length != 10) {
        _panError = "PAN must be exactly 10 characters";
        _panValid = false;
      } else if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(value)) {
        _panError = "Invalid PAN format (e.g., ABCDE1234F)";
        _panValid = false;
      } else {
        _panError = null;
        _panValid = true;
      }
    });
  }

  void _validateAgristack() {
    setState(() {
      String value = _agristackController.text.trim();

      if (value.isEmpty) {
        _agristackError = null;
        _agristackValid = false;
      } else if (value.length != 12) {
        _agristackError = "AgriStack ID must be exactly 12 characters";
        _agristackValid = false;
      } else {
        _agristackError = null;
        _agristackValid = true;
      }
    });
  }

  void _validatePin() {
    setState(() {
      String value = _pinController.text.trim();

      if (value.isEmpty) {
        _pinError = null;
        _pinValid = false;
      } else if (value.length != 6) {
        _pinError = "Pincode must be exactly 6 digits";
        _pinValid = false;
      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        _pinError = "Pincode must contain only digits";
        _pinValid = false;
      } else {
        _pinError = null;
        _pinValid = true;
      }
    });
  }

  void _validateDigipin() {
    setState(() {
      String value = _digipinController.text.trim();

      if (value.isEmpty) {
        _digipinError = null;
        _digipinValid = false;
      } else if (value.length > 10) {
        _digipinError = "DigiPin cannot exceed 10 characters";
        _digipinValid = false;
      } else {
        _digipinError = null;
        _digipinValid = true;
      }
    });
  }

  void _validateIfsc(int index) {
    setState(() {
      String value = _bankAccounts[index]["ifsc"]!.text.trim().toUpperCase();

      if (value.isEmpty) {
        _bankAccounts[index]["ifscError"] = null;
        _bankAccounts[index]["ifscValid"] = false;
      } else if (value.length != 11) {
        _bankAccounts[index]["ifscError"] = "IFSC must be exactly 11 characters";
        _bankAccounts[index]["ifscValid"] = false;
      } else {
        _bankAccounts[index]["ifscError"] = null;
        _bankAccounts[index]["ifscValid"] = true;
      }
    });
  }

  // ============================================
  // SINGLE API CALL - Load all location data
  // ============================================
  Future<void> _loadAllLocations() async {
    // Use cache if available
    if (_cachedCountries != null) {
      setState(() {
        _allCountries = _cachedCountries!;
        _allStates = _cachedStates!;
        _allDistricts = _cachedDistricts!;
        _allTehsils = _cachedTehsils!;
        _allVillages = _cachedVillages!;
        _locationsLoaded = true;
      });

      if (_selectedCountry == null && !_isExistingUser) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _setDefaultCountry();
        });
      }
      return;
    }

    setState(() => _isLoadingLocations = true);

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/method/krishiastra_app.api.location_api.get_all_locations'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['message']['success']) {
          _cachedCountries = List<Map<String, dynamic>>.from(data['message']['data']['countries']);
          _cachedStates = List<Map<String, dynamic>>.from(data['message']['data']['states']);
          _cachedDistricts = List<Map<String, dynamic>>.from(data['message']['data']['districts']);
          _cachedTehsils = List<Map<String, dynamic>>.from(data['message']['data']['tehsils']);
          _cachedVillages = List<Map<String, dynamic>>.from(data['message']['data']['villages']);

          setState(() {
            _allCountries = _cachedCountries!;
            _allStates = _cachedStates!;
            _allDistricts = _cachedDistricts!;
            _allTehsils = _cachedTehsils!;
            _allVillages = _cachedVillages!;
            _locationsLoaded = true;
          });

          if (_selectedCountry == null && !_isExistingUser) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _setDefaultCountry();
            });
          }
        }
      }
    } catch (e) {
      print('Error loading locations: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load location data. Please check your connection.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoadingLocations = false);
    }
  }

  // ============================================
  // SET DEFAULT COUNTRY TO INDIA
  // ============================================
  void _setDefaultCountry() {
    if (!mounted) return;

    final indiaCountry = _allCountries.firstWhere(
      (country) => (country['name'] as String).toLowerCase() == 'india',
      orElse: () => <String, dynamic>{},
    );

    if (indiaCountry.isNotEmpty) {
      setState(() {
        _selectedCountry = indiaCountry['name'];
        _filterStates(indiaCountry['name']);
      });
    }
  }

  // ============================================
  // CLIENT-SIDE FILTERING (instant, no API calls)
  // ============================================
  void _filterStates(String country) {
    setState(() {
      _filteredStates = _allStates.where((state) => state['country'] == country).toList();
      _filteredDistricts = [];
      _filteredTehsils = [];
      _filteredVillages = [];
      _selectedState = null;
      _selectedDistrict = null;
      _selectedTehsil = null;
      _selectedVillage = null;
    });
  }

  void _filterDistricts(String state) {
    setState(() {
      _filteredDistricts = _allDistricts.where((district) => district['state'] == state).toList();
      _filteredTehsils = [];
      _filteredVillages = [];
      _selectedDistrict = null;
      _selectedTehsil = null;
      _selectedVillage = null;
    });
  }

  void _filterTehsils(String district) {
    setState(() {
      _filteredTehsils = _allTehsils.where((tehsil) => tehsil['district'] == district).toList();
      _filteredVillages = [];
      _selectedTehsil = null;
      _selectedVillage = null;
    });
  }

  void _filterVillages(String tehsil) {
    setState(() {
      _filteredVillages = _allVillages.where((village) => village['tehsil'] == tehsil).toList();
      _selectedVillage = null;
    });
  }

  Future<void> _loadExistingUserData() async {
    final auth = AuthService();
    final userDetails = await auth.getCurrentUserDetails();

    if (userDetails != null && mounted) {
      setState(() {
        _usernameController.text = userDetails['username'] ?? '';
        _addressController.text = userDetails['address'] ?? '';
        _pinController.text = userDetails['pincode'] ?? '';
        _digipinController.text = userDetails['digipin'] ?? '';
        _educationController.text = userDetails['education'] ?? '';
        _landController.text = userDetails['total_land_cultivated'] ?? '';
        _incomeController.text = userDetails['annual_income'] ?? '';
        _aadhaarController.text = userDetails['aadhaar_no'] ?? '';
        _panController.text = userDetails['pancard_no'] ?? '';
        _agristackController.text = userDetails['agristack_id'] ?? '';

        _selectedCountry = userDetails['country'];
        _selectedState = userDetails['state'];
        _selectedDistrict = userDetails['district'];
        _selectedTehsil = userDetails['tehsil'];
        _selectedVillage = userDetails['village'];

        if (_selectedCountry != null) _filterStates(_selectedCountry!);
        if (_selectedState != null) _filterDistricts(_selectedState!);
        if (_selectedDistrict != null) _filterTehsils(_selectedDistrict!);
        if (_selectedTehsil != null) _filterVillages(_selectedTehsil!);

        if (userDetails['account_number'] != null && userDetails['account_number'].toString().isNotEmpty) {
          _bankAccounts[0]["account"]!.text = userDetails['account_number'].toString();
        }
        if (userDetails['ifsc_code'] != null && userDetails['ifsc_code'].toString().isNotEmpty) {
          _bankAccounts[0]["ifsc"]!.text = userDetails['ifsc_code'].toString();
        }
      });
    }
  }

  // ============================================
  // SEARCHABLE DROPDOWN BOTTOM SHEET
  // ============================================

  /// Opens a modal bottom sheet with a search bar + scrollable list.
  /// Returns the selected item's 'name' string or null if dismissed.
  Future<String?> _showSearchableDropdown({
    required String title,
    required List<Map<String, dynamic>> items,
    required String displayKey,
    String? currentValue,
  }) async {
    final TextEditingController searchController = TextEditingController();
    List<Map<String, dynamic>> filtered = List.from(items);

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void onSearch(String query) {
              setModalState(() {
                filtered = items.where((item) {
                  final display = (item[displayKey] ?? item['name'] ?? '').toString().toLowerCase();
                  return display.contains(query.toLowerCase());
                }).toList();
              });
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select $title',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1C6B3C),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextField(
                      controller: searchController,
                      autofocus: true,
                      onChanged: onSearch,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search $title...',
                        hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF1C6B3C), size: 20),
                        suffixIcon: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: searchController,
                          builder: (_, value, __) => value.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                                  onPressed: () {
                                    searchController.clear();
                                    onSearch('');
                                  },
                                )
                              : const SizedBox.shrink(),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF1C6B3C), width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Result count badge
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${filtered.length} result${filtered.length == 1 ? '' : 's'}',
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  // List
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search_off, size: 48, color: Colors.grey[300]),
                                const SizedBox(height: 12),
                                Text(
                                  'No results found',
                                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                Divider(height: 1, color: Colors.grey[100]),
                            itemBuilder: (_, index) {
                              final item = filtered[index];
                              final name = item['name'] as String;
                              final display = (item[displayKey] ?? name).toString();
                              final isSelected = name == currentValue;

                              return InkWell(
                                onTap: () => Navigator.pop(ctx, name),
                                child: Container(
                                  color: isSelected
                                      ? const Color(0xFF1C6B3C).withOpacity(0.08)
                                      : null,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 14),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          display,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                            color: isSelected
                                                ? const Color(0xFF1C6B3C)
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(Icons.check_circle,
                                            color: Color(0xFF1C6B3C), size: 20),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ============================================
  // IMAGE SOURCE DIALOG
  // ============================================

  Future<void> _showImageSourceDialog({bool isPassbook = false, int? accountIndex}) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Select Source',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C6B3C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.camera_alt, color: Color(0xFF1C6B3C)),
                ),
                title: Text('Camera', style: GoogleFonts.poppins(fontSize: 15)),
                onTap: () {
                  Navigator.pop(context);
                  if (isPassbook && accountIndex != null) {
                    _pickImageFromCamera(accountIndex: accountIndex);
                  } else {
                    _pickImageFromCamera();
                  }
                },
              ),
              const Divider(),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C6B3C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.photo_library, color: Color(0xFF1C6B3C)),
                ),
                title: Text('Gallery', style: GoogleFonts.poppins(fontSize: 15)),
                onTap: () {
                  Navigator.pop(context);
                  if (isPassbook && accountIndex != null) {
                    _pickFromGallery(accountIndex: accountIndex);
                  } else {
                    _pickFromGallery();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromCamera({int? accountIndex}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final file = PlatformFile(
          name: image.name,
          size: bytes.length,
          bytes: bytes,
          path: image.path,
        );

        if (accountIndex != null) {
          setState(() {
            _bankAccounts[accountIndex]["passbook"] = file;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Passbook captured successfully"),
                backgroundColor: Color(0xFF1C6B3C),
              ),
            );
          }
        } else {
          setState(() {
            _kycFiles.add(file);
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Document captured successfully"),
                backgroundColor: Color(0xFF1C6B3C),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error capturing image: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickFromGallery({int? accountIndex}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: accountIndex == null,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        withData: true,
      );

      if (result != null) {
        if (accountIndex != null) {
          setState(() {
            _bankAccounts[accountIndex]["passbook"] = result.files.first;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Passbook uploaded successfully"),
                backgroundColor: Color(0xFF1C6B3C),
              ),
            );
          }
        } else {
          setState(() {
            _kycFiles.addAll(result.files);
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${result.files.length} file(s) selected"),
                backgroundColor: const Color(0xFF1C6B3C),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error selecting file: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String?> _registerOrUpdateFarmer() async {
    List<Map<String, String>> kycDocuments = [];
    for (var file in _kycFiles) {
      if (file.bytes != null) {
        String base64File = base64Encode(file.bytes!);
        kycDocuments.add({
          "filename": file.name,
          "filedata": base64File,
        });
      }
    }

    List<Map<String, dynamic>> bankAccountsData = [];
    List<Map<String, String>> passbookDocuments = [];

    for (int i = 0; i < _bankAccounts.length; i++) {
      var account = _bankAccounts[i];
      String accountNumber = account["account"]!.text.trim();
      String ifscCode = account["ifsc"]!.text.trim();

      if (accountNumber.isEmpty && ifscCode.isEmpty) continue;

      Map<String, dynamic> bankData = {
        "account_number": accountNumber,
        "ifsc_code": ifscCode.toUpperCase(),
      };

      if (account["passbook"] != null) {
        PlatformFile file = account["passbook"];
        if (file.bytes != null) {
          String base64File = base64Encode(file.bytes!);
          passbookDocuments.add({
            "account_index": i.toString(),
            "filename": file.name,
            "filedata": base64File,
          });
        }
      }

      bankAccountsData.add(bankData);
    }

    final endpoint = _isExistingUser
        ? '$baseUrl/api/method/krishiastra_app.api.auth_api.update_farmer_verification'
        : '$baseUrl/api/method/krishiastra_app.api.profile_verify.complete_farmer_profile';

    final url = Uri.parse(endpoint);

    try {
      Map<String, String> body = {
        'username': _usernameController.text.trim(),
        'village': _selectedVillage ?? '',
        'tehsil': _selectedTehsil ?? '',
        'district': _selectedDistrict ?? '',
        'address': _addressController.text.trim(),
        'state': _selectedState ?? '',
        'country': _selectedCountry ?? '',
        'pincode': _pinController.text.trim(),
        'digipin': _digipinController.text.trim(),
        'education': _educationController.text.trim(),
        'total_land_cultivated': _landController.text.trim(),
        'annual_income': _incomeController.text.trim(),
        'pancard_no': _panController.text.trim().toUpperCase(),
        'aadhaar_no': _aadhaarController.text.trim(),
        'agristack_id': _agristackController.text.trim(),
        'bank_accounts': jsonEncode(bankAccountsData),
        'kyc_documents': jsonEncode(kycDocuments),
        'passbook_documents': jsonEncode(passbookDocuments),
      };

      Map<String, String> headers;

      if (_isExistingUser) {
        final auth = AuthService();
        headers = await auth.getAuthHeaders();
      } else {
        body['full_name'] = widget.fullName;
        body['email'] = widget.email;
        body['password'] = widget.password;
        body['phone_no'] = widget.phoneNo;
        headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      }

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final msg = data['message'];

        if (msg is Map && msg['status'] == 'ok') {
          return null;
        } else if (msg is String) {
          return msg;
        } else if (msg is Map && msg['message'] != null) {
          return msg['message'].toString();
        } else {
          return "Unknown server response";
        }
      } else {
        try {
          final data = jsonDecode(response.body);
          if (data is Map && data['_server_messages'] != null) {
            final serverMessagesJson = data['_server_messages'];
            final List decodedList = jsonDecode(serverMessagesJson);
            if (decodedList.isNotEmpty) {
              final firstMsg = jsonDecode(decodedList[0]);
              if (firstMsg['message'] != null) {
                return firstMsg['message'].toString();
              }
            }
          }
        } catch (_) {}
        return "Server error: ${response.statusCode}";
      }
    } catch (e) {
      return "Network error: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0F4C2A),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0F4C2A), Color(0xFF1C6B3C)],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset("assets/images/logo.png", height: 60),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF1C6B3C), Color(0xFF2A8F52)],
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _isExistingUser
                                    ? "Complete Your Verification"
                                    : "Complete Your Profile",
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _isExistingUser
                                    ? "Submit your details for verification"
                                    : "Step 2 of 2 - Additional Details",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sectionTitle("Account Details", Icons.account_circle_outlined),
                              buildField(l10n.username, _usernameController,
                                  Icons.account_circle_outlined, l10n),
                              const SizedBox(height: 12),
                              sectionTitle(l10n.locationDetails, Icons.location_on_outlined),

                              if (_isLoadingLocations)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        const CircularProgressIndicator(color: Color(0xFF1C6B3C)),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Loading location data...',
                                          style: GoogleFonts.poppins(
                                              fontSize: 14, color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else ...[
                                buildSearchableDropdownField(
                                  label: l10n.country,
                                  value: _selectedCountry,
                                  items: _allCountries,
                                  onChanged: (value) {
                                    setState(() => _selectedCountry = value);
                                    if (value != null) _filterStates(value);
                                  },
                                  icon: Icons.flag_outlined,
                                  isRequired: true,
                                  displayKey: 'country_name',
                                  isDisabled: false,
                                ),

                                buildSearchableDropdownField(
                                  label: l10n.state,
                                  value: _selectedState,
                                  items: _filteredStates,
                                  onChanged: _selectedCountry == null
                                      ? null
                                      : (value) {
                                          setState(() => _selectedState = value);
                                          if (value != null) _filterDistricts(value);
                                        },
                                  icon: Icons.public_outlined,
                                  isRequired: true,
                                  displayKey: 'state_name',
                                  isDisabled: _selectedCountry == null,
                                ),

                                buildSearchableDropdownField(
                                  label: l10n.district,
                                  value: _selectedDistrict,
                                  items: _filteredDistricts,
                                  onChanged: _selectedState == null
                                      ? null
                                      : (value) {
                                          setState(() => _selectedDistrict = value);
                                          if (value != null) _filterTehsils(value);
                                        },
                                  icon: Icons.map_outlined,
                                  isRequired: true,
                                  displayKey: 'district_name',
                                  isDisabled: _selectedState == null,
                                ),

                                buildSearchableDropdownField(
                                  label: l10n.tehsil,
                                  value: _selectedTehsil,
                                  items: _filteredTehsils,
                                  onChanged: _selectedDistrict == null
                                      ? null
                                      : (value) {
                                          setState(() => _selectedTehsil = value);
                                          if (value != null) _filterVillages(value);
                                        },
                                  icon: Icons.location_city_outlined,
                                  isRequired: true,
                                  displayKey: 'tehsil_name',
                                  isDisabled: _selectedDistrict == null,
                                ),

                                buildSearchableDropdownField(
                                  label: l10n.village,
                                  value: _selectedVillage,
                                  items: _filteredVillages,
                                  onChanged: _selectedTehsil == null
                                      ? null
                                      : (value) {
                                          setState(() => _selectedVillage = value);
                                        },
                                  icon: Icons.home_outlined,
                                  isRequired: true,
                                  displayKey: 'village_name',
                                  isDisabled: _selectedTehsil == null,
                                ),
                              ],

                              buildField(
                                  l10n.address, _addressController, Icons.place_outlined, l10n),
                              Row(
                                children: [
                                  Expanded(
                                    child: buildValidatedField(
                                      label: l10n.pin,
                                      controller: _pinController,
                                      icon: Icons.pin_outlined,
                                      l10n: l10n,
                                      keyboardType: TextInputType.number,
                                      maxLength: 6,
                                      error: _pinError,
                                      isValid: _pinValid,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: buildValidatedField(
                                      label: l10n.digiPin,
                                      controller: _digipinController,
                                      icon: Icons.qr_code_outlined,
                                      l10n: l10n,
                                      maxLength: 10,
                                      isRequired: false,
                                      error: _digipinError,
                                      isValid: _digipinValid,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              sectionTitle(l10n.additionalInfo, Icons.info_outline),
                              buildField(l10n.education, _educationController,
                                  Icons.school_outlined, l10n),
                              buildField(l10n.landCultivated, _landController,
                                  Icons.landscape_outlined, l10n,
                                  keyboardType: TextInputType.number),
                              buildField(l10n.avgIncome, _incomeController,
                                  Icons.attach_money_outlined, l10n,
                                  keyboardType: TextInputType.number),
                              const SizedBox(height: 12),
                              sectionTitle(l10n.kycDocs, Icons.verified_user_outlined),

                              buildValidatedField(
                                label: l10n.aadhaarNum,
                                controller: _aadhaarController,
                                icon: Icons.credit_card_outlined,
                                l10n: l10n,
                                keyboardType: TextInputType.number,
                                maxLength: 12,
                                error: _aadhaarError,
                                isValid: _aadhaarValid,
                              ),

                              buildValidatedField(
                                label: l10n.panNum,
                                controller: _panController,
                                icon: Icons.card_membership_outlined,
                                l10n: l10n,
                                maxLength: 10,
                                isRequired: false,
                                error: _panError,
                                isValid: _panValid,
                              ),

                              buildValidatedField(
                                label: "AgriStack ID",
                                controller: _agristackController,
                                icon: Icons.apps_outlined,
                                l10n: l10n,
                                maxLength: 12,
                                isRequired: false,
                                error: _agristackError,
                                isValid: _agristackValid,
                              ),

                              uploadButton(l10n),
                              if (_kycFiles.isNotEmpty) kycPreview(l10n),
                              const SizedBox(height: 12),
                              sectionTitle(l10n.bankingInfo, Icons.account_balance_outlined),
                              ..._bankAccounts.asMap().entries.map((entry) {
                                int idx = entry.key;
                                var account = entry.value;
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey[200]!),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${l10n.bankAccount} ${idx + 1}",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF1C6B3C)),
                                          ),
                                          if (idx > 0)
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline,
                                                  color: Colors.red, size: 20),
                                              onPressed: () =>
                                                  setState(() => _bankAccounts.removeAt(idx)),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      buildField(l10n.accountNum, account["account"]!,
                                          Icons.account_balance_wallet_outlined, l10n,
                                          keyboardType: TextInputType.number),
                                      buildBankIfscField(l10n, idx),
                                      const SizedBox(height: 12),
                                      passbookUploadButton(l10n, idx),
                                      if (account["passbook"] != null)
                                        passbookPreview(account["passbook"], idx),
                                    ],
                                  ),
                                );
                              }).toList(),
                              addBankButton(l10n),
                              const SizedBox(height: 24),
                              InkWell(
                                onTap: () => setState(() => _termsAccepted = !_termsAccepted),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: _termsAccepted
                                            ? const Color(0xFF1C6B3C)
                                            : Colors.grey[300]!),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: _termsAccepted
                                              ? const Color(0xFF1C6B3C)
                                              : Colors.transparent,
                                          border: Border.all(
                                              color: _termsAccepted
                                                  ? const Color(0xFF1C6B3C)
                                                  : Colors.grey[400]!,
                                              width: 2),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: _termsAccepted
                                            ? const Icon(Icons.check,
                                                color: Colors.white, size: 16)
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                          child: Text(l10n.termsAgree,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13, color: Colors.grey[800]))),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: [Color(0xFF1C6B3C), Color(0xFF2A8F52)]),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xFF1C6B3C).withOpacity(0.4),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6))
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) return;
                                    if (!_termsAccepted) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(l10n.termsError),
                                          backgroundColor: Colors.red));
                                      return;
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(_isExistingUser
                                            ? "Submitting verification..."
                                            : l10n.registeringMsg),
                                        backgroundColor: const Color(0xFF1C6B3C),
                                        duration: const Duration(seconds: 2)));
                                    final error = await _registerOrUpdateFarmer();
                                    if (!mounted) return;
                                    if (error == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(_isExistingUser
                                              ? "Verification submitted successfully"
                                              : "Registration successful"),
                                          backgroundColor: Colors.green,
                                          duration: const Duration(seconds: 2)));
                                      await Future.delayed(const Duration(seconds: 2));
                                      if (!mounted) return;
                                      if (_isExistingUser) {
                                        Navigator.of(context).pop();
                                      } else {
                                        Navigator.of(context).popUntil((route) => route.isFirst);
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(error), backgroundColor: Colors.red));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12))),
                                  child: Text(
                                      _isExistingUser ? "Submit Verification" : l10n.registerBtn,
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          letterSpacing: 0.5)),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================
  // WIDGET BUILDERS
  // ============================================

  Widget sectionTitle(String title, IconData icon) => Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 4),
        child: Row(
          children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xFF1C6B3C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: const Color(0xFF1C6B3C), size: 20)),
            const SizedBox(width: 12),
            Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1C6B3C))),
          ],
        ),
      );

  // ============================================
  // SEARCHABLE DROPDOWN FIELD (replaces buildDropdown)
  // ============================================
  /// Renders a tappable field that opens the searchable bottom sheet.
  /// Includes form validation support.
  Widget buildSearchableDropdownField({
    required String label,
    required String? value,
    required List<Map<String, dynamic>> items,
    required Function(String?)? onChanged,
    required IconData icon,
    bool isRequired = true,
    String displayKey = 'name',
    bool isDisabled = false,
  }) {
    // Resolve display label for the current value
    String? displayValue;
    if (value != null) {
      final match = items.cast<Map<String, dynamic>?>().firstWhere(
            (item) => item!['name'] == value,
            orElse: () => null,
          );
      displayValue = match != null ? (match[displayKey] ?? match['name']).toString() : value;
    }

    // Hint text when parent not selected yet
    String hintText = isDisabled
        ? 'Select ${label.toLowerCase().contains('state') ? 'country' : label.toLowerCase().contains('district') ? 'state' : label.toLowerCase().contains('tehsil') ? 'district' : label.toLowerCase().contains('village') ? 'tehsil' : 'parent'} first'
        : 'Select $label';

    final borderColor = isDisabled ? Colors.grey[300]! : Colors.grey[200]!;
    final iconColor = isDisabled ? Colors.grey[400]! : const Color(0xFF1C6B3C);
    final fillColor = isDisabled ? Colors.grey[100]! : Colors.grey[50]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FormField<String>(
        initialValue: value,
        validator: isRequired && !isDisabled
            ? (v) => (v == null || v.isEmpty) ? 'Please select $label' : null
            : null,
        builder: (FormFieldState<String> fieldState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tappable field
              GestureDetector(
                onTap: isDisabled || onChanged == null
                    ? null
                    : () async {
                        final selected = await _showSearchableDropdown(
                          title: label,
                          items: items,
                          displayKey: displayKey,
                          currentValue: value,
                        );
                        if (selected != null) {
                          fieldState.didChange(selected);
                          onChanged(selected);
                        }
                      },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: fieldState.hasError
                          ? Colors.red
                          : (value != null ? const Color(0xFF1C6B3C).withOpacity(0.4) : borderColor),
                      width: fieldState.hasError ? 1.5 : 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, color: iconColor, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          displayValue ?? hintText,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: displayValue != null ? Colors.black87 : Colors.grey[500],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Search icon to indicate searchable
                      if (!isDisabled) ...[
                        if (value != null)
                          GestureDetector(
                            onTap: () {
                              fieldState.didChange(null);
                              onChanged!(null);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(Icons.close, color: Colors.grey[400], size: 18),
                            ),
                          ),
                        Icon(
                          Icons.search,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                      ] else
                        Icon(Icons.lock_outline, color: Colors.grey[400], size: 18),
                    ],
                  ),
                ),
              ),
              // Label overlay — floating label effect via positioned text above
              if (displayValue != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF1C6B3C)),
                  ),
                ),
              // Error text
              if (fieldState.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    fieldState.errorText!,
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.red[700]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget buildValidatedField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required AppLocalizations l10n,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    bool isRequired = true,
    String? error,
    bool isValid = false,
  }) {
    Color getBorderColor() {
      if (controller.text.isEmpty) return Colors.grey[200]!;
      if (error != null) return Colors.red;
      if (isValid) return Colors.green;
      return Colors.grey[200]!;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          prefixIcon: Icon(icon, color: const Color(0xFF1C6B3C), size: 20),
          suffixIcon: controller.text.isNotEmpty
              ? Icon(
                  isValid ? Icons.check_circle : (error != null ? Icons.error : null),
                  color: isValid ? Colors.green : Colors.red,
                  size: 20,
                )
              : null,
          filled: true,
          fillColor: Colors.grey[50],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: getBorderColor(), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: error != null ? Colors.red : (isValid ? Colors.green : const Color(0xFF1C6B3C)),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          counterText: maxLength != null ? '' : null,
          helperText: error ?? (isValid && controller.text.isNotEmpty ? '✓ Valid' : null),
          helperStyle: GoogleFonts.poppins(
            fontSize: 12,
            color: error != null ? Colors.red : Colors.green,
          ),
        ),
        validator: isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  return "${l10n.pleaseEnter} $label";
                }
                return error;
              }
            : (value) => error,
      ),
    );
  }

  Widget buildBankIfscField(AppLocalizations l10n, int index) {
    var account = _bankAccounts[index];
    String? error = account["ifscError"];
    bool isValid = account["ifscValid"] ?? false;

    if (!account.containsKey("listenerAdded")) {
      account["ifsc"]!.addListener(() => _validateIfsc(index));
      account["listenerAdded"] = true;
    }

    Color getBorderColor() {
      if (account["ifsc"]!.text.isEmpty) return Colors.grey[200]!;
      if (error != null) return Colors.red;
      if (isValid) return Colors.green;
      return Colors.grey[200]!;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: account["ifsc"]!,
        maxLength: 11,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          labelText: l10n.ifscCode,
          labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          prefixIcon:
              const Icon(Icons.code_outlined, color: Color(0xFF1C6B3C), size: 20),
          suffixIcon: account["ifsc"]!.text.isNotEmpty
              ? Icon(
                  isValid ? Icons.check_circle : (error != null ? Icons.error : null),
                  color: isValid ? Colors.green : Colors.red,
                  size: 20,
                )
              : null,
          filled: true,
          fillColor: Colors.grey[50],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: getBorderColor(), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: error != null
                  ? Colors.red
                  : (isValid ? Colors.green : const Color(0xFF1C6B3C)),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          counterText: '',
          helperText:
              error ?? (isValid && account["ifsc"]!.text.isNotEmpty ? '✓ Valid' : null),
          helperStyle: GoogleFonts.poppins(
            fontSize: 12,
            color: error != null ? Colors.red : Colors.green,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "${l10n.pleaseEnter} ${l10n.ifscCode}";
          }
          return error;
        },
      ),
    );
  }

  Widget buildField(
    String label,
    TextEditingController controller,
    IconData icon,
    AppLocalizations l10n, {
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    bool isRequired = true,
    String? Function(String?)? validator,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            prefixIcon: Icon(icon, color: const Color(0xFF1C6B3C), size: 20),
            filled: true,
            fillColor: Colors.grey[50],
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF1C6B3C), width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.5)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            counterText: maxLength != null ? '' : null,
          ),
          validator: validator ??
              (isRequired
                  ? (value) => value!.isEmpty ? "${l10n.pleaseEnter} $label" : null
                  : null),
        ),
      );

  Widget uploadButton(AppLocalizations l10n) => Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: OutlinedButton.icon(
          onPressed: () => _showImageSourceDialog(),
          icon: const Icon(Icons.upload_file_outlined, size: 20),
          label: Text(l10n.uploadKyc,
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
          style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1C6B3C),
              side: const BorderSide(color: Color(0xFF1C6B3C), width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
      );

  Widget passbookUploadButton(AppLocalizations l10n, int index) => Container(
        width: double.infinity,
        height: 48,
        child: OutlinedButton.icon(
          onPressed: () => _showImageSourceDialog(isPassbook: true, accountIndex: index),
          icon: const Icon(Icons.upload_outlined, size: 18),
          label: Text("Upload Passbook",
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue,
            side: const BorderSide(color: Colors.blue, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );

  Widget passbookPreview(PlatformFile file, int index) => Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: ListTile(
          dense: true,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: file.extension?.toLowerCase() == 'pdf'
                ? const Icon(Icons.picture_as_pdf, color: Colors.red, size: 24)
                : file.bytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.memory(file.bytes as Uint8List, fit: BoxFit.cover))
                    : const Icon(Icons.image, color: Colors.grey, size: 24),
          ),
          title: Text(file.name,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
          subtitle: Text("${(file.size / 1024).toStringAsFixed(2)} KB",
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
          trailing: IconButton(
            icon: const Icon(Icons.close, color: Colors.red, size: 18),
            onPressed: () => setState(() => _bankAccounts[index]["passbook"] = null),
          ),
        ),
      );

  Widget kycPreview(AppLocalizations l10n) => Container(
        margin: const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _kycFiles.map((file) {
            bool isImage = file.extension?.toLowerCase() == 'jpg' ||
                file.extension?.toLowerCase() == 'jpeg' ||
                file.extension?.toLowerCase() == 'png';
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!)),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration:
                      BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                  child: isImage && file.bytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(file.bytes as Uint8List, fit: BoxFit.cover))
                      : const Icon(Icons.picture_as_pdf, color: Colors.red, size: 28),
                ),
                title: Text(file.name,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                subtitle: Text("${(file.size / 1024).toStringAsFixed(2)} KB",
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                    onPressed: () => setState(() => _kycFiles.remove(file))),
              ),
            );
          }).toList(),
        ),
      );

  Widget addBankButton(AppLocalizations l10n) => SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton.icon(
          onPressed: () => setState(() => _bankAccounts.add({
                "account": TextEditingController(),
                "ifsc": TextEditingController(),
                "passbook": null,
                "ifscError": null,
                "ifscValid": false,
              })),
          icon: const Icon(Icons.add_circle_outline, size: 20),
          label: Text(l10n.addBankAccount,
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
          style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange,
              side: const BorderSide(color: Colors.orange, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
      );

  @override
  void dispose() {
    _usernameController.dispose();
    _addressController.dispose();
    _pinController.dispose();
    _digipinController.dispose();
    _educationController.dispose();
    _landController.dispose();
    _incomeController.dispose();
    _aadhaarController.dispose();
    _panController.dispose();
    _agristackController.dispose();
    for (final bank in _bankAccounts) {
      bank["account"]!.dispose();
      bank["ifsc"]!.dispose();
    }
    super.dispose();
  }
}