class Nutrient {
  final String nutrient;
  final String description;
  final String image;
  final String? symptoms;
  final String? causeOfDeficiency;
  final NutrientVideo? video;
  final List<NutrientRemedy>? remedies;

  const Nutrient({
    required this.nutrient,
    required this.description,
    required this.image,
    this.symptoms,
    this.causeOfDeficiency,
    this.video,
    this.remedies,
  });

  factory Nutrient.fromJson(Map<String, dynamic> json) {
    return Nutrient(
      nutrient:
          json['nutrient']?.toString() ??
          json['name']?.toString() ??
          json['nutrient_name']?.toString() ??
          json['title']?.toString() ??
          '',
      description:
          json['description']?.toString() ??
          json['desc']?.toString() ??
          json['introduction']?.toString() ??
          json['summary']?.toString() ??
          '',
      image: json['image']?.toString() ?? '',
      symptoms: json['symptoms']?.toString(),
      causeOfDeficiency: json['cause_of_deficiency']?.toString(),
      video: json['video'] != null
          ? NutrientVideo.fromJson(json['video'])
          : null,
      remedies: json['remedies'] != null
          ? (json['remedies'] as List)
                .map((e) => NutrientRemedy.fromJson(e))
                .toList()
          : null,
    );
  }

  Nutrient copyWith({
    String? nutrient,
    String? description,
    String? image,
    String? symptoms,
    String? causeOfDeficiency,
    NutrientVideo? video,
    List<NutrientRemedy>? remedies,
  }) {
    return Nutrient(
      nutrient: nutrient ?? this.nutrient,
      description: description ?? this.description,
      image: image ?? this.image,
      symptoms: symptoms ?? this.symptoms,
      causeOfDeficiency: causeOfDeficiency ?? this.causeOfDeficiency,
      video: video ?? this.video,
      remedies: remedies ?? this.remedies,
    );
  }
}

class NutrientVideo {
  final String title;
  final String url;
  final String duration;
  final String? description;

  const NutrientVideo({
    required this.title,
    required this.url,
    required this.duration,
    this.description,
  });

  factory NutrientVideo.fromJson(Map<String, dynamic> json) {
    return NutrientVideo(
      title: json['title']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      description: json['description']?.toString(),
    );
  }

  NutrientVideo copyWith({
    String? title,
    String? url,
    String? duration,
    String? description,
  }) {
    return NutrientVideo(
      title: title ?? this.title,
      url: url ?? this.url,
      duration: duration ?? this.duration,
      description: description ?? this.description,
    );
  }
}

class NutrientRemedy {
  final String? preventiveMeasures;
  final String? biologicalControl;
  final String? chemicalControl;

  const NutrientRemedy({
    this.preventiveMeasures,
    this.biologicalControl,
    this.chemicalControl,
  });

  factory NutrientRemedy.fromJson(Map<String, dynamic> json) {
    return NutrientRemedy(
      preventiveMeasures: json['preventive_measures']?.toString(),
      biologicalControl: json['biological_control']?.toString(),
      chemicalControl: json['chemical_control']?.toString(),
    );
  }

  NutrientRemedy copyWith({
    String? preventiveMeasures,
    String? biologicalControl,
    String? chemicalControl,
  }) {
    return NutrientRemedy(
      preventiveMeasures: preventiveMeasures ?? this.preventiveMeasures,
      biologicalControl: biologicalControl ?? this.biologicalControl,
      chemicalControl: chemicalControl ?? this.chemicalControl,
    );
  }
}
