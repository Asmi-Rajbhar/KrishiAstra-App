part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchHomeCrops extends HomeEvent {
  const FetchHomeCrops();

  @override
  List<Object?> get props => [];
}
