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
