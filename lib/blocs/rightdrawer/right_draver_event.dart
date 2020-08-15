part of 'right_draver_bloc.dart';

abstract class RightDraverEvent extends Equatable {
  const RightDraverEvent();

  @override
  List<Object> get props => [];
}

class OnFilterTapEvent extends RightDraverEvent {
  final String title;
  final bool isTaped;
  const OnFilterTapEvent({this.title, this.isTaped});

  @override
  List<Object> get props => [title, isTaped];
}
