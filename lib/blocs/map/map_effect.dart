import 'package:geolocator/geolocator.dart';
import 'package:omsk_seaty_mobile/data/models/slider_benches_ui.dart';

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
  final SliderBenchesUi sliderBenchesUi;
  final bool onMarkerTaped;
  const CameraIdleEffect({this.sliderBenchesUi, this.onMarkerTaped});

  @override
  List<Object> get props => [sliderBenchesUi, onMarkerTaped];
}
