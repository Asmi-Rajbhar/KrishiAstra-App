// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

// Helper function to calculate harvest date
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
      final harvestDate = sowing.add(const Duration(days: 120));
      return '${harvestDate.year}-${harvestDate.month.toString().padLeft(2, '0')}-${harvestDate.day.toString().padLeft(2, '0')}';
    }

    final duration = cropHarvestDuration[matchedCrop]!;
    final avgDays = ((duration['min']! + duration['max']!) / 2).round();

    final harvestDate = sowing.add(Duration(days: avgDays));
    return '${harvestDate.year}-${harvestDate.month.toString().padLeft(2, '0')}-${harvestDate.day.toString().padLeft(2, '0')}';
  } catch (e) {
    print('Error calculating harvest date: $e');
    return '';
  }
}

class AuthService {
  static const String baseUrl = 'http://110.225.251.16:4445';
  // local - http://127.0.0.1:8000
  // http://110.225.251.16:4445
  final _storage = const FlutterSecureStorage();

  String? _parseCookieValue(String? cookieHeader, String name) {
    if (cookieHeader == null) return null;
    final match = RegExp(r'(?:(?:^|; )' + RegExp.escape(name) + r'=)([^;]+)')
        .firstMatch(cookieHeader);
    return match?.group(1);
  }

  /// Update stored full name in secure storage
  Future<void> updateStoredFullName(String fullName) async {
    await _storage.write(key: 'full_name', value: fullName);
  }

