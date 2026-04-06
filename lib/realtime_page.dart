import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'realtime_result.dart'; // Ensure this file exists

class RealtimeWeatherPage extends StatefulWidget {
  @override
  _RealtimeWeatherPageState createState() => _RealtimeWeatherPageState();
}

class _RealtimeWeatherPageState extends State<RealtimeWeatherPage> {
  final TextEditingController _locationController = TextEditingController();
  String? latitude;
  String? longitude;

  // Replace with your OpenWeather API key
  final String apiKey = "a32ad422c06b469fa290bd839f1a6665";

  // Detect location using GPS
  Future<void> _detectLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        _locationController.clear(); // Clear text field if location is detected
      });
    } catch (e) {
      print("Error detecting location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Could not detect location. Please enable GPS.")),
      );
    }
  }

  // Fetch coordinates by city name
  Future<void> _fetchCoordsByCity(String city) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          latitude = data["coord"]["lat"].toString();
          longitude = data["coord"]["lon"].toString();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to find city. Please check the name.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  // Navigate to result page
  void _goToResults() {
    if (latitude != null && longitude != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RealtimeResultPage(
            latitude: latitude!,
            longitude: longitude!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a location first")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Applying the Lexend font theme to the whole page
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.lexendTextTheme(),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text("Realtime Insights",
              style: GoogleFonts.lexend(fontWeight: FontWeight.bold)),
          backgroundColor: const Color(0xFF0A6F3B),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Search Box ---
              Text(
                "Find Your Location",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0A6F3B)),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _locationController,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: "E.g. Mumbai, India",
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _fetchCoordsByCity(value).then((_) => _goToResults());
                  }
                },
              ),
              SizedBox(height: 20),

              // --- Divider ---
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("OR",
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              SizedBox(height: 20),

              // --- Detect Location Button ---
              ElevatedButton.icon(
                onPressed: _detectLocation,
                icon: Icon(Icons.my_location, color: Colors.white),
                label: Text("Use Current Location",
                    style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A6F3B),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
              SizedBox(height: 24),

              // --- Coordinates Display Box ---
              if (latitude != null && longitude != null)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF0A6F3B)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Coordinates Detected",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.pin_drop_outlined,
                              color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Latitude: ${double.parse(latitude!).toStringAsFixed(4)}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.pin_drop_outlined,
                              color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Longitude: ${double.parse(longitude!).toStringAsFixed(4)}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              Spacer(),

              // --- Get Results Button ---
              ElevatedButton(
                onPressed: () {
                  if (_locationController.text.isNotEmpty) {
                    _fetchCoordsByCity(_locationController.text)
                        .then((_) => _goToResults());
                  } else {
                    _goToResults();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A6F3B),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Get Insights",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
