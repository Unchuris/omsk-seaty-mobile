import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/data/models/map_marker.dart';
import 'package:omsk_seaty_mobile/data/repositories/geolocation_repository.dart';
import 'package:image/image.dart' as images;
import 'package:omsk_seaty_mobile/data/repositories/marker_repository.dart';

part 'map_event.dart';
part 'map_state.dart';

/* основной файл логики, здесь обрабатываются события и переключаются состояния экрана карты*/

class MapBloc extends Bloc<MapEvent, MapState> {
  static const maxZoom = 21;
  static const thumbnailWidth = 250;

  final GeolocationRepository _geolocationRepository;
  final MarkerRepository _repository;

  Position _currentPosition;
  Map<MarkerId, Marker> _markers;
  StreamSubscription<Position> _currentPositionSubcription;
  StreamSubscription _cameraZoomSubscription;
  StreamSubscription _visibleReginSubscription;

  Map<String, MapMarker> _mediaPool = {};

  final _markerController = StreamController<Map<MarkerId, Marker>>.broadcast();

  final _cameraZoomController = StreamController<double>.broadcast();

  final _cameraVisibleRegion = StreamController<LatLngBounds>.broadcast();
  LatLngBounds _currentVisibleRegion;
  Function(Map<MarkerId, Marker>) get addMarkers => _markerController.sink.add;
  Function(double) get setCameraZoom => _cameraZoomController.sink.add;
  Function(LatLngBounds) get setVisibleRegion => _cameraVisibleRegion.sink.add;

  var _currentZoom = 11;
  Fluster<MapMarker> _fluster;

  Stream<Map<MarkerId, Marker>> get markers => _markerController.stream;
  Stream<double> get cameraZoom => _cameraZoomController.stream;
  Stream<LatLngBounds> get visibleRegion => _cameraVisibleRegion.stream;

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
    } else if (event is MapGetCurrentLocationUpdatingEvent) {
      yield* _mapMapGetCurrentLocationToState(event);
    } else if (event is MapMarkerInitialing) {
      yield MarkersInitial();
      if (_currentPositionSubcription == null) {
        _currentPositionSubcription = _geolocationRepository
            .getCurrentPositionStream()
            .listen((position) {
          _currentPosition = position;
        });
      }
      _buildMediaPool();
      _visibleReginSubscription = visibleRegion.listen((event) {
        _currentVisibleRegion = event;
        _displayMarkers(_mediaPool);
      });
      _cameraZoomSubscription = cameraZoom.listen((zoom) {
        if (_currentZoom != zoom.toInt()) {
          _currentZoom = zoom.toInt();

          _displayMarkers(_mediaPool);
        }
      });
      add(MapMarkerInitialedStop(markers: _markers));
    } else if (event is MapMarkerInitialedStop) {
      yield MarkersInitialed(markers: _markers);
    }
  }

  @override
  Future<void> close() {
    _currentPositionSubcription?.cancel();
    _cameraZoomSubscription.cancel();
    _visibleReginSubscription.cancel();
    _markerController.close();
    _cameraZoomController.close();
    _cameraVisibleRegion.close();

    return super.close();
  }

  Stream<MapState> _mapCurrentLocationUpdatingToState(
      ButtonGetCurrentLocationPassedEvent event) async* {
    yield MapCurrentLocationUpdatingState();
    add(MapGetCurrentLocationUpdatingEvent());
  }

  Stream<MapState> _mapMapGetCurrentLocationToState(
      MapGetCurrentLocationUpdatingEvent event) async* {
    yield MapCurrentLocationUpdatedState(position: _currentPosition);
  }

  void _buildMediaPool() async {
    var result = await _repository.getMarkers().then((value) {
      var result = {
        for (var i = 0; i < value.length; i++)
          i.toString(): MapMarker(
              markerId: i.toString(),
              latitude: value[i].latitude,
              longitude: value[i].longitude,
              locationName: value[i].title,
              thumbnailSrc: "park.png")
      };
      return result;
    });
    _mediaPool.addAll(result);

    _fluster = Fluster<MapMarker>(
        minZoom: 10,
        maxZoom: maxZoom,
        radius: 250,
        extent: 2048,
        nodeSize: 32,
        points: _mediaPool.values.toList(),
        createCluster:
            (BaseCluster cluster, double longitude, double latitude) =>
                MapMarker(
                    locationName: null,
                    latitude: latitude,
                    longitude: longitude,
                    isCluster: true,
                    clusterId: cluster.id,
                    pointsSize: cluster.pointsSize,
                    markerId: cluster.id.toString(),
                    childMarkerId: cluster.childMarkerId));

    _displayMarkers(_mediaPool);
  }

  void _displayMarkers(Map pool) async {
    if (_fluster == null) {
      return;
    }
    List<MapMarker> clusters;
    if (_currentVisibleRegion != null) {
      clusters = _fluster.clusters([
        _currentVisibleRegion.southwest.longitude,
        _currentVisibleRegion.southwest.latitude,
        _currentVisibleRegion.northeast.longitude,
        _currentVisibleRegion.northeast.latitude
      ], _currentZoom);
    } else {
      clusters = _fluster.clusters([-180, -85, 180, 85], _currentZoom);
    }

    Map<MarkerId, Marker> markers = Map();

    for (MapMarker feature in clusters) {
      BitmapDescriptor bitmapDescriptor;

      if (feature.isCluster) {
        bitmapDescriptor = await _createClusterBitmapDescriptor(feature);
      } else {
        bitmapDescriptor =
            await _createImageBitmapDescriptor(feature.thumbnailSrc);
      }

      var marker = Marker(
          markerId: MarkerId(feature.markerId),
          position: LatLng(feature.latitude, feature.longitude),
          infoWindow: InfoWindow(title: feature.locationName),
          icon: bitmapDescriptor);

      markers.putIfAbsent(MarkerId(feature.markerId), () => marker);
    }

    addMarkers(markers);
    _markers = markers;
  }

  Future<BitmapDescriptor> _createClusterBitmapDescriptor(
      MapMarker feature) async {
    MapMarker childMarker = _mediaPool[feature.childMarkerId];

    var child = await _createImage(
        childMarker.thumbnailSrc, thumbnailWidth, thumbnailWidth);

    if (child == null) {
      return null;
    }

    images.brightness(child, -50);
    images.drawString(
        child, images.arial_48, 100, 20, '+${feature.pointsSize}');

    var resized = images.copyResize(child, width: 120, height: 120);

    var png = images.encodePng(resized);

    return BitmapDescriptor.fromBytes(png);
  }

  Future<BitmapDescriptor> _createImageBitmapDescriptor(
      String thumbnailSrc) async {
    var resized = await _createImage(thumbnailSrc, 120, 120);

    if (resized == null) {
      return null;
    }

    var png = images.encodePng(resized);

    return BitmapDescriptor.fromBytes(png);
  }

  Future<images.Image> _createImage(
      String imageFile, int width, int height) async {
    ByteData imageData;
    try {
      imageData = await rootBundle.load('assets/$imageFile');
    } catch (e) {
      print('caught $e');
      return null;
    }

    if (imageData == null) {
      return null;
    }

    List<int> bytes = Uint8List.view(imageData.buffer);
    var image = images.decodeImage(bytes);

    return images.copyResize(image, width: width, height: height);
  }
}
