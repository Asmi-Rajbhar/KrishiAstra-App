import 'package:krishiastra/app/core/network/api_constants.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/disease.dart';

class DiseaseMapper {
  static Disease mapToEntity(Map<String, dynamic> json) {
    List<Remedy> remediesList = [];

    final rawRemedies = json['remedies'];
    if (rawRemedies is Map) {
      remediesList = rawRemedies.entries.map((entry) {
        final val = entry.value as Map<String, dynamic>;
        return Remedy(
          id: entry.key,
          preventiveMeasures: val['preventive_measures']?.toString() ?? '',
          biologicalControl: val['biological_control']?.toString() ?? '',
          chemicalControl: val['chemical_control']?.toString() ?? '',
        );
      }).toList();
    } else if (rawRemedies is List) {
      remediesList = rawRemedies.map((item) {
        if (item is Map<String, dynamic>) {
          return Remedy(
            id: (item['name'] ?? item['id'] ?? '').toString(),
            preventiveMeasures: item['preventive_measures']?.toString() ?? '',
            biologicalControl: item['biological_control']?.toString() ?? '',
            chemicalControl: item['chemical_control']?.toString() ?? '',
          );
        }
        return const Remedy(
          id: '',
          preventiveMeasures: '',
          biologicalControl: '',
          chemicalControl: '',
        );
      }).toList();
    }

    return Disease(
      name: json['disease']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      symptoms: json['symptoms']?.toString() ?? '',
      remedies: remediesList,
      details: json['disease_pest_detail'] is List
          ? List<String>.from(json['disease_pest_detail'])
          : [],
      imageUrl: json['image'] != null && json['image'].toString().isNotEmpty
          ? (json['image'].toString().startsWith('http')
                ? json['image'].toString()
                : '${ApiConstants.baseUrl}${json['image']}')
          : '',
      severity: json['severity_level']?.toString() ?? '',
    );
  }
}
