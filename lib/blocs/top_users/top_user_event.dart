part of 'top_user_bloc.dart';

abstract class TopUserEvent extends Equatable {
  const TopUserEvent();

  @override
  List<Object> get props => [];
}

class GetTopUserEvent extends TopUserEvent {
  const GetTopUserEvent();

  @override
  List<Object> get props => [];
}
