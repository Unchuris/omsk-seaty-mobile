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
  final Map<String, Marker> markers;
  const MapMarkerInitialedStop({this.markers});

  List<Object> get props => [markers];

  @override
  String toString() => "MapMarkerInitialing {}";
}

class MapMarkerPressedEvent extends MapEvent {
  final String markerId;
  final int index;
  const MapMarkerPressedEvent(this.markerId, this.index);

  List<Object> get props => [markerId, index];

  @override
  String toString() =>
      "MapMarkerPressedEvent {markerId: $markerId, index: $index}";
}
