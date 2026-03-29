part of 'lifecycle_management_bloc.dart';

abstract class LifecycleManagementEvent extends Equatable {
  const LifecycleManagementEvent();

  @override
  List<Object?> get props => [];
}

class FetchLifecycleStages extends LifecycleManagementEvent {
  const FetchLifecycleStages();

  @override
  List<Object?> get props => [];
}

class InitializeLifecycleData extends LifecycleManagementEvent {
  final String variety;
  final String? season;
  final String? cropName;
  const InitializeLifecycleData({
    required this.variety,
    this.season,
    this.cropName,
  });

  @override
  List<Object?> get props => [variety, season, cropName];
}

class OnSelectionChanged extends LifecycleManagementEvent {
  final String variety;
  const OnSelectionChanged(this.variety);

  @override
  List<Object?> get props => [variety];
}

class OnSeasonChanged extends LifecycleManagementEvent {
  final String season;
  const OnSeasonChanged(this.season);

  @override
  List<Object?> get props => [season];
}

class FetchCropLifecycleStagesEvent extends LifecycleManagementEvent {
  final String cropName;
  const FetchCropLifecycleStagesEvent(this.cropName);

  @override
  List<Object?> get props => [cropName];
}
