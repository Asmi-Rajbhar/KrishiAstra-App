import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:turf/turf.dart' as turf;
// import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Unused in this file, kept if you need it
import 'package:google_fonts/google_fonts.dart';
// Import Localization
import 'l10n/app_localizations.dart';
import 'plot_details_form.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  final List<LatLng> _polygonPoints = [];

  // Changed: Removed initial value requiring context
  String _areaDisplay = '';

  bool _isDrawing = false;
  Marker? _userLocationMarker;

  double? _lastKnownLatitude;
  double? _lastKnownLongitude;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  // New: Initialize localized text when dependencies change
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_areaDisplay.isEmpty) {
      _areaDisplay = AppLocalizations.of(context)!.tapToStart;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleDrawing() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      if (_isDrawing) {
        if (_polygonPoints.length > 2) {
          _finishAndProceed();
        } else {
          _showSnackBar(
            '❌ ${l10n.minPointsError}', // Translated
            Colors.red,
          );
        }
        _isDrawing = false;
      } else {
        _polygonPoints.clear();
        _areaDisplay = l10n.tapToAdd; // Translated
        _isDrawing = true;
      }
    });
  }

  void _handleMapTap(TapPosition tapPosition, LatLng latLng) {
    final l10n = AppLocalizations.of(context)!;
    if (_isDrawing) {
      setState(() {
        _polygonPoints.add(latLng);
        if (_polygonPoints.length > 2) {
          final List<List<turf.Position>> coords = [
            _polygonPoints
                .map((p) => turf.Position(p.longitude, p.latitude))
                .toList(),
          ];
          coords[0].add(coords[0][0]);
          final polygon = turf.Polygon(coordinates: coords);
          final areaSqMeters = turf.area(polygon);
          final areaAcres = (areaSqMeters ?? 0) / 4046.856;
          // Translated Acres
          _areaDisplay = '${areaAcres.toStringAsFixed(3)} ${l10n.acres}';
        }
      });
    }
  }

  void _finishAndProceed() {
    final l10n = AppLocalizations.of(context)!;

    if (_lastKnownLatitude == null || _lastKnownLongitude == null) {
      _showSnackBar(
        '📍 ${l10n.setLocationError}', // Translated
        Colors.orange,
      );
      return;
    }

    final List<List<turf.Position>> coords = [
      _polygonPoints
          .map((p) => turf.Position(p.longitude, p.latitude))
          .toList(),
    ];
    coords[0].add(coords[0][0]);

    final polygon = turf.Polygon(coordinates: coords);
    final areaSqMeters = turf.area(polygon);
    final areaAcres = (areaSqMeters ?? 0) / 4046.856;

    setState(() {
      _areaDisplay = '${areaAcres.toStringAsFixed(3)} ${l10n.acres}';
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PlotDetailsFormPage(
              areaInAcres: areaAcres,
              centerLatitude: _lastKnownLatitude!,
              centerLongitude: _lastKnownLongitude!,
            ),
      ),
    );
  }

  Future<void> _searchLocation() async {
    final l10n = AppLocalizations.of(context)!;
    final query = _searchController.text;
    if (query.isEmpty) return;

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?format=json&q=$query',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isEmpty) {
          _showSnackBar('❌ ${l10n.locationNotFound}', Colors.red); // Translated
          return;
        }
        final loc = data[0];
        final lat = double.parse(loc['lat']);
        final lon = double.parse(loc['lon']);

        setState(() {
          _lastKnownLatitude = lat;
          _lastKnownLongitude = lon;
        });

        _mapController.move(LatLng(lat, lon), 18.0);
        _showSnackBar(
          '✅ ${l10n.locationFound}', // Translated
          const Color(0xFF0A6F3B),
        );
      }
    } catch (e) {
      _showSnackBar('⚠️ ${l10n.searchFailed}', Colors.red); // Translated
    }
  }

  Future<void> _locateMe() async {
    final l10n = AppLocalizations.of(context)!;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar('📍 ${l10n.locationDisabled}', Colors.orange); // Translated
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar('❌ ${l10n.permissionDenied}', Colors.red); // Translated
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar(
        '❌ ${l10n.permissionDeniedForever}',
        Colors.red,
      ); // Translated
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final userLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _lastKnownLatitude = position.latitude;
        _lastKnownLongitude = position.longitude;

        _userLocationMarker = Marker(
          width: 80.0,
          height: 80.0,
          point: userLocation,
          child: ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.3),
              ),
              child: const Center(
                child: Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ),
          ),
        );
      });

      _mapController.move(userLocation, 18.0);
      _showSnackBar(
        '✅ ${l10n.locationDetected}',
        const Color(0xFF0A6F3B),
      ); // Translated
    } catch (e) {
      _showSnackBar('❌ ${l10n.locationError}', Colors.red); // Translated
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _undoLastPoint() {
    final l10n = AppLocalizations.of(context)!;
    if (_polygonPoints.isNotEmpty) {
      setState(() {
        _polygonPoints.removeLast();
        if (_polygonPoints.length > 2) {
          final List<List<turf.Position>> coords = [
            _polygonPoints
                .map((p) => turf.Position(p.longitude, p.latitude))
                .toList(),
          ];
          coords[0].add(coords[0][0]);
          final polygon = turf.Polygon(coordinates: coords);
          final areaSqMeters = turf.area(polygon);
          final areaAcres = (areaSqMeters ?? 0) / 4046.856;
          _areaDisplay = '${areaAcres.toStringAsFixed(3)} ${l10n.acres}';
        } else {
          _areaDisplay = l10n.tapToAdd; // Translated
        }
      });
    }
  }

  void _clearAll() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _polygonPoints.clear();
      _areaDisplay = l10n.tapToAdd; // Translated
    });
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom + 1.0);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom - 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0A6F3B),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.map_outlined, size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.plotMappingTitle, // Translated
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(l10n),
          _buildInfoCard(l10n),
          Expanded(child: _buildMap()),
        ],
      ),
      floatingActionButton: _buildFloatingButtons(l10n),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAF9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: l10n.searchLocationHint, // Translated
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF0A6F3B),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onSubmitted: (_) => _searchLocation(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A90E2).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _locateMe,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient:
            _isDrawing
                ? const LinearGradient(
                  colors: [Color(0xFF0A6F3B), Color(0xFF0D8A4A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                : const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (_isDrawing
                    ? const Color(0xFF0A6F3B)
                    : const Color(0xFF4A90E2))
                .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _isDrawing ? Icons.draw_outlined : Icons.info_outline,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isDrawing
                          ? l10n.drawingMode
                          : l10n.readyToMap, // Translated
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _polygonPoints.isEmpty
                          ? _areaDisplay
                          : '${_polygonPoints.length} ${l10n.points} • $_areaDisplay', // Translated
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isDrawing && _polygonPoints.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    l10n.undo, // Translated
                    Icons.undo,
                    _undoLastPoint,
                    Colors.white.withOpacity(0.2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    l10n.clear, // Translated
                    Icons.clear_all,
                    _clearAll,
                    Colors.white.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
    Color color,
  ) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZoomButtons() {
    return Positioned(
      top: 20,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'zoomInBtn',
            onPressed: _zoomIn,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0A6F3B),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'zoomOutBtn',
            onPressed: _zoomOut,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0A6F3B),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(20.5937, 78.9629),
                initialZoom: 5.0,
                onTap: _handleMapTap,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                  userAgentPackageName: 'com.example.farm_plot_mapping',
                ),
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: _polygonPoints,
                      color: const Color(0xFF0A6F3B).withOpacity(0.4),
                      borderColor: const Color(0xFF0A6F3B),
                      borderStrokeWidth: 3,
                      isFilled: true,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    if (_userLocationMarker != null) _userLocationMarker!,
                    ..._polygonPoints.asMap().entries.map((entry) {
                      return Marker(
                        width: 30,
                        height: 30,
                        point: entry.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF0A6F3B),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0A6F3B),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
          _buildZoomButtons(),
        ],
      ),
    );
  }

  Widget _buildFloatingButtons(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isDrawing && _polygonPoints.length > 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FloatingActionButton.extended(
              onPressed: _toggleDrawing,
              heroTag: 'finish',
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0A6F3B),
              elevation: 4,
              icon: const Icon(Icons.check_circle_outline, size: 22),
              label: Text(
                l10n.finish, // Translated
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (_isDrawing ? Colors.red : const Color(0xFF0A6F3B))
                    .withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: _toggleDrawing,
            heroTag: 'toggle',
            backgroundColor: _isDrawing ? Colors.red : const Color(0xFF0A6F3B),
            foregroundColor: Colors.white,
            elevation: 0,
            icon: Icon(_isDrawing ? Icons.stop : Icons.edit_location, size: 22),
            label: Text(
              _isDrawing ? l10n.stopDrawing : l10n.startDrawing, // Translated
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
