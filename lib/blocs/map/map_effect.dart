import 'package:geolocator/geolocator.dart';

import 'map_bloc.dart';

abstract class MapEffect extends MapState {
  const MapEffect();
}

class UpdateUserLocationEffect extends MapEffect {
  final Position position;

  const UpdateUserLocationEffect({this.position});

  @override
  List<Object> get props => [position];
}

class OpenDetailsScreenEffect extends MapEffect {
  final String benchId;

  const OpenDetailsScreenEffect({this.benchId});

  @override
  List<Object> get props => [benchId];
}

class OpenAddBenchScreenEffect extends MapEffect {

  const OpenAddBenchScreenEffect();

  @override
  List<Object> get props => [];
}

class CameraMoveEffect extends MapEffect {

  const CameraMoveEffect();

  @override
  List<Object> get props => [];
}

class CameraIdleEffect extends MapEffect {

  const CameraIdleEffect();

  @override
  List<Object> get props => [];
}
