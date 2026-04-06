import 'package:flutter/foundation.dart';

/// Domain entity representing the climatic requirements for a crop.
/// This is a pure data class used by the UI and Business Logic layer.
@immutable
class ClimaticRequirement {
  /// Name of the crop (e.g., Sugarcane)
  final String cropName;

  /// Temperature requirements
  final TemperatureSection temperature;

  /// Rainfall requirements
  final RainfallSection rainfall;

  /// Sunlight requirements
  final SunlightSection sunlight;

  /// Humidity requirements
  final HumiditySection humidity;

  /// Wind requirements
  final WindSection wind;

  const ClimaticRequirement({
    required this.cropName,
    required this.temperature,
    required this.rainfall,
    required this.sunlight,
    required this.humidity,
    required this.wind,
  });

  ClimaticRequirement copyWith({
    String? cropName,
    TemperatureSection? temperature,
    RainfallSection? rainfall,
    SunlightSection? sunlight,
    HumiditySection? humidity,
    WindSection? wind,
  }) {
    return ClimaticRequirement(
      cropName: cropName ?? this.cropName,
      temperature: temperature ?? this.temperature,
      rainfall: rainfall ?? this.rainfall,
      sunlight: sunlight ?? this.sunlight,
      humidity: humidity ?? this.humidity,
      wind: wind ?? this.wind,
    );
  }
}

/// Represents the temperature-related requirements.
@immutable
class TemperatureSection {
  /// Range for optimal growth
  final String optimalGrowth;

  /// Range for germination phase
  final String germinationGrowth;

  /// Description of conditions that are not optimal
  final String nonOptimal;

  const TemperatureSection({
    required this.optimalGrowth,
    required this.germinationGrowth,
    required this.nonOptimal,
  });

  TemperatureSection copyWith({
    String? optimalGrowth,
    String? germinationGrowth,
    String? nonOptimal,
  }) {
    return TemperatureSection(
      optimalGrowth: optimalGrowth ?? this.optimalGrowth,
      germinationGrowth: germinationGrowth ?? this.germinationGrowth,
      nonOptimal: nonOptimal ?? this.nonOptimal,
    );
  }
}

/// Represents the rainfall and water requirements.
@immutable
class RainfallSection {
  /// Total annual rainfall needed
  final String annualRequirement;

  /// Detailed description of rainfall distribution
  final String description;

  /// Specific advice for different growth stages
  final String advice;

  const RainfallSection({
    required this.annualRequirement,
    required this.description,
    required this.advice,
  });

  RainfallSection copyWith({
    String? annualRequirement,
    String? description,
    String? advice,
  }) {
    return RainfallSection(
      annualRequirement: annualRequirement ?? this.annualRequirement,
      description: description ?? this.description,
      advice: advice ?? this.advice,
    );
  }
}

/// Represents the sunlight and sunshine duration requirements.
@immutable
class SunlightSection {
  /// Daily sunshine hours required
  final String requiresBrightSunshine;

  /// General description of sunlight impact
  final String description;

  const SunlightSection({
    required this.requiresBrightSunshine,
    required this.description,
  });

  SunlightSection copyWith({
    String? requiresBrightSunshine,
    String? description,
  }) {
    return SunlightSection(
      requiresBrightSunshine:
          requiresBrightSunshine ?? this.requiresBrightSunshine,
      description: description ?? this.description,
    );
  }
}

/// Represents the relative humidity requirements.
@immutable
class HumiditySection {
  /// Humidity levels needed during the growth phase
  final String growth;

  /// Humidity levels needed during the maturity/ripening phase
  final String maturity;

  const HumiditySection({required this.growth, required this.maturity});

  HumiditySection copyWith({String? growth, String? maturity}) {
    return HumiditySection(
      growth: growth ?? this.growth,
      maturity: maturity ?? this.maturity,
    );
  }
}

/// Represents the wind speed requirements.
@immutable
class WindSection {
  /// Optimal or safe wind speed range
  final String speed;

  const WindSection({required this.speed});

  WindSection copyWith({String? speed}) {
    return WindSection(speed: speed ?? this.speed);
  }
}
