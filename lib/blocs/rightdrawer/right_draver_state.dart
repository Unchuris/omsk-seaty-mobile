part of 'right_draver_bloc.dart';

abstract class RightDraverState extends Equatable {
  const RightDraverState();

  @override
  List<Object> get props => [];
}

class RightDraverInitial extends RightDraverState {
  final Map<String, bool> checkBox;
  const RightDraverInitial({this.checkBox});
  @override
  List<Object> get props => [checkBox];
  @override
  String toString() => "OnFilterTapingState {checkBox: $checkBox, }";
}

class OnFilterTapingState extends RightDraverState {
  final Map<String, bool> checkBox;
  const OnFilterTapingState({this.checkBox});

  @override
  List<Object> get props => [checkBox];
  @override
  String toString() => "OnFilterTapingState {checkBox: $checkBox, }";
}

class OnFilterTapedState extends RightDraverState {
  const OnFilterTapedState();

  @override
  List<Object> get props => [];
  @override
  String toString() => "OnFilterTapedState { }";
}
