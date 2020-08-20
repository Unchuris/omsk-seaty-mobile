part of 'right_draver_bloc.dart';

abstract class RightDraverEvent extends Equatable {
  const RightDraverEvent();

  @override
  List<Object> get props => [];
}

class RightDraverInitialingEvent extends RightDraverEvent {
  final Map<String, bool> checkBox;
  const RightDraverInitialingEvent({this.checkBox});

  @override
  List<Object> get props => [checkBox];
}

class OnFilterTapedEvent extends RightDraverEvent {
  const OnFilterTapedEvent();

  @override
  List<Object> get props => [];
}

class OnFilterTapingEvent extends RightDraverEvent {
  final String title;
  final bool isTaped;
  const OnFilterTapingEvent({this.title, this.isTaped});

  @override
  List<Object> get props => [title, isTaped];
}
