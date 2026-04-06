import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_basic_details.dart';

class CropBasicDetailsModel extends CropBasicDetails {
  const CropBasicDetailsModel({
    required super.cropName,
    required super.description,
    required super.maturityTime,
    required super.revenue,
    required super.waterIntensive,
    required super.climateNeeds,
  });

  factory CropBasicDetailsModel.fromJson(Map<String, dynamic> json) {
    return CropBasicDetailsModel(
      cropName: json['crop_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      maturityTime: json['maturity_time'] ?? 0,
      revenue: json['revenue'] ?? 0.0,
      waterIntensive: json['water_intensive']?.toString() ?? '',
      climateNeeds: json['climate_needs']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crop_name': cropName,
      'description': description,
      'maturity_time': maturityTime,
      'revenue': revenue,
      'water_intensive': waterIntensive,
      'climate_needs': climateNeeds,
    };
  }

  CropBasicDetails toEntity() {
    return CropBasicDetails(
      cropName: cropName,
      description: description,
      maturityTime: maturityTime,
      revenue: revenue,
      waterIntensive: waterIntensive,
      climateNeeds: climateNeeds,
    );
  }
}
