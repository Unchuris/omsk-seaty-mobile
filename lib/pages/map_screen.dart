import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Map<String, Marker> _markers;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: BlocBuilder<MapBloc, MapState>(builder: (contex, mapState) {
          if (mapState is MarkersInitialed) {
            _markers = mapState.markers;
          }
          return Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(54.991351, 73.364528), zoom: 16),
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
                onMapCreated: _onMapCreated,
                markers: Set<Marker>.from(_markers.values),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height - 60,
                left: 5,
                child: _buildMyLocation(),
              ),
            ],
          );
        }),
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
        onPressed: () {
          dynamic state = BlocProvider.of<MapBloc>(context).state;
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

  @override
  void dispose() {
    super.dispose();
  }
}
