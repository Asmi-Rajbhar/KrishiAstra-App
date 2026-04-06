import 'package:flutter/material.dart';
import 'realtime_page.dart';
import 'historical_page.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Insights",
            style: GoogleFonts.lexend(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // This card will now use the new design
            _weatherCard(
              context,
              "assets/images/realtime.png", // Make sure this path is correct in your project
              "Realtime Weather\n& Soil Insights",
              RealtimeWeatherPage(),
            ),
            SizedBox(height: 20),
            // This card will also use the new design
            _weatherCard(
              context,
              "assets/images/historical.png", // Make sure this path is correct
              "Historical Weather\nInsights",
              HistoricalWeatherPage(),
            ),
          ],
        ),
      ),
    );
  }

  // UPDATED WIDGET
  Widget _weatherCard(
      BuildContext context, String image, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF0A6F3B),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // 1. Added Padding around the image container
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: ClipRRect(
                // 2. Rounded all corners of the image itself
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  image,
                  height: 190,
                  width: double.infinity, // Ensures image fills the ClipRRect
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              // 3. Adjusted padding for the text for better spacing
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.lexend(
                  fontSize: 18, // Slightly increased font size
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
