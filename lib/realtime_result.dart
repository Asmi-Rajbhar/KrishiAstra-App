import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart'; // Ensure this import is present

class RealtimeResultPage extends StatefulWidget {
  final String latitude;
  final String longitude;

  RealtimeResultPage({required this.latitude, required this.longitude});

  @override
  _RealtimeResultPageState createState() => _RealtimeResultPageState();
}

class _RealtimeResultPageState extends State<RealtimeResultPage> {
  // State variables to hold the API call status and data
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is first created
    _fetchWeatherData();
  }

  /// Fetches weather data from the OpenWeatherMap API
  Future<void> _fetchWeatherData() async {
    // --- IMPORTANT: REPLACE WITH YOUR API KEY ---
    const apiKey = 'a32ad422c06b469fa290bd839f1a6665';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${widget.latitude}&lon=${widget.longitude}&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        setState(() {
          _weatherData = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        setState(() {
          _errorMessage =
              'Failed to load weather data. Status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      // Catch any errors during the API call (e.g., no internet)
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  // Helper functions to safely extract and format data
  String _getTemperature() {
    if (_weatherData == null) return 'N/A';
    final tempMin =
        _weatherData!['main']['temp_min']?.toStringAsFixed(0) ?? '?';
    final tempMax =
        _weatherData!['main']['temp_max']?.toStringAsFixed(0) ?? '?';
    return '$tempMin°C - $tempMax°C';
  }

  String _getHumidity() {
    if (_weatherData == null) return 'N/A';
    return '${_weatherData!['main']['humidity']}%';
  }

  String _getCloudCover() {
    if (_weatherData == null) return 'N/A';
    // Capitalizes the first letter of the description (e.g., "scattered clouds" -> "Scattered clouds")
    String description = _weatherData!['weather'][0]['description'] ?? 'N/A';
    return description[0].toUpperCase() + description.substring(1);
  }

  String _getRainfall() {
    if (_weatherData == null || _weatherData!['rain'] == null) {
      return '0mm'; // No rain data available, assume 0
    }
    // API provides rain volume for the last 1 hour
    final rain1h = _weatherData!['rain']['1h'] ?? 0;
    return '${rain1h}mm';
  }

  @override
  Widget build(BuildContext context) {
    // UPDATED: Wrapped the entire Scaffold in a Theme to apply the Lexend font
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.lexendTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text("Realtime Weather & Soil Insights"),
          backgroundColor: Color(0xFF0A6F3B),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        // Conditionally render UI based on loading/error state
        body:
            _isLoading
                ? Center(
                  child: CircularProgressIndicator(color: Color(0xFF0A6F3B)),
                )
                : _errorMessage != null
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                )
                : _buildContent(),
      ),
    );
  }

  /// The main content widget, built after data is successfully fetched.
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Section 1: Weather Insights
          ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              "Weather Insights",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.25,
                  children: [
                    _buildStatCard(
                      imagePath: 'assets/images/temperature.png',
                      value: _getTemperature(), // DYNAMIC DATA
                      label: 'Temperature',
                      context: context,
                    ),
                    _buildStatCard(
                      imagePath: 'assets/images/humidity.png',
                      value: _getHumidity(), // DYNAMIC DATA
                      label: 'Humidity',
                      context: context,
                    ),
                    _buildStatCard(
                      imagePath: 'assets/images/cloud.png',
                      value: _getCloudCover(), // DYNAMIC DATA
                      label: 'Cloud Cover',
                      context: context,
                    ),
                    _buildStatCard(
                      imagePath: 'assets/images/rain.png',
                      value: _getRainfall(), // DYNAMIC DATA
                      label: 'Rainfall (1h)', // Updated label for clarity
                      context: context,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 22),

          // Section 2: Soil Condition (remains static as per original code)
          ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              "Soil Condition",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1,
                      children: [
                        _buildStatCard(
                          imagePath: 'assets/images/moisture.png',
                          value: '0.61',
                          label: 'Moisture',
                          context: context,
                        ),
                        _buildStatCard(
                          imagePath: 'assets/images/ph-level.png',
                          value: '6.5',
                          label: 'pH Level',
                          context: context,
                        ),
                        _buildStatCard(
                          imagePath: 'assets/images/soil-temp.png',
                          value: '24°C',
                          label: 'Temperature',
                          context: context,
                        ),
                        _buildStatCard(
                          imagePath: 'assets/images/nitrogen.png',
                          value: '45ppm',
                          label: 'Nitrogen (N)',
                          context: context,
                        ),
                        _buildStatCard(
                          imagePath: 'assets/images/phosphorus.png',
                          value: '20ppm',
                          label: 'Phosphorus (P)',
                          context: context,
                        ),
                        _buildStatCard(
                          imagePath: 'assets/images/potassium.png',
                          value: '30ppm',
                          label: 'Potassium (K)',
                          context: context,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.green.shade800,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Crop Advisor: \nHigh humidity and moderate rainfall today. Avoid spraying during peak wind hours. \nLoamy soil with moderate moisture and optimal pH.",
                              style: TextStyle(color: Colors.green.shade900),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 30),

          // Download Report Button
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Downloading report...")));
            },
            icon: Icon(Icons.download),
            label: Text("Download Report"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0A6F3B),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: TextStyle(
                // Font family will be inherited, but we can keep specific styles
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// A reusable widget to create a dashboard statistics card.
  Widget _buildStatCard({
    required String imagePath,
    required String value,
    required String label,
    required BuildContext context,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 40,
              width: 40,
              errorBuilder:
                  (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey,
                  ),
            ),
            SizedBox(height: 10),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
