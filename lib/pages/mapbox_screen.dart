import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/widgets/custom_drawer.dart';

class MapBoxPage extends StatefulWidget {
  static String routeName = "MapBox";

  @override
  _MapBoxPageState createState() => _MapBoxPageState();
}

class _MapBoxPageState extends State<MapBoxPage> {
  MapboxMapController mapController;
  LatLng userPosition;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: MultiBlocListener(
        listeners: [
          BlocListener<MapBloc, MapState>(listener: (context, state) async {
            if (state is MapCurrentLocationUpdatedState) {
              print(state.toString());
              await mapController
                  .moveCamera(
                    CameraUpdate.newLatLngZoom(
                        LatLng(
                            state.position.latitude, state.position.longitude),
                        15.0),
                  )
                  .then((result) =>
                      print("mapController.animateCamera() returned $result"));
            }
            if (state is MapInitial) {
              print(state.toString());
            }
            if (state is MarkersInitial) {
              print(state.toString());
            }
            if (state is MarkersInitialed) {
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
        child: BlocBuilder<MapBloc, MapState>(builder: (context, mapState) {
          return Stack(children: <Widget>[
            MapboxMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                  target: LatLng(54.991351, 73.364528), zoom: 12.0),
              myLocationEnabled: true,
              myLocationRenderMode: MyLocationRenderMode.GPS,
              compassEnabled: true,
            ),
            Positioned(
              bottom: 15,
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
        currentPage: "Mapbox",
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

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
}
