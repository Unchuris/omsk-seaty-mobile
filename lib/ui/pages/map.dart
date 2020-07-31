import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/ui/widgets/app_drawer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapScreen extends StatefulWidget {
  final String routeName = "Карта";
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> _markers;
  PanelController _pc = PanelController();
  double _currentZoom = 10.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;
  double _fabHeight = 240.0;
  double _initFabHeight = 240.0;
  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    _panelHeightClosed = MediaQuery.of(context).size.height * .35;
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
              if (state is MapMarkerPressedState) {
                setState(() {
                  _pc.show();
                });
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
            children: <Widget>[
              SlidingUpPanel(
                maxHeight: _panelHeightOpen,
                minHeight: _panelHeightClosed,
                controller: _pc,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
                parallaxEnabled: false,
                panelBuilder: (sc) => _panel(sc),
                onPanelSlide: (double pos) => setState(() {
                  _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                      _initFabHeight;
                }),
                body: Stack(
                  children: [
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
                          onTap: _onTap,
                          markers: (snapshot.data != null)
                              ? Set<Marker>.from(snapshot.data.values)
                              : Set(),
                          minMaxZoomPreference:
                              const MinMaxZoomPreference(10, 21),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: _fabHeight,
                left: 5,
                child: SizedBox(
                  child: IconButton(
                      icon: Icon(Icons.my_location),
                      onPressed: () {
                        var state = BlocProvider.of<MapBloc>(context).state;
                        print(state.toString());
                        if (state is MapCurrentLocationUpdatingState) {
                        } else {
                          BlocProvider.of<MapBloc>(context)
                              .add(ButtonGetCurrentLocationPassedEvent());
                        }
                      }),
                ),
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

  void _onCameraMove(CameraPosition cameraPosition) {
    _currentZoom = cameraPosition.zoom;

    print("зум поменялся");
  }

  void _onCameraIdle() {
    BlocProvider.of<MapBloc>(context).setCameraZoom(_currentZoom);
    _controller.future.then((value) async {
      var l = await value.getVisibleRegion();
      BlocProvider.of<MapBloc>(context).setVisibleRegion(l);
    });
    print("камера остановилась");
  }

  void _onTap(LatLng point) {
    BlocProvider.of<MapBloc>(context).add(MapTapEvent());
  }

  Widget _panel(ScrollController sc) {
    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
      if (state is MapMarkerPressedState) {
        return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              controller: sc,
              children: [
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.0,
                ),
                Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width * .90,
                      height: MediaQuery.of(context).size.height * .28,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  "https://m.bk55.ru/fileadmin/bkinform/image/2017/12/29/1514539988/9c572fa5eeb303b8e665d6f7e1430e2f.jpg"),
                              fit: BoxFit.cover),
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * .90,
                                height:
                                    MediaQuery.of(context).size.height * .10,
                                padding: EdgeInsets.only(top: 20, left: 30),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0)),
                                    color: Color.fromRGBO(0, 0, 0, 0.5)),
                                child: Text(
                                  state.marker.locationName,
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontSize: 18.5,
                                      fontFamily: "Roboto"),
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                )
              ],
            ));
      } else {
        _pc.hide();

        return Center();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
