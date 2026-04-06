import 'package:equatable/equatable.dart';

class CropDiseaseRisk extends Equatable {
  final String diseaseName;
  final String description;

  const CropDiseaseRisk({required this.diseaseName, required this.description});

  factory CropDiseaseRisk.fromJson(Map<String, dynamic> json) {
    return CropDiseaseRisk(
      diseaseName: json['disease_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [diseaseName, description];
}

class RiskAndCareDetails extends Equatable {
  final String highFertilizerLoad;
  final String fertilizerRequirements;
  final String waterManagement;

  const RiskAndCareDetails({
    required this.highFertilizerLoad,
    required this.fertilizerRequirements,
    required this.waterManagement,
  });

  factory RiskAndCareDetails.fromJson(Map<String, dynamic> json) {
    return RiskAndCareDetails(
      highFertilizerLoad: json['high_fertilizer_load']?.toString() ?? '',
      fertilizerRequirements: json['fertilizer_requirements']?.toString() ?? '',
      waterManagement: json['water_management']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [
    highFertilizerLoad,
    fertilizerRequirements,
    waterManagement,
  ];
}

class CropRiskAndCare extends Equatable {
  final List<CropDiseaseRisk> cropDiseases;
  final RiskAndCareDetails riskAndCare;

  const CropRiskAndCare({
    required this.cropDiseases,
    required this.riskAndCare,
  });

  factory CropRiskAndCare.fromJson(Map<String, dynamic> json) {
    final diseasesList = (json['crop_diseases'] as List? ?? [])
        .map((e) => CropDiseaseRisk.fromJson(e as Map<String, dynamic>))
        .toList();

    return CropRiskAndCare(
      cropDiseases: diseasesList,
      riskAndCare: RiskAndCareDetails.fromJson(
        json['risk_and_care'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  @override
  List<Object?> get props => [cropDiseases, riskAndCare];
}
