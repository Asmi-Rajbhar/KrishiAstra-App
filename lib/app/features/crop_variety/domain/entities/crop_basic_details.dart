import 'package:equatable/equatable.dart';

class CropBasicDetails extends Equatable {
  final String cropName;
  final String description;
  final num maturityTime;
  final num revenue;
  final String waterIntensive;
  final String climateNeeds;

  const CropBasicDetails({
    required this.cropName,
    required this.description,
    required this.maturityTime,
    required this.revenue,
    required this.waterIntensive,
    required this.climateNeeds,
  });

  @override
  List<Object?> get props => [
    cropName,
    description,
    maturityTime,
    revenue,
    waterIntensive,
    climateNeeds,
  ];
}
