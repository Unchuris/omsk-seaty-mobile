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
  final Set<FilterType> filterTypes;
  const OnFilterChangedEvent({this.filterTypes});

  @override
  List<Object> get props => [filterTypes];
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

class FindButtonPressingEvent extends MapEvent {
  final Map<String, bool> checkBox;
  const FindButtonPressingEvent({this.checkBox});

  List<Object> get props => [checkBox];

  @override
  String toString() => "FindButtonPassEvent {checkBox: ${checkBox}}";
}

class FindButtonPressedEvent extends MapEvent {
  const FindButtonPressedEvent();

  List<Object> get props => [];

  @override
  String toString() => "FindButtonPressedEvent {}";
}
