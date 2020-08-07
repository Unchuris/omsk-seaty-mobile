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

//TODO remove test data
final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];


/* основной файл логики, здесь обрабатываются события и переключаются состояния экрана карты*/

class MapBloc extends Bloc<MapEvent, MapState> {
  static const maxZoom = 21;
  static const thumbnailWidth = 250;

  final GeolocationRepository _geolocationRepository;
  final MarkerRepository _repository;

  Position _currentPosition;
  List<MapMarker> _benches;
  StreamSubscription<Position> _currentPositionSubcription;
  StreamSubscription _cameraZoomSubscription;
  StreamSubscription _visibleReginSubscription;
  Map<String, images.Image> _benchesPinImage = {};
  Map<String, images.Image> _imagesAssetsData = {};
  Map<String, BitmapDescriptor> _imagesBitmapDescriptor = {};

  Map<String, MapMarker> _mediaPool = {};

  final _cameraZoomController = StreamController<double>.broadcast();

  final _cameraVisibleRegion = StreamController<LatLngBounds>.broadcast();
  LatLngBounds _currentVisibleRegion;
  Function(double) get setCameraZoom => _cameraZoomController.sink.add;
  Function(LatLngBounds) get setVisibleRegion => _cameraVisibleRegion.sink.add;

  var _currentZoom = 11;
  Fluster<MapMarker> _fluster;

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
      //TODO remove
      yield* _onBenchesChangeToState();
      //yield* _mapCurrentLocationUpdatingToState(event);
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
    } else if (event is MapMarkerInitialedStop) {
      yield MarkersInitialed(markers: event.markers);
    }
  }

  @override
  Future<void> close() {
    _currentPositionSubcription?.cancel();
    _cameraZoomSubscription.cancel();
    _visibleReginSubscription.cancel();
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

  //TODO
  Stream<MapState> _onBenchesChangeToState() async* {
    yield BenchesState(benches: _benches);
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
              thumbnailSrc: "park.png",
              imageUrl: imgList[i % imgList.length])
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

    _benches = _mediaPool.values.toList();
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
            await _getImageBitmapDescriptor(feature.thumbnailSrc);
      }

      var marker = Marker(
          markerId: MarkerId(feature.markerId),
          position: LatLng(feature.latitude, feature.longitude),
          infoWindow: InfoWindow(title: feature.locationName),
          icon: bitmapDescriptor);

      markers.putIfAbsent(MarkerId(feature.markerId), () => marker);
    }

    add(MapMarkerInitialedStop(markers: markers));
  }

  Future<BitmapDescriptor> _createClusterBitmapDescriptor(
      MapMarker feature) async {
    MapMarker childMarker = _mediaPool[feature.childMarkerId];

    var child = await _getImage(
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

  Future<BitmapDescriptor> _getImageBitmapDescriptor(
      String thumbnailSrc) async {
    if (_imagesBitmapDescriptor.containsKey(thumbnailSrc)) return _imagesBitmapDescriptor[thumbnailSrc];

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
    String key = imageFile+width.toString()+height.toString();
    if (_benchesPinImage.containsKey(key)) return _benchesPinImage[key].clone();
    var image = await _getAssetsImage(imageFile);

    var pinImage = images.copyResize(image, width: width, height: height);
    _benchesPinImage[key] = pinImage.clone();
    return pinImage;
  }

  Future<images.Image> _getAssetsImage(String imageFile) async {
    if (_imagesAssetsData.containsKey(imageFile)) return _imagesAssetsData[imageFile].clone();
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
