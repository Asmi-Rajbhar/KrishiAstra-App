import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// --- Data Model (No changes) ---
class DailySummary {
  final DateTime date;
  double minTemp;
  double maxTemp;
  double avgHumidity;
  double totalRainfall;
  String weatherCondition;
  double soilTemp;
  double soilMoisture;
  double soilPh;
  double nitrogen;
  double phosphorus;
  double potassium;

  DailySummary({
    required this.date,
    this.minTemp = 0,
    this.maxTemp = 0,
    this.avgHumidity = 0,
    this.totalRainfall = 0,
    this.weatherCondition = "Clear",
    this.soilTemp = 0,
    this.soilMoisture = 0,
    this.soilPh = 0,
    this.nitrogen = 0,
    this.phosphorus = 0,
    this.potassium = 0,
  });
}

// --- Main Widget ---
class HistoricalResultPage extends StatefulWidget {
  final String latitude;
  final String longitude;
  final DateTime startDate;
  final DateTime endDate;

  HistoricalResultPage({
    required this.latitude,
    required this.longitude,
    required this.startDate,
    required this.endDate,
  });

  @override
  _HistoricalResultPageState createState() => _HistoricalResultPageState();
}

class _HistoricalResultPageState extends State<HistoricalResultPage> {
  List<DailySummary> _summaries = [];

  @override
  void initState() {
    super.initState();
    _summaries = _generateDummySummaries(widget.startDate, widget.endDate);
  }