  Future<String?> login(String phoneNo, String pwd) async {
    try {
      final userDetails = await _getFarmerDetailsByPhone(phoneNo);
      if (userDetails == null) {
        return 'Phone number not registered';
      }

      final email = userDetails['email'];
      if (email == null || email.isEmpty) {
        return 'No email associated with this phone number';
      }

      final loginUrl = Uri.parse('$baseUrl/api/method/login');
      final loginResp = await http.post(
        loginUrl,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'usr': email, 'pwd': pwd},
      );

      if (loginResp.statusCode != 200) {
        try {
          final body = jsonDecode(loginResp.body);
          if (body is Map && body['message'] != null) {
            return body['message'].toString();
          }
        } catch (_) {}
        return 'Invalid phone number or password';
      }

      final setCookie = loginResp.headers['set-cookie'];
      final sid = _parseCookieValue(setCookie, 'sid');
      if (sid == null) {
        return 'Failed to establish session';
      }

      await _storage.write(key: 'sid', value: sid);
      await _storage.write(key: 'full_name', value: userDetails['full_name'] ?? '');

      return null;
    } catch (e) {
      print('Login error: $e');
      return 'Network error: $e';
    }
  }

  /// Fetch farmer details by phone number (for login)
  Future<Map<String, dynamic>?> _getFarmerDetailsByPhone(String phoneNo) async {
    final uri = Uri.parse(
        '$baseUrl/api/method/krishiastra_app.api.auth_api.get_farmer_by_phone');

    try {
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'phone_no': phoneNo},
      );

      if (resp.statusCode == 200) {
        final js = jsonDecode(resp.body);
        final msg = js['message'];

        if (msg is Map && msg['success'] == true) {
          final data = msg['data'];
          return {
            'full_name': data['full_name']?.toString() ?? '',
            'email': data['email']?.toString() ?? '',
            'verify_status': data['verify_status']?.toString() ?? 'Unverified',
          };
        }
      }
    } catch (e) {
      print('Error fetching farmer details: $e');
    }
    return null;
  }

  /// Get auth headers with session cookie
  Future<Map<String, String>> getAuthHeaders(
      {String contentType = 'application/x-www-form-urlencoded'}) async {
    final sid = await _storage.read(key: 'sid');
    final headers = <String, String>{'Content-Type': contentType};
    if (sid != null) {
      headers['Cookie'] = 'sid=$sid';
    }
    return headers;
  }

  /// Get current logged-in user details from Frappe using sid
  Future<Map<String, dynamic>?> getCurrentUserDetails() async {
    final uri = Uri.parse(
        '$baseUrl/api/method/krishiastra_app.api.auth_api.get_current_user_details');
    final headers = await getAuthHeaders();

    try {
      final resp = await http.get(uri, headers: headers);

      if (resp.statusCode == 200) {
        final js = jsonDecode(resp.body);
        final msg = js['message'];

        if (msg is Map && msg['success'] == true) {
          return msg['data'];
        }
      }
    } catch (e) {
      print('Error fetching current user details: $e');
    }
    return null;
  }

  /// Get stored full name (for initial display)
  Future<String?> getStoredFullName() async {
    return _storage.read(key: 'full_name');
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final sid = await _storage.read(key: 'sid');
    if (sid == null) return false;

    final userDetails = await getCurrentUserDetails();
    return userDetails != null;
  }

  /// Logout
  Future<void> logout() async {
    final uri = Uri.parse('$baseUrl/api/method/logout');
    final headers = await getAuthHeaders();

    try {
      await http.post(uri, headers: headers);
    } catch (e) {
      print('Logout request failed: $e');
    }

    await clearAllStorage();
  }

  // ---------------------------------------------------------------------------
  // PLOT METHODS
  // ---------------------------------------------------------------------------

  /// Create a new plot
  Future<dynamic> createPlot({
    required String plotName,
    required String latitude,
    required String longitude,
    required double totalAcres,
    required String cropName,
    required String cropVariety,
    required String sowingDate,
    required String typeOfIrrigation,
    required String typeOfFarming,
    required String soilType,
  }) async {
    final uri = Uri.parse(
        '$baseUrl/api/method/krishiastra_app.api.plot_api.create_plot');
    final headers =
        await getAuthHeaders(contentType: 'application/x-www-form-urlencoded');

    final harvestDate = calculateHarvestDate(sowingDate, cropName);

    final body = {
      'plot_name': plotName,
      'latitude': latitude,
      'longitude': longitude,
      'total_acres': totalAcres.toString(),
      'crop_name': cropName,
      'crop_variety': cropVariety,
      'sowing_date': sowingDate,
      'harvest_date': harvestDate,
      'type_of_irrigation': typeOfIrrigation,
      'type_of_farming': typeOfFarming,
      'soil_type': soilType,
    };

    print('=== Create Plot Request ===');
    print('URL: $uri');
    print('Body: $body');
    print('========================');

    try {
      final resp = await http.post(uri, headers: headers, body: body);

      print('=== Create Plot Response ===');
      print('Status Code: ${resp.statusCode}');
      print('Body: ${resp.body}');
      print('========================');

      if (resp.statusCode == 200) {
        try {
          final js = jsonDecode(resp.body);
          final message = js['message'];

          if (message is Map && message['status'] == 'error') {
            return message['message']?.toString() ?? 'Unknown error occurred';
          }
          return js;
        } catch (e) {
          print('Error parsing response: $e');
          return 'Failed to parse server response';
        }
      } else {
        try {
          final js = jsonDecode(resp.body);
          if (js is Map) {
            if (js['message'] is Map && js['message']['message'] != null) {
              return js['message']['message'].toString();
            }
            if (js['message'] != null) return js['message'].toString();
            if (js['exception'] != null) return js['exception'].toString();
          }
        } catch (_) {}
        return 'Failed to create plot (Status: ${resp.statusCode})';
      }
    } catch (e) {
      print('Network error in createPlot: $e');
      return 'Network error: $e';
    }
  }

  /// Edit an existing plot — only pass the fields you want to update.
  /// Returns the updated plot as a [Map] on success, or an error [String].
  Future<dynamic> editPlot({
    required String plotId,
    String? plotName,
    String? cropName,
    String? cropVariety,
    String? sowingDate,
    String? harvestDate,
    String? typeOfIrrigation,
    String? typeOfFarming,
    String? soilType,
    double? totalAcres,
  }) async {
    final uri = Uri.parse(
        '$baseUrl/api/method/krishiastra_app.api.plot_api.edit_plot');
    final headers =
        await getAuthHeaders(contentType: 'application/x-www-form-urlencoded');

    // Only include non-null fields so the backend does a patch-style update
    final body = <String, String>{'plot_id': plotId};

    if (plotName != null)          body['plot_name']           = plotName;
    if (cropName != null)          body['crop_name']           = cropName;
    if (cropVariety != null)       body['crop_variety']        = cropVariety;
    if (sowingDate != null)        body['sowing_date']         = sowingDate;
    if (harvestDate != null)       body['harvest_date']        = harvestDate;
    if (typeOfIrrigation != null)  body['type_of_irrigation']  = typeOfIrrigation;
    if (typeOfFarming != null)     body['type_of_farming']     = typeOfFarming;
    if (soilType != null)          body['soil_type']           = soilType;
    if (totalAcres != null)        body['total_acres']         = totalAcres.toString();

    print('=== Edit Plot Request ===');
    print('URL: $uri');
    print('Body: $body');
    print('========================');

    try {
      final resp = await http.post(uri, headers: headers, body: body);

      print('=== Edit Plot Response ===');
      print('Status Code: ${resp.statusCode}');
      print('Body: ${resp.body}');
      print('=========================');

      if (resp.statusCode == 200) {
        try {
          final js = jsonDecode(resp.body);
          final message = js['message'];

          if (message is Map) {
            if (message['status'] == 'error') {
              return message['message']?.toString() ?? 'Unknown error occurred';
            }
            if (message['status'] == 'ok') {
              // Return the updated plot map so the caller can refresh UI
              return message;
            }
          }
          return js;
        } catch (e) {
          print('Error parsing edit response: $e');
          return 'Failed to parse server response';
        }
      } else {
        try {
          final js = jsonDecode(resp.body);
          if (js is Map) {
            if (js['message'] is Map && js['message']['message'] != null) {
              return js['message']['message'].toString();
            }
            if (js['message'] != null) return js['message'].toString();
            if (js['exception'] != null) return js['exception'].toString();
          }
        } catch (_) {}
        return 'Failed to update plot (Status: ${resp.statusCode})';
      }
    } catch (e) {
      print('Network error in editPlot: $e');
      return 'Network error: $e';
    }
  }

  /// Fetch all plots for current user
  Future<List<dynamic>> fetchPlots() async {
    final uri = Uri.parse(
        '$baseUrl/api/method/krishiastra_app.api.plot_api.list_plots');
    final headers = await getAuthHeaders();

    final resp = await http.get(uri, headers: headers);

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      return data["message"]?["plots"] ?? [];
    } else {
      throw Exception("Failed to load plots");
    }
  }

  /// Save transaction (expenses and sales)
  Future<Map<String, dynamic>> saveTransaction({
    required String plotId,
    required List<Map<String, dynamic>> expenses,
    required List<Map<String, dynamic>> sales,
  }) async {
    final uri = Uri.parse(
        '$baseUrl/api/method/krishiastra_app.api.plot_api.save_plot_transaction');
    final headers =
        await getAuthHeaders(contentType: 'application/x-www-form-urlencoded');

    final body = {
      'plot_id': plotId,
      'expenses': jsonEncode(expenses),
      'sales': jsonEncode(sales),
    };

    try {
      final resp = await http.post(uri, headers: headers, body: body);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return data['message'] ?? {'success': false, 'message': 'Unknown error'};
      }
      return {
        'success': false,
        'message': 'Failed to save transaction (${resp.statusCode})'
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Get plot expenses
  Future<Map<String, dynamic>> getPlotExpenses(String plotId) async {
    final uri = Uri.parse(
        '$baseUrl/api/method/krishiastra_app.api.plot_api.get_plot_expenses?plot_id=$plotId');
    final headers = await getAuthHeaders();

    try {
      final resp = await http.get(uri, headers: headers);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return data['message'] ?? {};
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  /// Get plot sales
  Future<Map<String, dynamic>> getPlotSales(String plotId) async {
    final uri = Uri.parse(
        '$baseUrl/api/method/krishiastra_app.api.plot_api.get_plot_sales?plot_id=$plotId');
    final headers = await getAuthHeaders();

    try {
      final resp = await http.get(uri, headers: headers);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return data['message'] ?? {};
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  /// Fetch crop data from Agri University DocType
  Future<Map<String, dynamic>?> getCropData(String cropName) async {
    final uri = Uri.parse(
        '$baseUrl/api/method/krishiastra_app.api.agri_university_api.get_crop_info');

    try {
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'crop_name': cropName},
      );

      print('=== Get Crop Data Response ===');
      print('Status Code: ${resp.statusCode}');
      print('Body: ${resp.body}');
      print('========================');

      if (resp.statusCode == 200) {
        final js = jsonDecode(resp.body);
        final message = js['message'];

        if (message is Map && message['success'] == true) {
          return message['data'];
        } else {
          print('API returned error: ${message['message']}');
          return null;
        }
      }
    } catch (e) {
      print('Error fetching crop data: $e');
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // ANALYTICS
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getPlotAnalytics({
    required String plotId,
    required String viewType, // "monthly" or "yearly"
    String? year,
  }) async {
    try {
      final headers = await getAuthHeaders();
      String url =
          '$baseUrl/api/method/krishiastra_app.api.analytics_api.get_plot_analytics'
          '?plot=$plotId&view_type=$viewType';
      if (year != null) url += '&year=$year';

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? {};
      }
      return {'success': false, 'message': 'Server error'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ---------------------------------------------------------------------------
  // STORAGE UTILITIES
  // ---------------------------------------------------------------------------

  /// Clear all stored data
  Future<void> clearAllStorage() async {
    await _storage.deleteAll();
  }

  /// Debug method to check what's stored
  Future<void> printStoredCredentials() async {
    final sid = await _storage.read(key: 'sid');
    final fullName = await _storage.read(key: 'full_name');

    print('=== Stored Credentials ===');
    print('SID: ${sid != null ? "Present" : "Missing"}');
    print('Full Name: $fullName');
    print('========================');
  }
}