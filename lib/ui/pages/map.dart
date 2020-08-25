import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_effect.dart';
import 'package:omsk_seaty_mobile/data/models/bench_light.dart';
import 'package:omsk_seaty_mobile/data/models/bench_type.dart';

import 'package:omsk_seaty_mobile/ui/widgets/app_drawer.dart';

import 'package:omsk_seaty_mobile/ui/widgets/bench_slider.dart';
import 'package:omsk_seaty_mobile/ui/widgets/right_drawer.dart';

import 'bench/bench.dart';
import 'favorites/favorites.dart';

class MapScreen extends StatefulWidget {
  final String routeName = "Карта";

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin {
  static const DEFAULT_ZOOM_SIZE = 16.0;
  final Completer<GoogleMapController> _controller = Completer();
  final CarouselControllerImpl _carouselController = CarouselController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // ignore: close_sinks
    final blocMap = BlocProvider.of<MapBloc>(context);

    return Material(
        child: MultiBlocListener(
      listeners: [
        BlocListener<MapBloc, MapState>(listener: (context, effect) async {
          if (effect is UpdateUserLocationEffect) {
            await _controller.future.then((controller) {
              controller.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(effect.position.latitude, effect.position.longitude),
                  DEFAULT_ZOOM_SIZE));
            });
            return;
          }
          if (effect is CameraMoveEffect) {
//              setState(() {
//                _isVisible = false;
//              });
          }
          if (effect is CameraIdleEffect) {
//              setState(() {
//                _isVisible = true;
//              });
          }
        }),
      ],
      child: Stack(
        children: <Widget>[
          StreamBuilder<Set<FilterType>>(
              stream: blocMap.filters,
              builder: (context, snapshotFilter) =>
                  StreamBuilder<Map<String, Marker>>(
                      stream: blocMap.markers,
                      builder: (context, snapshotMarkers) =>
                          StreamBuilder<List<BenchLight>>(
                              stream: blocMap.benches,
                              builder: (context, snapshotBenches) {
                                return Scaffold(
                                  key: _scaffoldKey,
                                  body: Stack(children: [
                                    _getGoogleMap(snapshotMarkers.data),
                                    _getBenchSlider(snapshotBenches.data),
                                    _getMenuButton(context),
                                    _getFilterButton(context),
                                    Positioned(
                                        bottom: 56,
                                        right: 0,
                                        child: Column(
                                          children: [
                                            _buildMyLocation(context),
                                            Container(
                                              margin: EdgeInsets.only(top: 26),
                                              child:
                                                  _buildAddBenchButton(context),
                                            ),
                                          ],
                                        )),
                                  ]),
                                  //TODO remove mock favorites
                                  drawer: AppDrawer([]),
                                  endDrawer: FilterDrawer(
                                      filters: snapshotFilter.data != null
                                          ? snapshotFilter.data
                                          : Set()),
                                  drawerEnableOpenDragGesture: false,
                                  endDrawerEnableOpenDragGesture: false,
                                );
                              }))),
        ],
      ),
    ));
  }

  //TODO add dark style
  void _onMapCreated(GoogleMapController controller) {
    rootBundle.loadString("assets/map-style.json").then((style) {
      controller.setMapStyle(style);
      _controller.complete(controller);
      BlocProvider.of<MapBloc>(context).add(OnMapCreatedEvent());
    });
  }

  Widget _buildMyLocation(BuildContext context) {
    return RawMaterialButton(
      onPressed: () => BlocProvider.of<MapBloc>(context)
          .add(OnMapLocationButtonClickedEvent()),
      elevation: 8.0,
      fillColor: Theme.of(context).buttonColor,
      child: SvgPicture.asset("assets/ic_location.svg"),
      padding: EdgeInsets.only(left: 19.0, right: 19.0, top: 15, bottom: 15),
      shape: CircleBorder(),
    );
  }

  Widget _buildAddBenchButton(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        Navigator.pushNamed(context, '/add_bench');
      },
      elevation: 8.0,
      fillColor: Theme.of(context).buttonColor,
      child: SvgPicture.asset("assets/ic_add_bench.svg"),
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10, bottom: 10),
      shape: CircleBorder(),
    );
  }

  Widget _getGoogleMap(Map<String, Marker> data) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
          //TODO move to const
          target: LatLng(54.991351, 73.364528),
          zoom: 10),
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      onMapCreated: _onMapCreated,
      onCameraMoveStarted: _onCameraMoveStarted,
      onCameraIdle: _onCameraIdle,
      markers: (data != null) ? Set<Marker>.from(data.values) : Set(),
      //TODO move to const
      minMaxZoomPreference: const MinMaxZoomPreference(10, 21),
    );
  }

  Widget _getBenchSlider(List<BenchLight> benches) {
    return Visibility(
        visible: _isVisible,
        child: (benches != null && benches.isNotEmpty)
            ? Container(
                padding: EdgeInsets.only(bottom: 20.0),
                alignment: Alignment.bottomCenter,
                child: BenchSlider(
                    items: benches,
                    options: BenchSliderOptions(
                      // TODO добавить бесконечную прокрутки, если выбран не кластер
                      height: 200,
                      onPageChanged: _onBenchSliderPageChanged,
                      onItemClicked: _onBenchSliderItemClicked,
                    ),
                    carouselController: _carouselController))
            : Container());
  }

  Widget _getMenuButton(BuildContext context) {
    return Positioned(
        top: 51,
        left: -24,
        child: ButtonTheme(
          minWidth: 63.0,
          height: 56.0,
          child: RawMaterialButton(
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
            elevation: 14.0,
            fillColor: Theme.of(context).canvasColor,
            child: SvgPicture.asset("assets/menu.svg"),
            padding: EdgeInsets.only(left: 18, top: 20, bottom: 20),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(50))),
          ),
        ));
  }

  Widget _getFilterButton(BuildContext context) {
    return Positioned(
        top: 51,
        right: -24,
        child: ButtonTheme(
          minWidth: 63.0,
          height: 56.0,
          child: RawMaterialButton(
            onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
            elevation: 14.0,
            fillColor: Theme.of(context).canvasColor,
            child: SvgPicture.asset("assets/fulter.svg"),
            padding: EdgeInsets.only(right: 14, top: 16, bottom: 16),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(50))),
          ),
        ));
  }

  void _onCameraMoveStarted() {
    BlocProvider.of<MapBloc>(context).add(OnCameraMoveStartedEvent());
  }

  void _onCameraIdle() {
    _controller.future.then((value) async {
      LatLngBounds latLngBounds = await value.getVisibleRegion();
      double zoom = await value.getZoomLevel();
      CameraCurrentPosition cameraPosition =
          CameraCurrentPosition(currentZoom: zoom, visibleRegion: latLngBounds);
      BlocProvider.of<MapBloc>(context)
          .add(OnCameraIdleEvent(cameraPosition: cameraPosition));
    });
  }

  void _onBenchSliderPageChanged(BenchLight benchLight) {
    BlocProvider.of<MapBloc>(context)
        .add(OnBenchSliderPageChanged(bench: benchLight));
  }

  void _onBenchSliderItemClicked(BenchLight benchLight) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BenchPage(
                  benchId: benchLight.id,
                )));
  }

  @override
  bool get wantKeepAlive => true;
}
