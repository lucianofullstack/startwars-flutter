part of 'mode_bloc.dart';

abstract class ModeState extends Equatable {
  const ModeState();
  
  @override
  List<Object> get props => [];
}

class ModeInitial extends ModeState {}

class LoadingDataState extends ModeState {
}

class LoadedDataState extends ModeState {
  final bool mode;
  LoadedDataState(this.mode);
}

class SettedDataState extends ModeState {
}

