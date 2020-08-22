part of 'bench_page_bloc.dart';

abstract class BenchPageState extends Equatable {
  const BenchPageState();

  @override
  List<Object> get props => [];
}

class BenchPageInitial extends BenchPageState {}

class BenchPageLoading extends BenchPageState {
  const BenchPageLoading();

  @override
  List<Object> get props => [];
}

class BenchPageInitialed extends BenchPageState {
  final UiBench benchUi;
  const BenchPageInitialed({this.benchUi});

  @override
  List<Object> get props => [benchUi];
}

class BenchPageError extends BenchPageState {
  const BenchPageError();

  @override
  List<Object> get props => [];
}
