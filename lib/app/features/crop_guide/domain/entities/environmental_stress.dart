import 'package:equatable/equatable.dart';

class EnvironmentalStress extends Equatable {
  final String stressName;
  final String stressType;
  final String severityLevel;
  final String causes;
  final String symptoms;
  final String impactOnCrop;
  final String preventiveMeasures;

  const EnvironmentalStress({
    required this.stressName,
    required this.stressType,
    required this.severityLevel,
    required this.causes,
    required this.symptoms,
    required this.impactOnCrop,
    required this.preventiveMeasures,
  });

  factory EnvironmentalStress.fromJson(Map<String, dynamic> json) {
    return EnvironmentalStress(
      stressName: json['stress_name']?.toString() ?? '',
      stressType: json['stress_type']?.toString() ?? '',
      severityLevel: json['severity_level']?.toString() ?? '',
      causes: json['causes']?.toString() ?? '',
      symptoms: json['symptoms']?.toString() ?? '',
      impactOnCrop: json['impact_on_crop']?.toString() ?? '',
      preventiveMeasures: json['preventive_measures']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [
    stressName,
    stressType,
    severityLevel,
    causes,
    symptoms,
    impactOnCrop,
    preventiveMeasures,
  ];
}
