import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:krishiastra/app/features/home/domain/entities/crop_card_entity.dart';
import 'package:krishiastra/app/features/home/domain/repositories/i_home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IHomeRepository homeRepository;

  HomeBloc({required this.homeRepository}) : super(HomeInitial()) {
    on<FetchHomeCrops>((event, emit) async {
      emit(HomeLoading());
      try {
        final crops = await homeRepository.getHomeCrops();
        emit(HomeLoaded(crops));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}
