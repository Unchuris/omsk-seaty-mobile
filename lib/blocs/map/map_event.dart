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
  final MapMarker marker;
  const MapMarkerPressedEvent({this.markerId, this.marker});

  List<Object> get props => [markerId, marker];

  @override
  String toString() =>
      "MapMarkerPressedEvent {markerId: $markerId, marker: $marker}";
}

class MapTapEvent extends MapEvent {
  const MapTapEvent();

  @override
  List<Object> get props => [];
  @override
  String toString() => "MapTapEvent {}";
}
