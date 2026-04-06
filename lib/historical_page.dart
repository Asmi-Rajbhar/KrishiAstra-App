import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'historical_result.dart'; // Ensure this file exists

class HistoricalWeatherPage extends StatefulWidget {
  @override
  _HistoricalWeatherPageState createState() => _HistoricalWeatherPageState();
}

class _HistoricalWeatherPageState extends State<HistoricalWeatherPage> {
  final TextEditingController _locationController = TextEditingController();
  String? latitude;
  String? longitude;
  DateTime? _startDate;
  DateTime? _endDate;

  final String apiKey = "a32ad422c06b469fa290bd839f1a6665";

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: const Color(0xFF0A6F3B),
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF0A6F3B),
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
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _detectLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!mounted) return;
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      });
    } catch (e) {
      print("Error detecting location: $e");
    }
  }

  Future<void> _fetchCoordsByCity(String city) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";
    try {
      final response = await http.get(Uri.parse(url));
      if (!mounted) return;
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  void _goToResults() {
    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a location first")),
      );
      return;
    }
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a start and end date")),
      );
      return;
    }
    if (_startDate!.isAfter(_endDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Start date cannot be after end date")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoricalResultPage(
          latitude: latitude!,
          longitude: longitude!,
          startDate: _startDate!,
          endDate: _endDate!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0A6F3B),
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: GoogleFonts.lexendTextTheme(
          Theme.of(context).textTheme,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A6F3B),
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.lexend(
                fontWeight: FontWeight.w600,
                fontSize: 16), // Font for all buttons
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: GoogleFonts.lexend(),
          hintStyle: GoogleFonts.lexend(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: const Color(0xFF0A6F3B)),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          // FIX: Added the leading property to create a back button
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: const Color(0xFF0A6F3B),
          foregroundColor: Colors.white,
          title: Text("Historical Weather & Soil Data",
              style: GoogleFonts.lexend(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 4,
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: "Enter Location",
                  hintText: "E.g. Mumbai",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: const Color(0xFF0A6F3B)),
                    onPressed: () {
                      if (_locationController.text.isNotEmpty) {
                        _fetchCoordsByCity(_locationController.text);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text("OR",
                    style: GoogleFonts.lexend(
                        color: Colors.grey, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _detectLocation,
                icon: Icon(Icons.my_location),
                label: Text("Detect Current Location"),
              ),
              const SizedBox(height: 20),
              if (latitude != null && longitude != null)
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Coordinates: Latitude: ${double.parse(latitude!).toStringAsFixed(2)}, Longitude: ${double.parse(longitude!).toStringAsFixed(2)}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexend(
                          color: Colors.green[800],
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              Divider(height: 40, color: Colors.grey[400]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("Start Date",
                            style: GoogleFonts.lexend(
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _selectDate(context, true),
                          child: Text(_startDate == null
                              ? 'Select Date'
                              : formatter.format(_startDate!)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16, height: 14),
                  Expanded(
                    child: Column(
                      children: [
                        Text("End Date",
                            style: GoogleFonts.lexend(
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _selectDate(context, false),
                          child: Text(_endDate == null
                              ? 'Select Date'
                              : formatter.format(_endDate!)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _goToResults,
                child: Text("Get Historical Data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
