import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/ui/widgets/app_drawer.dart';

class MapScreen extends StatefulWidget {
  final String routeName = "Карта";
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  String _style;
  Map<MarkerId, Marker> _markers;
  double _currentZoom = 10.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: MultiBlocListener(
          listeners: [
            BlocListener<MapBloc, MapState>(listener: (context, state) async {
              if (state is MapCurrentLocationUpdatedState) {
                print(state.toString());
                await _controller.future.then((controller) {
                  controller.animateCamera(CameraUpdate.newLatLngZoom(
                      LatLng(state.position.latitude, state.position.longitude),
                      16));
                });
              }
              if (state is MapInitial) {
                print(state.toString());
              }

              if (state is MapCurrentLocationUpdatingState) {
                print(state.toString());
              }
            }),
          ],
          child: Stack(
            children: <Widget>[
              StreamBuilder(
                stream: BlocProvider.of<MapBloc>(context).markers,
                builder: (context, snapshot) {
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(54.991351, 73.364528), zoom: 10),
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    onMapCreated: _onMapCreated,
                    onCameraMove: _onCameraMove,
                    onCameraIdle: _onCameraIdle,
                    markers: (snapshot.data != null)
                        ? Set<Marker>.from(snapshot.data.values)
                        : Set(),
                    minMaxZoomPreference: const MinMaxZoomPreference(10, 21),
                  );
                },
              ),
              Positioned(
                bottom: 30,
                left: 5,
                child: _buildMyLocation(),
              ),
              Positioned(
                top: 30,
                left: 5,
                child: SizedBox(
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => _scaffoldKey.currentState.openDrawer(),
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: AppDrawer());
  }

  void _onMapCreated(GoogleMapController controller) {
    rootBundle.loadString("assets/map-style.json").then((style) {
      controller.setMapStyle(style);
      _controller.complete(controller);
    });
  }

  //создаю кнопку мое местоположение
  Widget _buildMyLocation() {
    return SizedBox(
      child: IconButton(
          icon: Icon(Icons.my_location),
          onPressed: () {
            var state = BlocProvider.of<MapBloc>(context).state;
            print(state.toString());
            if (state is MapCurrentLocationUpdatingState) {
              print("много нажал");
            } else {
              BlocProvider.of<MapBloc>(context)
                  .add(ButtonGetCurrentLocationPassedEvent());
            }
          }),
    );
  }

  void _onCameraMove(CameraPosition cameraPosition) {
    _currentZoom = cameraPosition.zoom;

//    print("зум поменялся");
  }

  void _onCameraIdle() {
    BlocProvider.of<MapBloc>(context).setCameraZoom(_currentZoom);
    _controller.future.then((value) async {
      var l = await value.getVisibleRegion();
      BlocProvider.of<MapBloc>(context).setVisibleRegion(l);
    });
    print("камера остановилась");
  }

  @override
  void dispose() {
    super.dispose();
  }
}
