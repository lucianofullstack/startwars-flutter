part of 'mode_bloc.dart';

abstract class ModeEvent extends Equatable {
  const ModeEvent();

  @override
  List<Object> get props => [];
}

class LoadDataEvent extends ModeEvent {
  LoadDataEvent();
}

class SetDataEvent extends ModeEvent {
  SetDataEvent();
}