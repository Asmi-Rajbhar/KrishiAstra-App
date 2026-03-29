class CropVarietyDetail {
  final String name;
  final String? expectedYield;
  final String? maturityTime;
  final String? plantationMethod;
  final String? expertRecommendation;
  final List<String> plantationMonths;
  final VarietyEnvironmentalStress? environmentalStress;
  final WeedManagement? weedManagement;
  final List<FertilizerSchedule> fertilizerSchedule;
  final List<String> diseases;
  final List<String> pests;
  final List<String> nutrients;
  final String? sucrosePercentage;
  final String? diseaseResistance;
  final String? recommendedSoilType;
  final String? season;
  final String? parentage;

  CropVarietyDetail({
    required this.name,
    this.expectedYield,
    this.maturityTime,
    this.plantationMethod,
    this.expertRecommendation,
    this.plantationMonths = const [],
    this.environmentalStress,
    this.weedManagement,
    this.fertilizerSchedule = const [],
    this.diseases = const [],
    this.pests = const [],
    this.nutrients = const [],
    this.sucrosePercentage,
    this.diseaseResistance,
    this.recommendedSoilType,
    this.season,
    this.parentage,
  });

  CropVarietyDetail copyWith({
    String? name,
    String? expectedYield,
    String? maturityTime,
    String? plantationMethod,
    String? expertRecommendation,
    List<String>? plantationMonths,
    VarietyEnvironmentalStress? environmentalStress,
    WeedManagement? weedManagement,
    List<FertilizerSchedule>? fertilizerSchedule,
    List<String>? diseases,
    List<String>? pests,
    List<String>? nutrients,
    String? sucrosePercentage,
    String? diseaseResistance,
    String? recommendedSoilType,
    String? season,
    String? parentage,
  }) {
    return CropVarietyDetail(
      name: name ?? this.name,
      expectedYield: expectedYield ?? this.expectedYield,
      maturityTime: maturityTime ?? this.maturityTime,
      plantationMethod: plantationMethod ?? this.plantationMethod,
      expertRecommendation: expertRecommendation ?? this.expertRecommendation,
      plantationMonths: plantationMonths ?? this.plantationMonths,
      environmentalStress: environmentalStress ?? this.environmentalStress,
      weedManagement: weedManagement ?? this.weedManagement,
      fertilizerSchedule: fertilizerSchedule ?? this.fertilizerSchedule,
      diseases: diseases ?? this.diseases,
      pests: pests ?? this.pests,
      nutrients: nutrients ?? this.nutrients,
      sucrosePercentage: sucrosePercentage ?? this.sucrosePercentage,
      diseaseResistance: diseaseResistance ?? this.diseaseResistance,
      recommendedSoilType: recommendedSoilType ?? this.recommendedSoilType,
      season: season ?? this.season,
      parentage: parentage ?? this.parentage,
    );
  }
}

class WeedManagement {
  final String name;
  final String type;
  final String solution;

  WeedManagement({
    required this.name,
    required this.type,
    required this.solution,
  });

  WeedManagement copyWith({String? name, String? type, String? solution}) {
    return WeedManagement(
      name: name ?? this.name,
      type: type ?? this.type,
      solution: solution ?? this.solution,
    );
  }
}

class FertilizerSchedule {
  final String growthStage;
  final String doseStage;
  final String recommendedNutrient;

  FertilizerSchedule({
    required this.growthStage,
    required this.doseStage,
    required this.recommendedNutrient,
  });

  FertilizerSchedule copyWith({
    String? growthStage,
    String? doseStage,
    String? recommendedNutrient,
  }) {
    return FertilizerSchedule(
      growthStage: growthStage ?? this.growthStage,
      doseStage: doseStage ?? this.doseStage,
      recommendedNutrient: recommendedNutrient ?? this.recommendedNutrient,
    );
  }
}

class VarietyEnvironmentalStress {
  final String? stressName;
  final String? severity;
  final String? causes;
  final String? symptoms;
  final String? impactOnCrop;
  final String? preventiveMeasures;

  // Legacy fields (optional, the API doesn't provide these directly anymore)
  final String? droughtTolerance;
  final String? salinityTolerance;
  final String? waterLoggingTolerance;

  VarietyEnvironmentalStress({
    this.stressName,
    this.severity,
    this.causes,
    this.symptoms,
    this.impactOnCrop,
    this.preventiveMeasures,
    this.droughtTolerance,
    this.salinityTolerance,
    this.waterLoggingTolerance,
  });

  factory VarietyEnvironmentalStress.fromJson(Map<String, dynamic> json) {
    return VarietyEnvironmentalStress(
      stressName: json['stress_name']?.toString(),
      severity: json['severity_level'] is Map
          ? (json['severity_level'] as Map)['severity_level']?.toString()
          : json['severity_level']?.toString(),
      causes: json['causes']?.toString(),
      symptoms: json['symptoms']?.toString(),
      impactOnCrop: json['impact_on_crop']?.toString(),
      preventiveMeasures: json['preventive_measures']?.toString(),
      // Attempt to map to legacy fields if names match for basic backward compatibility
      droughtTolerance:
          json['stress_name']?.toString().contains('Drought') == true
          ? json['severity_level']?.toString()
          : null,
      salinityTolerance:
          json['stress_name']?.toString().contains('Salinity') == true
          ? json['severity_level']?.toString()
          : null,
      waterLoggingTolerance:
          json['stress_name']?.toString().contains('Water') == true
          ? json['severity_level']?.toString()
          : null,
    );
  }

  VarietyEnvironmentalStress copyWith({
    String? stressName,
    String? severity,
    String? causes,
    String? symptoms,
    String? impactOnCrop,
    String? preventiveMeasures,
    String? droughtTolerance,
    String? salinityTolerance,
    String? waterLoggingTolerance,
  }) {
    return VarietyEnvironmentalStress(
      stressName: stressName ?? this.stressName,
      severity: severity ?? this.severity,
      causes: causes ?? this.causes,
      symptoms: symptoms ?? this.symptoms,
      impactOnCrop: impactOnCrop ?? this.impactOnCrop,
      preventiveMeasures: preventiveMeasures ?? this.preventiveMeasures,
      droughtTolerance: droughtTolerance ?? this.droughtTolerance,
      salinityTolerance: salinityTolerance ?? this.salinityTolerance,
      waterLoggingTolerance:
          waterLoggingTolerance ?? this.waterLoggingTolerance,
    );
  }
}
