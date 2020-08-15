import 'dart:async';
import 'dart:math';
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

class MapBloc extends Bloc<MapEvent, MapState> {
  final List<String> imgList = [
    'https://m.bk55.ru/fileadmin/bkinform/image/2017/12/29/1514539988/9c572fa5eeb303b8e665d6f7e1430e2f.jpg',
    'https://varlamov.me/2018/omsk/48.jpg',
    'https://superomsk.ru/images/uploading/b27000d014f07c29554b7b461ee04b4d.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRurKuj6R4YRCZ6rLbJzKMRaVrLOoPgo6aKqw&usqp=CAU',
  ];

  static const maxZoom = 21;
  static const thumbnailWidth = 250;

  final GeolocationRepository _geolocationRepository;
  final MarkerRepository _repository;

  List<MapMarker> _benches;
  List<MapMarker> _favorites = [];

  Position _currentPosition;
  CurrentMarker _currentMarker;

  Map<MarkerId, Marker> _markers;

  StreamSubscription<Position> _currentPositionSubcription;
  StreamSubscription _cameraPositionSubscription;

  Map<String, images.Image> _benchesPinImage = {};
  Map<String, images.Image> _imagesAssetsData = {};
  Map<String, BitmapDescriptor> _imagesBitmapDescriptor = {};

  static const String IMAGE_PIN = "pin.png";
  static const String IMAGE_CLUSTERPIN = "clusterpin.png";
  static const String IMAGE_SELECTEDPIN = "selectedpin.png";
  static const String IMAGE_SELECTEDCLUSTERPIN = "selectedclusterpin.png";

  Map<String, MapMarker> _mediaPool = {};

  final _cameraCameraPosition =
      StreamController<CameraCurrentPosition>.broadcast();

  CameraCurrentPosition _currentCameraPosition = CameraCurrentPosition(
      currentZoom: 10,
      visibleRegion: LatLngBounds(
          southwest: LatLng(-180, -85), northeast: LatLng(180, 85)));
  Function(CameraCurrentPosition) get setCameraPosition =>
      _cameraCameraPosition.sink.add;

  var _currentZoom = 10;
  Fluster<MapMarker> _fluster;

  Stream<CameraCurrentPosition> get cameraPosition =>
      _cameraCameraPosition.stream;

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
      _cameraPositionSubscription = cameraPosition.listen((event) {
        _currentCameraPosition.currentZoom = event.currentZoom;
        _currentCameraPosition.visibleRegion = event.visibleRegion;
        _displayMarkers(_mediaPool);
      });
    } else if (event is MapMarkerInitialedStop) {
      yield MarkersInitialed(markers: _markers);
    } else if (event is MapMarkerPressedEvent) {
      yield MapMarkerPressedState(
          markerId: event.markerId, markers: event.markers);
    } else if (event is LikeButtonPassEvent) {
      print(event.toString());
      if (event.marker.isFavorites) {
        _favorites.add(event.marker);
      } else {
        for (var v in _favorites) {
          if (v.markerId.compareTo(event.marker.markerId) == 0) {
            _favorites.remove(v);
            break;
          }
        }
      }
      yield LikeButtonPassState(
          favorites: _favorites, currentmarker: event.marker);
    } else if (event is LikeUpdatingEvent) {
      yield LikeUpdatedState();
    } else if (event is MapTapedEvent) {
      yield MapTapedState();
    }
  }

  @override
  Future<void> close() {
    _currentPositionSubcription?.cancel();
    _cameraPositionSubscription?.cancel();
    _cameraCameraPosition?.close();
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
    var result = await _repository.getMarkers().then((benches) {
      var random = Random();
      return {
        for (var bench in benches)
          bench.pk.toString(): MapMarker(
              markerId: bench.pk.toString(),
              latitude: bench.latitude,
              longitude: bench.longitude,
              locationName: bench.title,
              isFavorites: false,
              imageUrl: imgList[random.nextInt(imgList.length)]),
      };
    });
    _mediaPool.addAll(result);

    _fluster = Fluster<MapMarker>(
        minZoom: 10,
        maxZoom: maxZoom,
        radius: 250,
        extent: 2048,
        nodeSize: 256,
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

    Map<MarkerId, Marker> markers = Map();

    for (MapMarker feature in clusters) {
      BitmapDescriptor bitmapDescriptor;

      if (feature.isCluster) {
        bitmapDescriptor = await _createClusterBitmapDescriptor(feature);
      } else if (_currentMarker != null &&
          _currentMarker.markerId == feature.markerId) {
        bitmapDescriptor = await _getImageBitmapDescriptor(IMAGE_SELECTEDPIN);
      } else {
        bitmapDescriptor = await _getImageBitmapDescriptor(IMAGE_PIN);
      }

      var marker = Marker(
          markerId: MarkerId(feature.markerId),
          position: LatLng(feature.latitude, feature.longitude),
          infoWindow: null,
          onTap: () {
            _currentMarker = _getCurrentMarker(feature);

            if (feature.isCluster) {
              var children = _fluster.points(feature.clusterId);
              _benches = children;

              add(MapMarkerPressedEvent(
                  markers: children, markerId: feature.clusterId.toString()));
            } else {
              _benches = [feature];
              add(MapMarkerPressedEvent(
                  markers: [feature], markerId: feature.markerId));
            }
          },
          icon: bitmapDescriptor);

      markers.putIfAbsent(MarkerId(feature.markerId), () => marker);
    }

    add(MapMarkerInitialedStop(markers: markers));
    _markers = markers;
  }

  Future<BitmapDescriptor> _createClusterBitmapDescriptor(
      MapMarker feature) async {
    var child;

    if (_currentMarker != null &&
        feature.clusterId.toString() == _currentMarker.markerId) {
      child = await _getImage(IMAGE_SELECTEDCLUSTERPIN, 200, 200);
    } else {
      child = await _getImage(IMAGE_CLUSTERPIN, 150, 150);
    }

    if (child == null) {
      return null;
    }
    if (_currentMarker != null &&
        feature.clusterId.toString() == _currentMarker.markerId) {
      images.drawString(
          child,
          images.arial_24,
          (feature.pointsSize ~/ 10 != 0) ? 62 : 68,
          19,
          '${feature.pointsSize}');
    } else {
      images.drawString(
          child,
          images.arial_24,
          (feature.pointsSize ~/ 10 != 0) ? 47 : 54,
          12,
          '${feature.pointsSize}');
    }

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

    // var pinImage = images.copyResize(image, width: width, height: height);
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

  CurrentMarker _getCurrentMarker(MapMarker feature) {
    if (_currentMarker != null) {
      if (feature.isCluster) {
        return _currentMarker = CurrentMarker(
            markerId: feature.clusterId.toString(), type: PinType.cluster);
      } else {
        return _currentMarker =
            CurrentMarker(markerId: feature.markerId, type: PinType.pin);
      }
    } else {
      if (feature.isCluster) {
        return _currentMarker = CurrentMarker(
            markerId: feature.clusterId.toString(), type: PinType.cluster);
      } else {
        return _currentMarker =
            CurrentMarker(markerId: feature.markerId, type: PinType.pin);
      }
    }
  }
}
