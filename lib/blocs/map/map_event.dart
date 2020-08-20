part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class MarkersLoading extends MapEvent {
  const MarkersLoading();
  @override
  List<Object> get props => [];
}

class OnMapLocationButtonClickedEvent extends MapEvent {
  const OnMapLocationButtonClickedEvent();

  @override
  List<Object> get props => [];
}

class OnMapCreatedEvent extends MapEvent {
  const OnMapCreatedEvent();

  @override
  List<Object> get props => [];
}

class OnFilterChangedEvent extends MapEvent {
  final List<BenchType> benchTypes;
  const OnFilterChangedEvent({this.benchTypes});

  @override
  List<Object> get props => [benchTypes];
}

class OnBenchClickedEvent extends MapEvent {
  final String benchId;
  const OnBenchClickedEvent({this.benchId});

  @override
  List<Object> get props => [benchId];
}

class OnBenchSliderPageChanged extends MapEvent {
  final BenchLight bench;
  const OnBenchSliderPageChanged({this.bench});

  @override
  List<Object> get props => [bench];
}

class OnLikeClickedEvent extends MapEvent {
  final String markerId;
  final bool liked;
  const OnLikeClickedEvent({this.markerId, this.liked});

  @override
  List<Object> get props => [markerId];
}

class OnMarkerTapEvent extends MapEvent {
  final MapMarker marker;
  const OnMarkerTapEvent({this.marker});

  @override
  List<Object> get props => [marker];
}

class OnCameraMoveStartedEvent extends MapEvent {
  const OnCameraMoveStartedEvent();

  @override
  List<Object> get props => [];
}

class OnCameraIdleEvent extends MapEvent {
  final CameraCurrentPosition cameraPosition;
  const OnCameraIdleEvent({this.cameraPosition});

  @override
  List<Object> get props => [cameraPosition];
}
