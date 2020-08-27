part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();
}

class MapInitial extends MapState {
  const MapInitial();
  @override
  List<Object> get props => [];
}

class MarkersInitial extends MapState {
  const MarkersInitial();
  @override
  List<Object> get props => [];
}

class LoadDataFailture extends MapState {
  final String message;
  const LoadDataFailture({this.message});
  @override
  List<Object> get props => [message];
}

class FindButtonPressingState extends MapState {
  final Map<String, bool> checkBox;
  const FindButtonPressingState({this.checkBox});

  List<Object> get props => [checkBox];

  @override
  String toString() => "FindButtonPressingState { }";
}

class FindButtonPressedState extends MapState {
  const FindButtonPressedState();

  List<Object> get props => [];

  @override
  String toString() => "FindButtonPressedState { }";
}
