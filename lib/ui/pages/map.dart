import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/ui/widgets/app_drawer.dart';
import 'package:omsk_seaty_mobile/data/models/map_marker.dart';
import 'package:omsk_seaty_mobile/ui/widgets/bench_slider.dart';

class MapScreen extends StatefulWidget {
  final String routeName = "Карта";

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> _markers;
  List<MapMarker> _benches;
  double _currentZoom = 10.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CarouselControllerImpl _carouselController = CarouselController();

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
              if (state is MapErrorState) {
                print(state.toString());
              }
            }),
          ],
          child: Stack(
            children: [
              BlocBuilder<MapBloc, MapState>(
                buildWhen: (previous, current) {
                  if (current is MarkersInitialed || current is BenchesState) {
                    return true;
                  } else {
                    return false;
                  }
                },
                builder: (context, state) {
                  if (state is MarkersInitialed) {
                    _markers = state.markers;
                  }
                  if (state is BenchesState) {
                    _benches = state.benches;
                  }
                  return Stack(
                    children: [
                      GoogleMap(
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
                        markers: (_markers != null)
                            ? Set<Marker>.from(_markers.values)
                            : Set(),
                        minMaxZoomPreference:
                            const MinMaxZoomPreference(10, 21),
                      ),
                      (_benches != null)
                          ? Container(
                              padding: EdgeInsets.only(bottom: 20.0),
                              alignment: Alignment.bottomCenter,
                              child: BenchSlider(
                                  items: _getData(_benches),
                                  options: BenchSliderOptions(
                                    height: 200,
                                    onPageChanged: _onBenchSliderPageChanged,
                                    onItemClicked: _onBenchSliderItemClicked,
                                  ),
                                  carouselController: _carouselController))
                          : Container()
                    ],
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
    _controller.complete(controller);
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

  void _onBenchSliderPageChanged(int index) {
    //TODO
  }

  void _onBenchSliderItemClicked(int index) {
    //TODO
  }

  @override
  void dispose() {
    super.dispose();
  }

  //TODO test widgets
  List<Widget> _getData(List<MapMarker> markers) => markers
      .map((item) => Container(
            margin: EdgeInsets.only(top: 5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item.imageUrl,
                        fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          item.locationName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ))
      .toList();
}
