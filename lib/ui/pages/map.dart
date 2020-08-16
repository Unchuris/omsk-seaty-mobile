import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/rightdrawer/right_draver_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/map_marker.dart';

import 'package:omsk_seaty_mobile/ui/widgets/app_drawer.dart';

import 'package:omsk_seaty_mobile/ui/widgets/bench_slider.dart';
import 'package:omsk_seaty_mobile/ui/widgets/bench_card.dart';
import 'package:omsk_seaty_mobile/ui/widgets/right_drawer.dart';

class MapScreen extends StatefulWidget {
  final String routeName = "Карта";

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin {
  final Completer<GoogleMapController> _controller = Completer();
  List<MapMarker> _benches;
  List<MapMarker> _favorites = [];
  Map<MarkerId, Marker> _markers;
  final CarouselControllerImpl _carouselController = CarouselController();
  double _currentZoom = 10.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RightDraverBloc _rightDraverBloc = RightDraverBloc();
  Map<String, bool> _checkBox = {
    "Высокий комфорт": false,
    "Урна рядом": false,
    "Стол рядом": false,
    "Крытая лавочка": false,
    "Для большой компании": false,
    "Живописный вид": false,
    "Остановка": false
  };
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      body: MultiBlocListener(
        listeners: [
          BlocListener<MapBloc, MapState>(listener: (context, state) {
            if (state is MapCurrentLocationUpdatedState) {
              print(state.toString());
              _controller.future.then((controller) {
                controller.animateCamera(CameraUpdate.newLatLngZoom(
                    LatLng(state.position.latitude, state.position.longitude),
                    16));
              });
            }
          }),
        ],
        child: Stack(
          children: <Widget>[
            BlocBuilder<MapBloc, MapState>(
              buildWhen: (previous, current) {
                if (current is MarkersInitialed ||
                    current is MapMarkerPressedState ||
                    current is LikeButtonPassState) {
                  return true;
                } else {
                  return false;
                }
              },
              builder: (context, state) {
                if (state is MarkersInitialed) {
                  print(state.toString());
                  _markers = state.markers;
                } else if (state is MapMarkerPressedState) {
                  print(state.toString());
                  if (_benches != null) {
                    _carouselController.jumpToPage(0);
                  }
                  _benches = state.markers;
                } else if (state is LikeButtonPassState) {
                  print(state.toString());
                  _favorites = state.favorites;

                  BlocProvider.of<MapBloc>(context).add(LikeUpdatingEvent());
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
                      minMaxZoomPreference: const MinMaxZoomPreference(10, 21),
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
              bottom: 220,
              left: 5,
              child: _buildMyLocation(),
            ),
            Positioned(
              top: 51,
              left: 0,
              child: Container(
                width: 63,
                height: 56,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0))),
                child: IconButton(
                  icon: SvgPicture.asset("assets/menu.svg"),
                  onPressed: () => _scaffoldKey.currentState.openDrawer(),
                ),
              ),
            ),
            BlocBuilder<MapBloc, MapState>(
              builder: (context, state) {
                if (state is FindButtonPressingState) {
                  _checkBox = state.checkBox;
                }
                return Positioned(
                  top: 51,
                  right: 0,
                  child: Container(
                    width: 63,
                    height: 56,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            bottomLeft: Radius.circular(50.0))),
                    child: IconButton(
                      icon: SvgPicture.asset("assets/fulter.svg",
                          color: (_checkBox.containsValue(true))
                              ? Color(0xff000000)
                              : Color(0xff828282)),
                      onPressed: () =>
                          _scaffoldKey.currentState.openEndDrawer(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      drawer: BlocBuilder<MapBloc, MapState>(builder: (context, state) {
        if (state is LikeButtonPassState) {
          return AppDrawer(_favorites);
        }
        return AppDrawer(_favorites);
      }),
      endDrawer: BlocProvider(
        create: (context) => RightDraverBloc(),
        child: FilterDrawer(
          checkBoxs: _checkBox,
        ),
      ),
    );
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
            } else {
              BlocProvider.of<MapBloc>(context)
                  .add(ButtonGetCurrentLocationPassedEvent());
            }
          }),
    );
  }

  void _onCameraMove(CameraPosition cameraPosition) {
    _currentZoom = cameraPosition.zoom;
  }

  void _onCameraIdle() {
    _controller.future.then((value) async {
      var l = await value.getVisibleRegion();
      var cameraPosition =
          CameraCurrentPosition(currentZoom: _currentZoom, visibleRegion: l);
      BlocProvider.of<MapBloc>(context).setCameraPosition(cameraPosition);
    });
  }

  void _onBenchSliderPageChanged(int index) {}

  void _onBenchSliderItemClicked(int index) {}

  List<Widget> _getData(List<MapMarker> markers) => markers
      .map((item) => BenchCard(
            marker: item,
          ))
      .toList();

  @override
  bool get wantKeepAlive => true;
}
