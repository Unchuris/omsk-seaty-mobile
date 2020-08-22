import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/data/models/bench_light.dart';
import 'package:omsk_seaty_mobile/data/models/bench_type.dart';
import 'package:omsk_seaty_mobile/data/models/map_marker.dart';
import 'package:omsk_seaty_mobile/data/repositories/geolocation_repository.dart';
import 'package:image/image.dart' as images;
import 'package:omsk_seaty_mobile/data/repositories/marker_repository.dart';

import 'map_effect.dart';

part 'map_event.dart';

part 'map_state.dart';

class CameraCurrentPosition {
  double currentZoom;
  LatLngBounds visibleRegion;

  CameraCurrentPosition({this.currentZoom, this.visibleRegion});
}

enum PinType { cluster, pin }

class CurrentMarker {
  final String markerId;
  final PinType type;

  const CurrentMarker({this.type, this.markerId});
}
//TODO исправить баг, если слайдер открыт, то при нажатии на пин показывается не он
class MapBloc extends Bloc<MapEvent, MapState> {
  static const maxZoom = 21;
  static const thumbnailWidth = 250;
  static const String IMAGE_PIN = "pin.png";
  static const String IMAGE_CLUSTERPIN = "clusterpin.png";
  static const String IMAGE_SELECTEDPIN = "selectedpin.png";
  static const String IMAGE_SELECTEDCLUSTERPIN = "selectedclusterpin.png";

  Map<String, images.Image> _benchesPinImage = {};
  Map<String, images.Image> _imagesAssetsData = {};
  Map<String, BitmapDescriptor> _imagesBitmapDescriptor = {};

  final GeolocationRepository _geolocationRepository;
  final MarkerRepository _repository;

  Position _userPosition;
  MapMarker _currentMarker;
  //Map<benchId, clusterId>
  Map<String, MapMarker> _clusters = Map();

  final _filterController = StreamController<Set<FilterType>>.broadcast();
  Stream<Set<FilterType>> get filters => _filterController.stream;
  Function(Set<FilterType>) get _addFilters => _filterController.sink.add;

  List<BenchLight> _benches;
  final _benchesController = StreamController<List<BenchLight>>.broadcast();
  Stream<List<BenchLight>> get benches => _benchesController.stream;
  Function(List<BenchLight>) get _addBenches => _benchesController.sink.add;

  Map<String, Marker> _markers;
  final _markerController = StreamController<Map<String, Marker>>.broadcast();
  Stream<Map<String, Marker>> get markers => _markerController.stream;
  Function(Map<String, Marker>) get _addMarkers => _markerController.sink.add;

  Fluster<MapMarker> _fluster;

  CameraCurrentPosition _currentCameraPosition = CameraCurrentPosition(
      currentZoom: 10,
      visibleRegion: LatLngBounds(
          southwest: LatLng(-180, -85), northeast: LatLng(180, 85)));

