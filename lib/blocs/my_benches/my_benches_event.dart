part of 'my_benches_bloc.dart';

abstract class MyBenchesEvent extends Equatable {
  const MyBenchesEvent();

  @override
  List<Object> get props => [];
}

class GetMyBenchesEvent extends MyBenchesEvent {
  const GetMyBenchesEvent();

  @override
  List<Object> get props => [];
}
