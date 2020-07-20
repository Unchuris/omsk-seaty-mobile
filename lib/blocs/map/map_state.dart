part of 'map_bloc.dart';

/* Все отхваченные состояние на странице с картой можно получать в контексте значение props*/

abstract class MapState extends Equatable {
  const MapState();
}

class MapInitial extends MapState {
  @override
  List<Object> get props => [];
}

class MarkersInitial extends MapState {
  const MarkersInitial();
  @override
  List<Object> get props => [];
  @override
  String toString() => "MarkersInitial";
}

class MarkersInitialed extends MapState {
  final List<Benches> benches;

  const MarkersInitialed({this.benches});
  @override
  List<Object> get props => [benches];

  @override
  String toString() => "MarkersInitialed benches: {$benches}";
}

class MapCurrentLocationUpdatingState extends MapState {
  const MapCurrentLocationUpdatingState();

  List<Object> get props => [];

  @override
  String toString() => "MapCurrentLocationUpdatingState";
}

class MapCurrentLocationUpdatedState extends MapState {
  final Position position;
  const MapCurrentLocationUpdatedState({this.position});

  List<Object> get props => [position];

  @override
  String toString() =>
      "MapCurrentLocationUpdatedState {position: ${position.toJson()}";
}

class MapErrorState extends MapState {
  final String message;

  const MapErrorState(this.message);

  List<Object> get props => [message];

  @override
  String toString() => "MapNotGrantedPermissionState {message: $message}";
}

class MapMarkerPressedState extends MapState {
  final String markerId;
  final int index;
  const MapMarkerPressedState(this.markerId, this.index);

  List<Object> get props => [markerId, index];

  @override
  String toString() =>
      "MapMarkerPressedState {markerId: $markerId, index: $index}";
}
