part of 'right_draver_bloc.dart';

abstract class RightDraverState extends Equatable {
  const RightDraverState();

  @override
  List<Object> get props => [];
}

class RightDraverInitial extends RightDraverState {}

class OnFilterTapState extends RightDraverState {
  final Map<String, bool> checkBox;
  const OnFilterTapState({this.checkBox});

  @override
  List<Object> get props => [checkBox];
}
