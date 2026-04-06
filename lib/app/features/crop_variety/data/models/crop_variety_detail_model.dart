import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety_detail.dart';

class CropVarietyDetailModel {
  final String name;
  final String? yield;
  final String? maturityTime;
  final String? plantationMethod;
  final String? expertRecommendation;
  final List<dynamic>? plantationMonths;
  final Map<String, dynamic>? environmentalStress;
  final Map<String, dynamic>? weedManagement;
  final List<dynamic>? fertilizerSchedule;
  final dynamic cropDiseases;
  final dynamic cropPreventionPestDetails;
  final dynamic cropNutrient;
  final String? sucrose;
  final String? resistanceToDiseases;
  final String? soilTypes;
  final String? cropSeason;
  final String? parentage;

  CropVarietyDetailModel({
    required this.name,
    this.yield,
    this.maturityTime,
    this.plantationMethod,
    this.expertRecommendation,
    this.plantationMonths,
    this.environmentalStress,
    this.weedManagement,
    this.fertilizerSchedule,
    this.cropDiseases,
    this.cropPreventionPestDetails,
    this.cropNutrient,
    this.sucrose,
    this.resistanceToDiseases,
    this.soilTypes,
    this.cropSeason,
    this.parentage,
  });

  factory CropVarietyDetailModel.fromJson(
    String name,
    Map<String, dynamic> json,
  ) {
    return CropVarietyDetailModel(
      name: name,
      yield: json['yield']?.toString(),
      maturityTime: json['maturity_time']?.toString(),
      plantationMethod: json['plantation_method']?.toString(),
      expertRecommendation: json['expert_recommendation']?.toString(),
      plantationMonths: json['plantation_months'],
      environmentalStress: json['environmental_stress'],
      weedManagement: json['weed_management'],
      fertilizerSchedule: json['fertilizer_and_micronutrient_schedule'],
      cropDiseases: json['crop_diseases'],
      cropPreventionPestDetails: json['crop_prevention_pest_details'],
      cropNutrient: json['crop_nutrient'],
      sucrose: json['sucrose']?.toString(),
      resistanceToDiseases: json['resistance_to_diseases']?.toString(),
      soilTypes: json['soil_types']?.toString(),
      cropSeason: json['crop_season']?.toString(),
      parentage: json['parentage']?.toString(),
    );
  }

  CropVarietyDetail toEntity() {
    return CropVarietyDetail(
      name: name,
      expectedYield: yield,
      maturityTime: maturityTime,
      plantationMethod: plantationMethod,
      expertRecommendation: expertRecommendation,
      plantationMonths: _safeList<String>(plantationMonths),
      environmentalStress: environmentalStress != null
          ? VarietyEnvironmentalStress.fromJson(environmentalStress!)
          : null,
      weedManagement: weedManagement != null
          ? WeedManagement(
              name: weedManagement!['name']?.toString() ?? '',
              type:
                  (weedManagement!['weeds_type']
                          as Map<String, dynamic>?)?['weed_types']
                      ?.toString() ??
                  '',
              solution:
                  weedManagement!['weed_management_solution']?.toString() ?? '',
            )
          : null,
      fertilizerSchedule: (fertilizerSchedule ?? []).map((e) {
        final map = e is Map<String, dynamic> ? e : const <String, dynamic>{};
        return FertilizerSchedule(
          growthStage: map['growth_stage']?.toString() ?? '',
          doseStage: map['dose_stage']?.toString() ?? '',
          recommendedNutrient: map['recommended_nutrient']?.toString() ?? '',
        );
      }).toList(),
      diseases: _mapSimpleList(cropDiseases, 'disease'),
      pests: _mapSimpleList(cropPreventionPestDetails, 'pest'),
      nutrients: _mapSimpleList(cropNutrient, 'nutrient'),
      sucrosePercentage: sucrose,
      diseaseResistance: resistanceToDiseases,
      recommendedSoilType: soilTypes,
      season: cropSeason,
      parentage: parentage,
    );
  }

  List<T> _safeList<T>(dynamic list) {
    if (list is List) {
      return list.map((e) => e.toString() as T).toList();
    }
    return [];
  }

  List<String> _mapSimpleList(dynamic list, String key) {
    if (list is List) {
      return list.map((e) {
        if (e is Map) {
          return e[key]?.toString() ?? '';
        }
        return e.toString();
      }).toList();
    }
    return [];
  }
}
