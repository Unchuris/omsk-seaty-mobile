part of 'top_benches_bloc.dart';

abstract class TopBenchesEvent extends Equatable {
  const TopBenchesEvent();

  @override
  List<Object> get props => [];
}

class GetTopBenchesEvent extends TopBenchesEvent {
  const GetTopBenchesEvent();

  @override
  List<Object> get props => [];
}
