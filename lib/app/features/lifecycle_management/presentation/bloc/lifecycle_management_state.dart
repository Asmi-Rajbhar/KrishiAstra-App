part of 'lifecycle_management_bloc.dart';

class LifecycleManagementState extends Equatable {
  final List<CropVariety> varieties;
  final List<String> availableSeasons;
  final String? selectedVariety;
  final String? selectedSeason;
  final List<CropLifecycleStage> lifecycleStages;
  final bool isLoading;
  final String? errorMessage;

  const LifecycleManagementState({
    this.varieties = const [],
    this.availableSeasons = const [],
    this.selectedVariety,
    this.selectedSeason,
    this.lifecycleStages = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  LifecycleManagementState copyWith({
    List<CropVariety>? varieties,
    List<String>? availableSeasons,
    String? selectedVariety,
    String? selectedSeason,
    List<CropLifecycleStage>? lifecycleStages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LifecycleManagementState(
      varieties: varieties ?? this.varieties,
      availableSeasons: availableSeasons ?? this.availableSeasons,
      selectedVariety: selectedVariety ?? this.selectedVariety,
      selectedSeason: selectedSeason ?? this.selectedSeason,
      lifecycleStages: lifecycleStages ?? this.lifecycleStages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    varieties,
    availableSeasons,
    selectedVariety,
    selectedSeason,
    lifecycleStages,
    isLoading,
    errorMessage,
  ];
}

class LifecycleManagementInitial extends LifecycleManagementState {}