  MapBloc(
      {@required GeolocationRepository geolocationRepository,
      MarkerRepository repository})
      : assert(geolocationRepository != null),
        assert(repository != null),
        _geolocationRepository = geolocationRepository,
        _repository = repository,
        super(MapInitial()) {
    add(MarkersLoading());
  }

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is OnMapLocationButtonClickedEvent) {
      yield* _mapOnMapLocationButtonClickedToEffect();
      return;
    }
    if (event is MarkersLoading) {
        _geolocationRepository
          .getCurrentPositionStream()
          .listen((position) {
            _userPosition = position;
          });
      _buildMediaPool();
      return;
    }
    if (event is OnMapCreatedEvent) {
      _addFilters(_repository.filters);
      _updateBenchesByVisibleRegion();
      yield* _mapOnMapLocationButtonClickedToEffect();
      return;
    }
    if (event is OnBenchSliderPageChanged) {
      var bench = event.bench;
      var cluster = _clusters[bench.id];
      bool constrainCluster = cluster != null;
      if (constrainCluster && _currentMarker.clusterId == cluster.clusterId) {
        return;
      }

      if (constrainCluster) {
        var selectedBitmapDescriptor = await _createSelectedClusterBitmapDescriptor(cluster);
        _markers[cluster.clusterId.toString()] = _markerUpdateIcon(_markers[cluster.clusterId.toString()], selectedBitmapDescriptor);
      } else {
        var selectedBitmapDescriptor = await _getImageBitmapDescriptor(IMAGE_SELECTEDPIN);
        _markers[bench.id] = _markerUpdateIcon(_markers[bench.id], selectedBitmapDescriptor);
      }

      await _selectedMarkerToBaseMarker();

      _currentMarker = constrainCluster ? cluster : MapMarker(
          markerId: bench.id,
          latitude: bench.latitude,
          longitude: bench.longitude
      );
      _addMarkers(_markers);
      return;
    }
    if (event is OnFilterChangedEvent) {
      _repository.filters = Set.of(event.filterTypes);
      _addFilters(_repository.filters);
      if (_benches != null) {
        _benches.clear();
        _addBenches(_benches);
      }
      _currentMarker = null;
      _clusters = Map();
      _buildMediaPool();
      _updateBenchesByVisibleRegion();
      return;
    }
    if (event is OnLikeClickedEvent) {
      //TODO
      return;
    }
    if (event is OnMarkerTapEvent) {
      if (identical(event.marker,_currentMarker)) {
        return;
      }
      if (event.marker.isCluster) {
        List<String> children = _fluster.points(event.marker.clusterId).map((it) => it.markerId).toList();
        var selectedBitmapDescriptor = await _createSelectedClusterBitmapDescriptor(event.marker);
        _markers[event.marker.clusterId.toString()] = _markerUpdateIcon(_markers[event.marker.clusterId.toString()], selectedBitmapDescriptor);
        _benches = await _repository.getClusterBenches(children);
        _addBenches(_benches);
      } else {
        var selectedBitmapDescriptor = await _getImageBitmapDescriptor(IMAGE_SELECTEDPIN);
        _markers[event.marker.markerId] = _markerUpdateIcon(_markers[event.marker.markerId], selectedBitmapDescriptor);
      }
      await _selectedMarkerToBaseMarker();
      _currentMarker = event.marker;
      _addMarkers(_markers);
      return;
    }
    if (event is OnCameraMoveStartedEvent) {
      yield* _mapOnCameraMoveToEffect(event);
      return;
    }
    if (event is OnCameraIdleEvent) {
      _currentCameraPosition = event.cameraPosition;
      _displayMarkers();
      await _updateBenchesByVisibleRegion();
      if (_currentMarker != null
          && !_currentMarker.isCluster
          && _currentCameraPosition.visibleRegion.contains(LatLng(_currentMarker.latitude, _currentMarker.longitude))) {
        _addBenches(_benches);
      }
      yield* _mapOnCameraIdleToEffect(event);
      return;
    }
    return;
  }

  Stream<MapState> _mapOnMapLocationButtonClickedToEffect() async* {
    if (_userPosition != null) {
      yield UpdateUserLocationEffect(position: _userPosition);
    }
  }

  Stream<MapState> _mapOnCameraMoveToEffect(
      OnCameraMoveStartedEvent event) async* {
    yield CameraMoveEffect();
  }

  Stream<MapState> _mapOnCameraIdleToEffect(
      OnCameraIdleEvent event) async* {
    yield CameraIdleEffect();
  }

  @override
  Future<void> close() {
    _markerController?.close();
    _benchesController?.close();
    _filterController?.close();
    return super.close();
  }

  Marker _markerUpdateIcon(Marker marker, BitmapDescriptor bitmapDescriptor) {
    return Marker(
        markerId: marker.markerId,
        position: marker.position,
        infoWindow: marker.infoWindow,
        onTap: marker.onTap,
        icon: bitmapDescriptor);
  }

  Future<void> _selectedMarkerToBaseMarker() async {
    if (_currentMarker != null) {
      var bitmapDescriptor = _currentMarker.isCluster ? await _createClusterBitmapDescriptor(_currentMarker) : await _getImageBitmapDescriptor(IMAGE_PIN);
      var id = _currentMarker.isCluster ? _currentMarker.clusterId.toString() : _currentMarker.markerId;
      if (_markers[id] != null) _markers[id] = _markerUpdateIcon(_markers[id], bitmapDescriptor);
    }
  }

  void _buildMediaPool() async {
    var result = await _repository.getMarkers().then((benches) {
      return {
        for (var bench in benches)
          bench.id: MapMarker(
              markerId: bench.id,
              latitude: bench.latitude,
              longitude: bench.longitude
          )
      };
    });

    _fluster = Fluster<MapMarker>(
        minZoom: 10,
        maxZoom: maxZoom,
        radius: 250,
        extent: 2048,
        nodeSize: 256,
        points: result.values.toList(),
        createCluster:
            (BaseCluster cluster, double longitude, double latitude) =>
                MapMarker(
                    latitude: latitude,
                    longitude: longitude,
                    isCluster: true,
                    clusterId: cluster.id,
                    pointsSize: cluster.pointsSize,
                    markerId: cluster.id.toString(),
                    childMarkerId: cluster.childMarkerId));

    _displayMarkers();
  }

  void _displayMarkers() async {
    if (_fluster == null) {
      return;
    }
    List<MapMarker> clusters;
    if (_currentCameraPosition != null) {
      clusters = _fluster.clusters([
        _currentCameraPosition.visibleRegion.southwest.longitude,
        _currentCameraPosition.visibleRegion.southwest.latitude,
        _currentCameraPosition.visibleRegion.northeast.longitude,
        _currentCameraPosition.visibleRegion.northeast.latitude
      ], _currentCameraPosition.currentZoom.toInt());
    } else {
      clusters = _fluster.clusters(
          [-180, -85, 180, 85], _currentCameraPosition.currentZoom.toInt());
    }

    Map<String, Marker> markers = Map();

    _clusters.clear();
    for (MapMarker feature in clusters) {
      if (feature.isCluster) {
        for (MapMarker mapMarker in _fluster.points(feature.clusterId)) {
          _clusters.putIfAbsent(mapMarker.markerId, () => feature);
        }
      }
      BitmapDescriptor bitmapDescriptor;

      if (feature.isCluster) {
        bitmapDescriptor = (_currentMarker != null &&
            _currentMarker.markerId == feature.markerId
        ) ? await _createSelectedClusterBitmapDescriptor(feature) :
          await _createClusterBitmapDescriptor(feature);
      } else if (_currentMarker != null &&
          _currentMarker.markerId == feature.markerId) {
        bitmapDescriptor = await _getImageBitmapDescriptor(IMAGE_SELECTEDPIN);
      } else {
        bitmapDescriptor = await _getImageBitmapDescriptor(IMAGE_PIN);
      }

      var marker = Marker(
          markerId: feature.isCluster ? MarkerId(feature.clusterId.toString()) : MarkerId(feature.markerId),
          position: LatLng(feature.latitude, feature.longitude),
          infoWindow: null,
          onTap: () {
            add(OnMarkerTapEvent(marker: feature));
          },
          icon: bitmapDescriptor
      );
      markers.putIfAbsent(feature.isCluster ? feature.clusterId.toString() : feature.markerId, () => marker);
    }
    _markers = markers;
    _addMarkers(_markers);
  }

  _updateBenchesByVisibleRegion() async {
    _benches = await _repository.getBenchesByVisibleRegion(_currentCameraPosition.visibleRegion);
  }

  Future<BitmapDescriptor> _createSelectedClusterBitmapDescriptor(MapMarker feature) async {
    var child = await _getImage(IMAGE_SELECTEDCLUSTERPIN, 200, 200);
    images.drawString(
        child,
        images.arial_24,
        (feature.pointsSize ~/ 10 != 0) ? 62 : 68,
        19,
        '${feature.pointsSize}');

    var png = images.encodePng(child);

    return BitmapDescriptor.fromBytes(png);
  }

  Future<BitmapDescriptor> _createClusterBitmapDescriptor(
      MapMarker feature) async {
    var child = await _getImage(IMAGE_CLUSTERPIN, 150, 150);

    images.drawString(
        child,
        images.arial_24,
        (feature.pointsSize ~/ 10 != 0) ? 47 : 54,
        12,
        '${feature.pointsSize}');

    var png = images.encodePng(child);

    return BitmapDescriptor.fromBytes(png);
  }

  Future<BitmapDescriptor> _getImageBitmapDescriptor(
      String thumbnailSrc) async {
    if (_imagesBitmapDescriptor.containsKey(thumbnailSrc)) {
      return _imagesBitmapDescriptor[thumbnailSrc];
    }

    var resized = await _getImage(thumbnailSrc, 120, 120);

    if (resized == null) {
      return null;
    }

    var png = images.encodePng(resized);

    var bitmapDescriptor = BitmapDescriptor.fromBytes(png);

    _imagesBitmapDescriptor[thumbnailSrc] = bitmapDescriptor;

    return bitmapDescriptor;
  }

  Future<images.Image> _getImage(
      String imageFile, int width, int height) async {
    String key = imageFile + width.toString() + height.toString();
    if (_benchesPinImage.containsKey(key)) return _benchesPinImage[key].clone();
    var image = await _getAssetsImage(imageFile);
    _benchesPinImage[key] = image.clone();
    return image;
  }

  Future<images.Image> _getAssetsImage(String imageFile) async {
    if (_imagesAssetsData.containsKey(imageFile))
      return _imagesAssetsData[imageFile].clone();
    ByteData imageData;
    try {
      imageData = await rootBundle.load('assets/$imageFile');
    } catch (e) {
      print('caught $e');
      return null;
    }
    if (imageData == null) return null;
    images.Image image = images.decodeImage(Uint8List.view(imageData.buffer));
    _imagesAssetsData[imageFile] = image.clone();
    return image;
  }
}
