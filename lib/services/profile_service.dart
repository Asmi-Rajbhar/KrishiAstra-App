// lib/services/profile_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ProfileService {
  static const String baseUrl = 'http://110.225.251.16:4445';
  final AuthService _authService = AuthService();

  /// Fetch complete user profile from User Details doctype
  Future<Map<String, dynamic>?> getUserProfile() async {
    final uri = Uri.parse('$baseUrl/api/method/krishiastra_app.api.profile_api.get_user_profile');
    final headers = await _authService.getAuthHeaders();

    try {
      print('=== Fetching User Profile ===');
      print('URL: $uri');
      print('Headers: $headers');
      
      final response = await http.get(uri, headers: headers);
      
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('========================');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // The API returns data in message.data structure
        if (data['message'] != null) {
          final message = data['message'];
          
          // Check if message is a Map with success field
          if (message is Map && message['success'] == true) {
            if (message['data'] != null) {
              final profileData = message['data'] as Map<String, dynamic>;
              
              print('\n=== Profile Data Received ===');
              profileData.forEach((key, value) {
                print('$key: $value');
              });
              print('===========================\n');
              
              return profileData;
            }
          }
        }
        
        print('ERROR: Unexpected response structure');
        print('Full response: ${jsonEncode(data)}');
        return null;
      }
      
      print('ERROR: Status code ${response.statusCode}');
      return null;
    } catch (e, stackTrace) {
      print('ERROR fetching user profile: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Update user profile fields
  Future<Map<String, dynamic>> updateUserProfile({
    String? fullName,
    String? phoneNo,
    String? email,
    String? address,
    String? village,
    String? tehsil,
    String? district,
    String? state,
    String? country,
    String? pincode,
    String? digipin,
    String? education,
    String? totalLandCultivated,
    String? annualIncome,
  }) async {
    final uri = Uri.parse('$baseUrl/api/method/krishiastra_app.api.profile_api.update_user_profile');
    final headers = await _authService.getAuthHeaders(contentType: 'application/x-www-form-urlencoded');

    final body = <String, String>{};
    
    if (fullName != null) body['full_name'] = fullName;
    if (phoneNo != null) body['phone_no'] = phoneNo;
    if (email != null) body['email'] = email;
    if (address != null) body['address'] = address;
    if (village != null) body['village'] = village;
    if (tehsil != null) body['tehsil'] = tehsil;
    if (district != null) body['district'] = district;
    if (state != null) body['state'] = state;
    if (country != null) body['country'] = country;
    if (pincode != null) body['pincode'] = pincode;
    if (digipin != null) body['digipin'] = digipin;
    if (education != null) body['education'] = education;
    if (totalLandCultivated != null) body['total_land_cultivated'] = totalLandCultivated;
    if (annualIncome != null) body['annual_income'] = annualIncome;

    try {
      print('=== Updating User Profile ===');
      print('URL: $uri');
      print('Body: $body');
      
      final response = await http.post(uri, headers: headers, body: body);
      
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('========================');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['message'] != null && data['message'] is Map) {
          return data['message'];
        }
        return {'success': false, 'message': 'Unknown error'};
      }
      
      return {
        'success': false,
        'message': 'Failed to update profile (Status: ${response.statusCode})'
      };
    } catch (e) {
      print('Error updating user profile: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  /// Get verification status
  Future<String?> getVerificationStatus() async {
    try {
      final profile = await getUserProfile();
      return profile?['verify_status']?.toString();
    } catch (e) {
      print('Error getting verification status: $e');
      return null;
    }
  }

  /// Check if user has complete profile
  Future<bool> hasCompleteProfile() async {
    try {
      final profile = await getUserProfile();
      if (profile == null) return false;

      // Check mandatory fields based on your doctype
      final requiredFields = [
        'full_name',
        'phone_no',
        'user', // email
        'village',
        'district',
        'state',
      ];

      for (var field in requiredFields) {
        if (profile[field] == null || profile[field].toString().isEmpty) {
          return false;
        }
      }

      return true;
    } catch (e) {
      print('Error checking profile completeness: $e');
      return false;
    }
  }

  /// Get profile completion percentage
  Future<int> getProfileCompletionPercentage() async {
    try {
      final profile = await getUserProfile();
      if (profile == null) return 0;

      final allFields = [
        'full_name',
        'phone_no',
        'user', // email
        'address',
        'village',
        'tehsil',
        'district',
        'state',
        'country',
        'pincode',
        'digipin',
        'education',
        'total_land_cultivated',
        'annual_income',
        'aadhaar_no',
        'pancard_no',
      ];

      int filledFields = 0;
      for (var field in allFields) {
        if (profile[field] != null && profile[field].toString().isNotEmpty) {
          filledFields++;
        }
      }

      return ((filledFields / allFields.length) * 100).round();
    } catch (e) {
      print('Error calculating profile completion: $e');
      return 0;
    }
  }
}