  // --- Dummy Data Generation (No changes) ---
  List<DailySummary> _generateDummySummaries(DateTime start, DateTime end) {
    List<DailySummary> dummySummaries = [];
    final random = Random();
    final dayCount = end.difference(start).inDays + 1;

    for (int i = 0; i < dayCount; i++) {
      final date = start.add(Duration(days: i));
      final minT = 20 + random.nextDouble() * 5;
      dummySummaries.add(DailySummary(
          date: date,
          minTemp: minT,
          maxTemp: minT + 5 + random.nextDouble() * 3,
          avgHumidity: 60 + random.nextDouble() * 20,
          totalRainfall: random.nextDouble() * 15,
          weatherCondition: ['Clear', 'Clouds', 'Rain'][random.nextInt(3)],
          soilTemp: 22 + random.nextDouble() * 4,
          soilMoisture: 0.5 + random.nextDouble() * 0.2,
          soilPh: 6.5 + random.nextDouble() * 0.5,
          nitrogen: 35 + random.nextDouble() * 10,
          phosphorus: 15 + random.nextDouble() * 5,
          potassium: 25 + random.nextDouble() * 8));
    }
    return dummySummaries;
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'rain':
        return FontAwesomeIcons.cloudShowersHeavy;
      case 'clouds':
        return FontAwesomeIcons.cloud;
      case 'clear':
        return FontAwesomeIcons.sun;
      default:
        return FontAwesomeIcons.cloudSun;
    }
  }

  @override
  Widget build(BuildContext context) {
    // UPDATED: Wrapped Scaffold in a Theme to apply Lexend font
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.lexendTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text("Historical Analysis",
              style: GoogleFonts.lexend(fontWeight: FontWeight.bold)),
          backgroundColor: const Color(0xFF0A6F3B),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoBox(),
              SizedBox(height: 20),
              _buildCropAdvisor(),
              SizedBox(height: 24),
              _buildWeatherOverview(),
              SizedBox(height: 24),

              // UPDATED: ExpansionTiles are now wrapped in styled cards
              _buildAnalysisCard(
                title: "Weather Analysis",
                icon: FontAwesomeIcons.cloudSun,
                child: _buildWeatherSection(),
              ),
              SizedBox(height: 16),
              _buildAnalysisCard(
                title: "Soil Analysis",
                icon: FontAwesomeIcons.seedling,
                child: _buildSoilSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for the Lat/Lon and Date info box
  Widget _buildInfoBox() {
    String dateRange =
        "Date Timeline: ${DateFormat('MMM dd, yyyy').format(widget.startDate)} - ${DateFormat('MMM dd, yyyy').format(widget.endDate)}";
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4))
        ],
      ),
      child: Text(
        "Latitude: ${double.parse(widget.latitude).toStringAsFixed(2)}, Longitude: ${double.parse(widget.longitude).toStringAsFixed(2)}\n$dateRange",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  // Widget for the Crop Advisor banner
  Widget _buildCropAdvisor() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green.shade100.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.green.shade800),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Crop Advisor: Crops like Okra, Spinach and peas show strong yields.",
              style: TextStyle(
                  color: Colors.green.shade900, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // UPDATED: Added shadow for consistency
  Widget _buildWeatherOverview() {
    final displayData = _summaries.length > 5
        ? _summaries.sublist(_summaries.length - 5)
        : _summaries;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            displayData.map((summary) => _buildForecastItem(summary)).toList(),
      ),
    );
  }

  Widget _buildForecastItem(DailySummary summary) {
    return Column(
      children: [
        Text(DateFormat('d MMM').format(summary.date),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Icon(_getWeatherIcon(summary.weatherCondition),
            color: Colors.green.shade600, size: 28),
        SizedBox(height: 12),
        Text(
          "${summary.minTemp.toStringAsFixed(0)}°-${summary.maxTemp.toStringAsFixed(0)}°",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(FontAwesomeIcons.tint, size: 10, color: Colors.blue.shade700),
            SizedBox(width: 4),
            Text(
              "${summary.totalRainfall.toStringAsFixed(1)} mm",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  // NEW: Reusable card widget for analysis sections
  Widget _buildAnalysisCard(
      {required String title, required IconData icon, required Widget child}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Icon(icon, color: Colors.green.shade800),
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.green.shade800)),
        initiallyExpanded: true,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: child,
          )
        ],
      ),
    );
  }

  // --- Chart Sections ---
  Widget _buildWeatherSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildChartCard("Temperature (°C)",
            _getChartSpots((s) => s.maxTemp, _summaries), Colors.green),
        _buildChartCard("Rainfall (mm)",
            _getChartSpots((s) => s.totalRainfall, _summaries), Colors.teal),
        _buildChartCard(
            "Humidity (%)",
            _getChartSpots((s) => s.avgHumidity, _summaries),
            Colors.lightGreen),
      ],
    );
  }

  Widget _buildSoilSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildChartCard(
            "Soil Temp (°C)",
            _getChartSpots((s) => s.soilTemp, _summaries),
            Colors.green.shade800),
        _buildChartCard(
            "Soil Moisture",
            _getChartSpots((s) => s.soilMoisture, _summaries),
            Colors.lime.shade700),
        _buildChartCard("Soil pH", _getChartSpots((s) => s.soilPh, _summaries),
            Colors.greenAccent.shade700),
        _buildChartCard(
            "Nitrogen (ppm)",
            _getChartSpots((s) => s.nitrogen, _summaries),
            Colors.green.shade600),
        _buildChartCard(
            "Phosphorus (ppm)",
            _getChartSpots((s) => s.phosphorus, _summaries),
            Colors.teal.shade700),
        _buildChartCard(
            "Potassium (ppm)",
            _getChartSpots((s) => s.potassium, _summaries),
            Colors.lightGreen.shade800),
      ],
    );
  }

  // --- Chart Logic (No changes) ---
  List<FlSpot> _getChartSpots(
      double Function(DailySummary) getValue, List<DailySummary> data) {
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), getValue(entry.value));
    }).toList();
  }

  Widget _buildChartCard(String title, List<FlSpot> spots, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ),
        SizedBox(height: 12),
        Card(
          elevation: 0,
          color: Colors.grey.shade50,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: true, reservedSize: 40)),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: (spots.length / 5).ceil().toDouble(),
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < _summaries.length) {
                          return Text(
                              DateFormat('d/M').format(_summaries[index].date),
                              style: TextStyle(fontSize: 10));
                        }
                        return Text('');
                      },
                    )),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                          show: true, color: color.withOpacity(0.3)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
