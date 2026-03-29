part of 'diagnostic_bloc.dart';

enum DiagnosticStatus { initial, loading, loaded, error }

class DiagnosticState extends Equatable {
  final List<DiagnosticCategory> diagnostics;
  final List<Disease> diseases;
  final List<Nutrient> nutrients;
  final Disease? selectedDisease;
  final Nutrient? selectedNutrient;
  final DiagnosticStatus status;
  final String? error;

  const DiagnosticState({
    this.diagnostics = const [],
    this.diseases = const [],
    this.nutrients = const [],
    this.selectedDisease,
    this.selectedNutrient,
    this.status = DiagnosticStatus.initial,
    this.error,
  });

  DiagnosticState copyWith({
    List<DiagnosticCategory>? diagnostics,
    List<Disease>? diseases,
    List<Nutrient>? nutrients,
    Disease? selectedDisease,
    Nutrient? selectedNutrient,
    DiagnosticStatus? status,
    String? error,
  }) {
    return DiagnosticState(
      diagnostics: diagnostics ?? this.diagnostics,
      diseases: diseases ?? this.diseases,
      nutrients: nutrients ?? this.nutrients,
      selectedDisease: selectedDisease ?? this.selectedDisease,
      selectedNutrient: selectedNutrient ?? this.selectedNutrient,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    diagnostics,
    diseases,
    nutrients,
    selectedDisease,
    selectedNutrient,
    status,
    error,
  ];
}
