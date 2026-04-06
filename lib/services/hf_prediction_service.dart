import 'dart:convert';
import 'package:http/http.dart' as http;

class HFPredictionService {
  static const String _endpoint =
      "https://ravina0912-croppricerecomm.hf.space/predict";

  static Future<Map<String, dynamic>> getPrediction({
    required String crop,
    required String month,
    required String soil,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"crop": crop, "sowing_month": month, "soil": soil}),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RAW RESPONSE: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("API Error: ${response.statusCode}");
      }

      final decoded = jsonDecode(response.body);

      // If soil not suitable
      if (decoded["soil_suitable"] == false) {
        return {
          "soil_suitable": false,
          "message": decoded["message"],
          "top_alternatives": decoded["top_alternatives"] ?? [],
        };
      }

      // If soil suitable
      return {
        "soil_suitable": true,
        "crop": decoded["crop"],
        "harvest_month": decoded["harvest_month"],
        "expected_profit_score":
            (decoded["expected_profit_score"] ?? 0.0).toDouble(),
        "best_sowing_months": decoded["best_sowing_months"] ?? [],
      };
    } catch (e) {
      print("Prediction Error: $e");
      rethrow;
    }
  }
}