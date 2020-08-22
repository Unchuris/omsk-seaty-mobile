part of 'bench_page_bloc.dart';

abstract class BenchPageEvent extends Equatable {
  const BenchPageEvent();

  @override
  List<Object> get props => [];
}

class GetBenchEvent extends BenchPageEvent {
  final String benchId;
  const GetBenchEvent({this.benchId});

  @override
  List<Object> get props => [benchId];
}
