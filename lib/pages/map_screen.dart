import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/widgets/custom_drawer.dart';

class MapScreen extends StatefulWidget {
  final String routeName = "Карта";
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> _markers;
  double _currentZoom = 12.0;
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
            if (state is MarkersInitial) {
              print(state.toString());
            }

            if (state is MapCurrentLocationUpdatingState) {
              print(state.toString());
            }
            if (state is MapErrorState) {
              //print(state.toString());
            }
          }),
        ],
        child: StreamBuilder(
            stream: BlocProvider.of<MapBloc>(context).markers,
            builder: (context, snapshot) {
              return Stack(children: <Widget>[
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(54.991351, 73.364528), zoom: 12),
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
                ),
                Positioned(
                  bottom: 30,
                  left: 5,
                  child: _buildMyLocation(),
                ),
                Positioned(
                  top: 20,
                  left: 5,
                  child: _buildHamburger(),
                ),
              ]);
            }),
      ),
      drawer: CustomDrawer(
        currentPage: "Карта",
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  //создаю кнопку мое местоположение
  Widget _buildMyLocation() {
    return SizedBox(
      child: FloatingActionButton(
        heroTag: null,
        backgroundColor: Colors.transparent,
        onPressed: () {
          var state = BlocProvider.of<MapBloc>(context).state;
          print(state.toString());
          if (state is MapCurrentLocationUpdatingState) {
            print("много нажал");
          } else {
            BlocProvider.of<MapBloc>(context)
                .add(ButtonGetCurrentLocationPassedEvent());
          }
        },
        child: Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildHamburger() {
    return SizedBox(
      child: FloatingActionButton(
        heroTag: null,
        backgroundColor: Colors.transparent,
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
        child: Icon(Icons.pages),
      ),
    );
  }

  void _onCameraMove(CameraPosition cameraPosition) {
    _currentZoom = cameraPosition.zoom;
    print("зум поменялся");
  }

  void _onCameraIdle() {
    BlocProvider.of<MapBloc>(context).setCameraZoom(_currentZoom);

    print("камера остановилась");
  }

  @override
  void dispose() {
    super.dispose();
  }
}
