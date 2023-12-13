import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:starwars/logics/load_logic.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LoadDataLogic logic;

  HomeBloc({required this.logic}) : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is LoadDataEvent){
      yield LoadingDataState();
      try {
        final String fetchUrl = "https://swapi.dev/api/people/";
        var data = await logic.loadData(fetchUrl);
        
        yield LoadedDataState(data);
      } on LoadDataException {
        yield ErrorLoadingDataState("Error al obtener los Personajes");
      }
    }
  }
}