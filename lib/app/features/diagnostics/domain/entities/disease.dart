class Disease {
  final String name;
  final String description;
  final String symptoms;
  final List<Remedy> remedies;
  final List<String> details; // From disease_pest_detail
  final String? imageUrl;
  final String? severity;

  const Disease({
    required this.name,
    required this.description,
    required this.symptoms,
    required this.remedies,
    required this.details,
    this.imageUrl,
    this.severity,
  });

  factory Disease.empty() => const Disease(
    name: '',
    description: '',
    symptoms: '',
    remedies: [],
    details: [],
    imageUrl: '',
    severity: '',
  );

  Disease copyWith({
    String? name,
    String? description,
    String? symptoms,
    List<Remedy>? remedies,
    List<String>? details,
    String? imageUrl,
    String? severity,
  }) {
    return Disease(
      name: name ?? this.name,
      description: description ?? this.description,
      symptoms: symptoms ?? this.symptoms,
      remedies: remedies ?? this.remedies,
      details: details ?? this.details,
      imageUrl: imageUrl ?? this.imageUrl,
      severity: severity ?? this.severity,
    );
  }
}

class Remedy {
  final String id;
  final String preventiveMeasures;
  final String biologicalControl;
  final String chemicalControl;

  const Remedy({
    required this.id,
    required this.preventiveMeasures,
    required this.biologicalControl,
    required this.chemicalControl,
  });
}
