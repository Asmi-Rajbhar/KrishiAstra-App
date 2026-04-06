part of 'diagnostic_bloc.dart';

abstract class DiagnosticEvent extends Equatable {
  const DiagnosticEvent();

  @override
  List<Object?> get props => [];
}

class FetchDiagnostics extends DiagnosticEvent {
  const FetchDiagnostics();

  @override
  List<Object?> get props => [];
}

class FetchDiseases extends DiagnosticEvent {
  const FetchDiseases();

  @override
  List<Object?> get props => [];
}

class FetchDiseaseList extends DiagnosticEvent {
  final String? varietyId;
  const FetchDiseaseList({this.varietyId});

  @override
  List<Object?> get props => [varietyId];
}

class FetchNutrients extends DiagnosticEvent {
  final String? varietyId;
  const FetchNutrients({this.varietyId});

  @override
  List<Object?> get props => [varietyId];
}

class FetchNutrientDetails extends DiagnosticEvent {
  final String nutrientName;
  final String? varietyId;

  const FetchNutrientDetails(this.nutrientName, {this.varietyId});

  @override
  List<Object?> get props => [nutrientName, varietyId];
}

class FetchDiseaseDetails extends DiagnosticEvent {
  final String diseaseName;
  final String? varietyId;
  const FetchDiseaseDetails(this.diseaseName, {this.varietyId});

  @override
  List<Object?> get props => [diseaseName, varietyId];
}
