// lib/models/prediction_result.dart

class PredictionResult {
  final String diseaseName;
  final double confidence;
  final bool isHealthy;

  PredictionResult({
    required this.diseaseName,
    required this.confidence,
    required this.isHealthy,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      diseaseName: json['disease_name'],
      confidence: (json['confidence'] as num).toDouble(),
      isHealthy: json['is_healthy'],
    );
  }
}
