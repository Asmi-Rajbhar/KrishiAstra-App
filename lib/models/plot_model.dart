// lib/models/plot_model.dart

class Plot {
  final String id;              // Frappe auto-generated doc name — e.g. "Plot Details-0001"
  final String name;            // Human label from plot_name field — e.g. "My Farm"
  final String imageUrl;
  final String location;
  final double area;            // total_acres
  final String soilType;
  final String irrigationType;  // type_of_irrigation
  final String crop;            // crop_name
  final String variety;         // crop_variety
  final String sowingDate;      // sowing_date
  final String harvestDate;     // harvest_date
  final String farmingType;     // type_of_farming
  final String latitude;
  final String longitude;
  final String status;

  Plot({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.area,
    required this.soilType,
    required this.irrigationType,
    required this.crop,
    required this.variety,
    required this.sowingDate,
    required this.harvestDate,
    required this.farmingType,
    required this.latitude,
    required this.longitude,
    required this.status,
  });

  factory Plot.fromJson(Map<String, dynamic> json) {
    final id         = json['name']?.toString() ?? '';
    final plotName   = json['plot_name']?.toString() ?? id;
    final lat        = json['latitude']?.toString() ?? '';
    final lng        = json['longitude']?.toString() ?? '';
    final totalAcres = double.tryParse(json['total_acres']?.toString() ?? '') ?? 0.0;
    final crop       = json['crop_name']?.toString() ?? '';
    final variety    = json['crop_variety']?.toString() ?? '';
    final sowing     = json['sowing_date']?.toString() ?? '';
    final harvest    = json['harvest_date']?.toString() ?? '';
    final irrigation = json['type_of_irrigation']?.toString() ?? '';
    final farming    = json['type_of_farming']?.toString() ?? '';
    final soilType   = json['soil_type']?.toString() ?? '';   // ← FIXED
    final status     = json['status']?.toString() ?? 'Active';

    final location = (lat.isNotEmpty && lng.isNotEmpty)
        ? '$lat, $lng'
        : (json['location']?.toString() ?? 'Unknown');

    // Keep your existing image logic
    String imageUrl = 'assets/images/realtime.png';
    if (crop.toLowerCase().contains('corn')) {
      imageUrl = 'assets/images/historical.png';
    }

    return Plot(
      id:             id,
      name:           plotName,
      imageUrl:       imageUrl,
      location:       location,
      area:           totalAcres,
      soilType:       soilType,       // ← FIXED (was hardcoded 'Unknown')
      irrigationType: irrigation,
      crop:           crop,
      variety:        variety,
      sowingDate:     sowing,
      harvestDate:    harvest,
      farmingType:    farming,
      latitude:       lat,
      longitude:      lng,
      status:         status,
    );
  }

  Map<String, dynamic> toJson() => {
        'name':               id,
        'plot_name':          name,
        'total_acres':        area,
        'crop_name':          crop,
        'crop_variety':       variety,
        'sowing_date':        sowingDate,
        'harvest_date':       harvestDate,
        'type_of_irrigation': irrigationType,
        'type_of_farming':    farmingType,
        'soil_type':          soilType,        // ← also added here for completeness
        'latitude':           latitude,
        'longitude':          longitude,
        'status':             status,
      };

  // ── Convenience helpers ──────────────────────────────────────
  bool get isActive   => status == 'Active';
  bool get isInactive => status == 'Inactive';
}