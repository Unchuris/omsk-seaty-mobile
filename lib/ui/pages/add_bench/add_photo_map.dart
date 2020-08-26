import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/blocs/add_image/add_image_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/geopoint.dart';
import 'package:omsk_seaty_mobile/ui/utils/geocoder.dart';

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

  @override
  void initState() {
    super.initState();
    _centerPoint = widget.startPoint ?? GeoPoint(latitude: 55, longitude: 73);
    _animationController = AnimationController(
        duration: Duration(seconds: 1, milliseconds: 300), vsync: this);
    _markerAnimation = _animationController.drive(
      Tween<double>(
        begin: 280,
        end: 32,
      ),
    );
    _animationController.reset();
    _markerAnimation.addListener(() {
      setState(() {});
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onCameraMove: (camera) => onCameraPositionChanged(context, camera),
          myLocationEnabled: true,
          onMapCreated: (controller) {
            _mapController = controller;
            _mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                    target:
                        LatLng(_centerPoint.latitude, _centerPoint.longitude),
                    zoom: 20.0),
              ),
            );
          },
          initialCameraPosition: CameraPosition(
              target: LatLng(_centerPoint.latitude, _centerPoint.longitude)
          ),
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
            height: 80,
            color: Colors.white,
            child: Center(child: _buildAddressText(context)),
          ),
          Container(color: Theme.of(context).accentColor, height: 1)
        ]),
        Container(
            margin: EdgeInsets.all(16),
            child: Align(
                child: FloatingActionButton(
                    child: Icon(Icons.forward,
                        color: Theme.of(context).iconTheme.color),
                    onPressed: () => onFinishLocationSelection(context)),
                alignment: Alignment.bottomLeft))
      ],
    );
  }

  Widget _buildAddressText(BuildContext context) {
    return FutureBuilder(
        future: getAddressString(_centerPoint),
        builder: (context, AsyncSnapshot<String> snapshot) =>
            Text(snapshot?.data ?? "", style: Theme.of(context).textTheme.headline4));
  }

  void onCameraPositionChanged(BuildContext context, CameraPosition position) {
    final geoPoint = GeoPoint(
        latitude: position.target.latitude,
        longitude: position.target.longitude);
    setState(() {
      debugPrint(geoPoint.toString());
      _centerPoint = geoPoint;
    });
  }

  void onFinishLocationSelection(BuildContext context) {
    Navigator.of(context).pop(_centerPoint);
  }
}
