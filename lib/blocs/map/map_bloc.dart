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

/* основной файл логики, здесь обрабатываются события и переключаются состояния экрана карты*/
enum Type { cluster, one }

class CurrentMarker {
  final String markerId;
  final Type type;
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
  StreamSubscription _cameraZoomSubscription;
  StreamSubscription _visibleReginSubscription;

  Map<String, images.Image> _benchesPinImage = {};
  Map<String, images.Image> _imagesAssetsData = {};
  Map<String, BitmapDescriptor> _imagesBitmapDescriptor = {};
  BitmapDescriptor selectedPin;

  Map<String, MapMarker> _mediaPool = {};

  final _markerController = StreamController<Map<MarkerId, Marker>>.broadcast();

  final _cameraZoomController = StreamController<double>.broadcast();

  final _cameraVisibleRegion = StreamController<LatLngBounds>.broadcast();
  LatLngBounds _currentVisibleRegion;
  Function(Map<MarkerId, Marker>) get addMarkers => _markerController.sink.add;
  Function(double) get setCameraZoom => _cameraZoomController.sink.add;
  Function(LatLngBounds) get setVisibleRegion => _cameraVisibleRegion.sink.add;

  var _currentZoom = 10;
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
    } else if (event is MapMarkerPressedEvent) {
      yield MapMarkerPressedState(
          markerId: event.markerId, markers: event.markers);
    } else if (event is LikeButtonPassEvent) {
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
    var result = await _repository.getMarkers().then((benches) {
      var random = Random();
      return {
        for (var bench in benches)
          bench.pk.toString(): MapMarker(
              markerId: bench.pk.toString(),
              latitude: bench.latitude,
              longitude: bench.longitude,
              locationName: bench.title,
              thumbnailSrc: "pin.png",
              isFavorites: false,
              isSelect: false,
              imageUrl: imgList[random.nextInt(imgList.length)]),
      };
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
        bitmapDescriptor = await _getImageBitmapDescriptor(
            feature.thumbnailSrc, feature.isSelect);
      }

      var marker = Marker(
          markerId: MarkerId(feature.markerId),
          position: LatLng(feature.latitude, feature.longitude),
          infoWindow: null,
          onTap: () {
            if (_currentMarker != null) {
              if (feature.isCluster) {
                for (var v in clusters) {
                  if (_currentMarker.type == Type.cluster) {
                    if (_currentMarker.markerId == v.clusterId.toString()) {
                      v.isSelect = false;
                      break;
                    }
                  } else {
                    if (_currentMarker.markerId == v.markerId) {
                      v.isSelect = false;
                      break;
                    }
                  }
                }
                _currentMarker = CurrentMarker(
                    markerId: feature.clusterId.toString(), type: Type.cluster);
                feature.isSelect = true;
              } else {
                for (var v in clusters) {
                  if (_currentMarker.type == Type.cluster) {
                    if (_currentMarker.markerId == v.clusterId.toString()) {
                      v.isSelect = false;
                      break;
                    }
                  } else {
                    if (_currentMarker.markerId == v.markerId) {
                      v.isSelect = false;
                      break;
                    }
                  }
                }
                _currentMarker =
                    CurrentMarker(markerId: feature.markerId, type: Type.one);
                feature.isSelect = true;
              }
            } else {
              if (feature.isCluster) {
                _currentMarker = CurrentMarker(
                    markerId: feature.clusterId.toString(), type: Type.cluster);
                feature.isSelect = true;
              } else {
                _currentMarker =
                    CurrentMarker(markerId: feature.markerId, type: Type.one);
                feature.isSelect = true;
              }
            }

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
    if (feature.isSelect) {
      child =
          await _getImage("selectedclusterpin.png", 120, 120, feature.isSelect);
    } else {
      child = await _getImage("clusterpin.png", 200, 200, feature.isSelect);
    }

    if (child == null) {
      return null;
    }
    if (feature.pointsSize ~/ 10 != 0) {
      images.drawString(
          child, images.arial_24, 47, 12, '${feature.pointsSize}');
    } else {
      images.drawString(
          child, images.arial_24, 54, 12, '${feature.pointsSize}');
    }

    var png = images.encodePng(child);

    return BitmapDescriptor.fromBytes(png);
  }

  Future<BitmapDescriptor> _getImageBitmapDescriptor(
      String thumbnailSrc, bool isSelected) async {
    if (_imagesBitmapDescriptor.containsKey(thumbnailSrc) && !isSelected) {
      return _imagesBitmapDescriptor[thumbnailSrc];
    } else if (_imagesBitmapDescriptor.containsKey("selectedpin.png")) {
      return _imagesBitmapDescriptor["selectedpin.png"];
    }

    var resized = await _getImage(thumbnailSrc, 120, 120, isSelected);

    if (resized == null) {
      return null;
    }

    var png = images.encodePng(resized);

    var bitmapDescriptor = BitmapDescriptor.fromBytes(png);
    if (isSelected) {
      _imagesBitmapDescriptor["selectedpin.png"] = bitmapDescriptor;
    } else {
      _imagesBitmapDescriptor[thumbnailSrc] = bitmapDescriptor;
    }

    return bitmapDescriptor;
  }

  Future<images.Image> _getImage(
      String imageFile, int width, int height, bool isSelected) async {
    String key = imageFile + width.toString() + height.toString();
    if (isSelected) {
      if (imageFile == "pin.png") {
        var image = await _getAssetsImage("selectedpin.png");
        _benchesPinImage[key] = image.clone();
        return image;
      } else if (imageFile == "clusterpin.png") {
        var image = await _getAssetsImage("selectedclusterpin.png");
        return image;
      }
    }
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
}
