import 'package:equatable/equatable.dart';

class Rainfall extends Equatable {
  final String annualRequirement;
  final String rainfallDescription;
  final String rainfallAdvice;

  const Rainfall({
    required this.annualRequirement,
    required this.rainfallDescription,
    required this.rainfallAdvice,
  });

  factory Rainfall.fromJson(Map<String, dynamic> json) {
    return Rainfall(
      annualRequirement: json['annual_requirement']?.toString() ?? '',
      rainfallDescription: json['rainfall_description']?.toString() ?? '',
      rainfallAdvice: json['rainfall_advice']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [
    annualRequirement,
    rainfallDescription,
    rainfallAdvice,
  ];
}

class CropRequirement extends Equatable {
  final String cropName;
  final String soilType;
  final Rainfall rainfall;
  final String waterIntensive;
  final int maturityTime;
  final List<String> cropSeason;

  const CropRequirement({
    required this.cropName,
    required this.soilType,
    required this.rainfall,
    required this.waterIntensive,
    required this.maturityTime,
    required this.cropSeason,
  });

  factory CropRequirement.fromJson(Map<String, dynamic> json) {
    return CropRequirement(
      cropName: json['crop_name']?.toString() ?? '',
      soilType: json['soil_type']?.toString() ?? '',
      rainfall: Rainfall.fromJson(
        json['rainfall'] as Map<String, dynamic>? ?? {},
      ),
      waterIntensive: json['water_intensive']?.toString() ?? '',
      maturityTime: (json['maturity_time'] as num?)?.toInt() ?? 0,
      cropSeason: (json['crop_season'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
    cropName,
    soilType,
    rainfall,
    waterIntensive,
    maturityTime,
    cropSeason,
  ];
}
