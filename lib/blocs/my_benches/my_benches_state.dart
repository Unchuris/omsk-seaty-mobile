part of 'my_benches_bloc.dart';

abstract class MyBenchesState extends Equatable {
  const MyBenchesState();

  @override
  List<Object> get props => [];
}

class MyBenchesInitial extends MyBenchesState {}

class MyBenchesPageLoading extends MyBenchesState {
  const MyBenchesPageLoading();

  @override
  List<Object> get props => [];
}

class MyBenchesPageInitialed extends MyBenchesState {
  final List<UiMyBench> benchCard;
  const MyBenchesPageInitialed({this.benchCard});

  @override
  List<Object> get props => [];
}

class MyBenchesPageError extends MyBenchesState {
  const MyBenchesPageError();

  @override
  List<Object> get props => [];
}

class MyBenchesPage403Error extends MyBenchesState {
  const MyBenchesPage403Error();

  @override
  List<Object> get props => [];
}
