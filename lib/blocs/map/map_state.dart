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
  final Map<MarkerId, Marker> markers;
  const MarkersInitialed({this.markers});

  @override
  List<Object> get props => [markers];

  @override
  String toString() => "MarkersInitialed markers: {$markers}";
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
      "MapCurrentLocationUpdatedState {position: ${position.toString()}";
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
  final MapMarker marker;
  const MapMarkerPressedState({this.markerId, this.marker});

  List<Object> get props => [markerId, marker];

  @override
  String toString() =>
      "MapMarkerPressedState {markerId: $markerId, marker: $marker}";
}

class MapTapState extends MapState {
  const MapTapState();

  @override
  List<Object> get props => [];
  String toString() => "MapTapState {}";
}
