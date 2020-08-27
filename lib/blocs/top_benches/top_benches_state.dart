part of 'top_benches_bloc.dart';

abstract class TopBenchesState extends Equatable {
  const TopBenchesState();

  @override
  List<Object> get props => [];
}

class TopBenchesInitial extends TopBenchesState {}

class TopBenchesPageLoading extends TopBenchesState {
  const TopBenchesPageLoading();

  @override
  List<Object> get props => [];
}

class TopBenchesPageInitialed extends TopBenchesState {
  final List<UIBencCard> benchCard;
  const TopBenchesPageInitialed({this.benchCard});

  @override
  List<Object> get props => [];
}

class TopBenchesPageError extends TopBenchesState {
  const TopBenchesPageError();

  @override
  List<Object> get props => [];
}
