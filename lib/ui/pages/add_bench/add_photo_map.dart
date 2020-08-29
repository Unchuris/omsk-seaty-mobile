import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/data/models/geopoint.dart';
import 'package:omsk_seaty_mobile/ui/utils/geo.dart';
import 'package:stream_transform/stream_transform.dart';

class AddPhotoMapScreen extends StatefulWidget {
  final GeoPoint startPoint;

  const AddPhotoMapScreen({Key key, this.startPoint}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddPhotoMapScreenState();
  }
}

class _AddPhotoMapScreenState extends State<AddPhotoMapScreen>
    with SingleTickerProviderStateMixin {
  GeoPoint _centerPoint;
  GoogleMapController _mapController;
  AnimationController _animationController;
  Animation<double> _markerAnimation;
  StreamController<GeoPoint> _pointStreamController =
      StreamController.broadcast();

  Stream<GeoPoint> get _pointStream => _pointStreamController.stream;

  @override
  void initState() {
    super.initState();
    _centerPoint = widget.startPoint ?? omskCenterPoint.toLatLng();
    _animationController = AnimationController(
        duration: Duration(seconds: 1, milliseconds: 300), vsync: this);
    _markerAnimation = _animationController.drive(
      Tween<double>(
        begin: 120,
        end: 32,
      ),
    );
    _animationController.reset();
    _markerAnimation.addListener(() {
      setState(() {});
    });
    _animationController.forward();
    _pointStreamController.add(_centerPoint);
    _pointStream.debounce(Duration(milliseconds: 300)).listen((point) {
      setState(() {
        _centerPoint = point;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onCameraMove: (camera) => _onCameraPositionChanged(context, camera),
          minMaxZoomPreference: MinMaxZoomPreference(18.0, 18.0),
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          onMapCreated: (controller) async {
            final style = await rootBundle.loadString("assets/map-style.json");
            controller.setMapStyle(style);
            _mapController = controller;
            _mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: _centerPoint.toLatLng(),
                    zoom: 20.0),
              ),
            );
          },
          initialCameraPosition: CameraPosition(
              target: _centerPoint.toLatLng()),
        ),
        Center(
          child: Icon(Icons.location_on,
              size: _markerAnimation.value,
              color: Theme.of(context).accentColor),
        ),
        Column(children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
            color: Colors.white,
            child: Center(child: _buildAddressText(context)),
          ),
          Container(color: Theme.of(context).accentColor, height: 1)
        ]),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Align(
                child: _buildFinishLocationImageButton(context),
                alignment: Alignment.bottomRight)),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: _buildMyLocationImageButton(context),
            alignment: Alignment.bottomLeft)
      ],
    );
  }

  Widget _buildAddressText(BuildContext context) {
    return FutureBuilder<String>(
        future: getAddressString(_centerPoint),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text(snapshot.data ?? "${_centerPoint.latitude}, ${_centerPoint.longitude}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4);
          } else {
            return LinearProgressIndicator();
          }
        });
  }

  @override
  void dispose() {
    _pointStreamController.close();
    super.dispose();
  }

  void _onCameraPositionChanged(BuildContext context, CameraPosition position) {
    final geoPoint = GeoPoint(
        latitude: position.target.latitude,
        longitude: position.target.longitude);
    _centerPoint = geoPoint;
    _pointStreamController.sink.add(geoPoint);
  }

  Widget _buildMyLocationImageButton(BuildContext context) {
    return Container(
      height: 56,
      width: 56,
      child: RawMaterialButton(
        onPressed: () => onMyLocationClick(context),
        fillColor: Theme.of(context).accentColor,
        child: Icon(
          Icons.location_on,
          color: Theme.of(context).iconTheme.color,
          size: 32.0,
        ),
        shape: CircleBorder(),
      ),
    );
  }

  Widget _buildFinishLocationImageButton(BuildContext context) {
    return Container(
      height: 56,
      width: 56,
      child: RawMaterialButton(
        onPressed: () => onFinishLocationSelection(context),
        fillColor: Theme.of(context).accentColor,
        child: Icon(
          Icons.forward,
          color: Theme.of(context).iconTheme.color,
          size: 32.0,
        ),
        shape: CircleBorder(),
      ),
    );
  }

  void onFinishLocationSelection(BuildContext context) {
    Navigator.of(context).pop(_centerPoint);
  }

  Future<void> onMyLocationClick(BuildContext context) async {
    final location = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(location.latitude, location.longitude), zoom: 20.0),
    ));
  }
}
