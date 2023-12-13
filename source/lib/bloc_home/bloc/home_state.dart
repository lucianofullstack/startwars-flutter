part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class LoadingDataState extends HomeState {

}

class LoadedDataState extends HomeState {
  final List data;
  LoadedDataState(this.data);
}

class ErrorLoadingDataState extends HomeState {
  final String message;
  ErrorLoadingDataState(this.message);
}
