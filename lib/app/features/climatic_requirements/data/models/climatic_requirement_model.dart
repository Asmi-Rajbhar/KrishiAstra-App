import 'package:krishiastra/app/features/climatic_requirements/domain/entities/climatic_model.dart';

/// Data model for Climatic Requirements.
/// This class extends the [ClimaticRequirement] entity and adds JSON parsing capabilities.
/// It acts as the bridge between raw API data and the domain entity.
class ClimaticRequirementModel extends ClimaticRequirement {
  const ClimaticRequirementModel({
    required super.cropName,
    required super.temperature,
    required super.rainfall,
    required super.sunlight,
    required super.humidity,
    required super.wind,
  });

  /// Factory constructor to create a [ClimaticRequirementModel] from a JSON map.
  /// Standardizes data extraction from the Frappe/ERPNext API structure.
  factory ClimaticRequirementModel.fromJson(
    Map<String, dynamic> json, {
    String cropName = '',
  }) {
    // Extracting nested sections with fallback and normalization
    final temp = _asMap(json['temperature']);
    final rain = _asMap(json['rainfall']);
    final sun = _asMap(json['sunlight']);
    final hum = _asMap(json['humidity']);
    final w = _asMap(json['wind']);

    return ClimaticRequirementModel(
      cropName: cropName,
      temperature: TemperatureSectionModel.fromJson(temp),
      rainfall: RainfallSectionModel.fromJson(rain),
      sunlight: SunlightSectionModel.fromJson(sun),
      humidity: HumiditySectionModel.fromJson(hum),
      wind: WindSectionModel.fromJson(w),
    );
  }

  /// Helper to ensure we always have a Map even if the field is a List or null.
  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is List && value.isNotEmpty && value[0] is Map<String, dynamic>) {
      return value[0] as Map<String, dynamic>;
    }
    return {};
  }
}

/// Data model implementation for [TemperatureSection].
class TemperatureSectionModel extends TemperatureSection {
  const TemperatureSectionModel({
    required super.optimalGrowth,
    required super.germinationGrowth,
    required super.nonOptimal,
  });

  /// Parses temperature data from JSON with default values for missing fields.
  factory TemperatureSectionModel.fromJson(Map<String, dynamic> json) {
    return TemperatureSectionModel(
      optimalGrowth: json['optimal_growth'] ?? '',
      germinationGrowth: json['germination_growth'] ?? '',
      nonOptimal: json['non_optimal'] ?? '',
    );
  }
}

/// Data model implementation for [RainfallSection].
class RainfallSectionModel extends RainfallSection {
  const RainfallSectionModel({
    required super.annualRequirement,
    required super.description,
    required super.advice,
  });

  /// Parses rainfall data from JSON with default values for missing fields.
  factory RainfallSectionModel.fromJson(Map<String, dynamic> json) {
    return RainfallSectionModel(
      annualRequirement: json['annual_requirement'] ?? '',
      description: json['description'] ?? '',
      advice: json['advice'] ?? '',
    );
  }
}

/// Data model implementation for [SunlightSection].
class SunlightSectionModel extends SunlightSection {
  const SunlightSectionModel({
    required super.requiresBrightSunshine,
    required super.description,
  });

  /// Parses sunlight data from JSON with default values for missing fields.
  factory SunlightSectionModel.fromJson(Map<String, dynamic> json) {
    return SunlightSectionModel(
      requiresBrightSunshine: json['requirement'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

/// Data model implementation for [HumiditySection].
class HumiditySectionModel extends HumiditySection {
  const HumiditySectionModel({required super.growth, required super.maturity});

  /// Parses humidity data from JSON with default values for missing fields.
  factory HumiditySectionModel.fromJson(Map<String, dynamic> json) {
    return HumiditySectionModel(
      growth: json['during_growth'] ?? '',
      maturity: json['during_maturity'] ?? '',
    );
  }
}

/// Data model implementation for [WindSection].
class WindSectionModel extends WindSection {
  const WindSectionModel({required super.speed});

  /// Parses wind data from JSON with default values for missing fields.
  factory WindSectionModel.fromJson(Map<String, dynamic> json) {
    return WindSectionModel(speed: json['speed'] ?? '');
  }
}
