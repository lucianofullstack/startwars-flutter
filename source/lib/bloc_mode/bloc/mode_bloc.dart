import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:starwars/repositories/mode_respository.dart';

part 'mode_event.dart';
part 'mode_state.dart';

class ModeBloc extends Bloc<ModeEvent, ModeState> {
  final ModeRepository repository;
  ModeBloc({required this.repository}) : super(ModeInitial());

  @override
  Stream<ModeState> mapEventToState(
    ModeEvent event,
  ) async* {
    if (event is LoadDataEvent){
      yield LoadedDataState(repository.get());
    }
    if (event is SetDataEvent){
      repository.toggleMode();
      yield SettedDataState();
    }
  }
}
