part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class ButtonGetCurrentLocationPassedEvent extends MapEvent {
  const ButtonGetCurrentLocationPassedEvent();
  @override
  List<Object> get props => [];

  @override
  String toString() => "ButtonGetCurrentLocationPass {}";
}

class MapGetCurrentLocationUpdatingEvent extends MapEvent {
  const MapGetCurrentLocationUpdatingEvent();

  @override
  List<Object> get props => [];

  @override
  String toString() => "MapGetCurrentLocationEvent ";
}

class MapMarkerInitialing extends MapEvent {
  const MapMarkerInitialing();

  List<Object> get props => [];

  @override
  String toString() => "MapMarkerInitialing {}";
}

class MapMarkerInitialedStop extends MapEvent {
  final Map<MarkerId, Marker> markers;

  const MapMarkerInitialedStop({this.markers});
  List<Object> get props => [markers];

  @override
  String toString() => "MapMarkerInitialing {$markers}";
}

class MapMarkerPressedEvent extends MapEvent {
  final String markerId;
  final List<MapMarker> markers;
  const MapMarkerPressedEvent({this.markerId, this.markers});

  List<Object> get props => [markerId, markers];

  @override
  String toString() =>
      "MapMarkerPressedEvent {markerId: $markerId, markers: $markers}";
}

class LikeButtonPassEvent extends MapEvent {
  final MapMarker marker;
  const LikeButtonPassEvent({this.marker});

  @override
  List<Object> get props => [marker];
}

class LikeUpdatingEvent extends MapEvent {
  const LikeUpdatingEvent();

  @override
  List<Object> get props => [];
}
