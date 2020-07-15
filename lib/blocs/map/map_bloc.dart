import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/repositories/geolocation_repository.dart';
import 'package:omsk_seaty_mobile/repositories/marker_repository.dart';

part 'map_event.dart';
part 'map_state.dart';

/* основной файл логики, здесь обрабатываются события и переключаются состояния экрана карты*/

class MapBloc extends Bloc<MapEvent, MapState> {
  final GeolocationRepository _geolocationRepository;
  final MarkerRepository _repository;
  Map<String, Marker> _markers;

  StreamSubscription<Position> _currentPositionSubcription;

  MapBloc(
      {@required GeolocationRepository geolocationRepository,
      MarkerRepository repository})
      : assert(geolocationRepository != null),
        assert(repository != null),
        _geolocationRepository = geolocationRepository,
        _repository = repository,
        super(MapInitial()) {
    add(MapMarkerInitialing());
  }

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    if (event is ButtonGetCurrentLocationPassedEvent) {
      yield* _mapCurrentLocationUpdatingToState(event);
      //print(event.toString());
    }
    if (event is MapGetCurrentLocationUpdatingEvent) {
      yield* _mapMapGetCurrentLocationToState(event);
      //print(event.toString());
    }
    if (event is CameraAnimateToUserLocation) {
      yield CameraAnimatedToUserLocation();
      //print(event.toString());
    }
    if (event is MapMarkerInitialing) {
      _repository.getMarkers().then((value) {
        _markers = value;
        add(MapMarkerInitialedStop(markers: _markers));
      });
      yield MarkersInitial();

      //print(event.toString());
    }
    if (event is MapMarkerInitialedStop) {
      _markers = event.markers;
      yield MarkersInitialed(markers: _markers);
    }
  }

  @override
  Future<void> close() {
    _currentPositionSubcription?.cancel();
    return super.close();
  }

  Stream<MapState> _mapCurrentLocationUpdatingToState(
      ButtonGetCurrentLocationPassedEvent event) async* {
    yield MapCurrentLocationUpdatingState();
    _currentPositionSubcription =
        _geolocationRepository.getCurrentPositionStream().listen((position) {
      add(MapGetCurrentLocationUpdatingEvent(currentPosition: position));
    });
  }

  Stream<MapState> _mapMapGetCurrentLocationToState(
      MapGetCurrentLocationUpdatingEvent event) async* {
    _currentPositionSubcription?.cancel();
    yield MapCurrentLocationUpdatedState(position: event.currentPosition);
  }
}
