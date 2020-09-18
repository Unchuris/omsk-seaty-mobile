import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_effect.dart';
import 'package:omsk_seaty_mobile/data/models/bench_light.dart';
import 'package:omsk_seaty_mobile/data/models/bench_type.dart';
import 'package:omsk_seaty_mobile/data/models/slider_benches_ui.dart';
import 'package:omsk_seaty_mobile/ui/utils/geo.dart';
import 'package:omsk_seaty_mobile/ui/widgets/app_drawer.dart';
import 'package:omsk_seaty_mobile/ui/widgets/bench_slider.dart';
import 'package:omsk_seaty_mobile/ui/widgets/right_drawer.dart';
import 'package:omsk_seaty_mobile/ui/widgets/snackbar.dart';

import '../../app_localizations.dart';
import 'bench/bench.dart';
import 'login_error.dart';

class MapScreen extends StatefulWidget {
  final String routeName = "Карта";

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin {
  static const MIN_ZOOM_SIZE = 10.0;
  static const DEFAULT_ZOOM_SIZE = 16.0;
  static const MAX_ZOOM_SIZE = 19.0;
  final Completer<GoogleMapController> _controller = Completer();
  final CarouselControllerImpl _carouselController = CarouselController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isVisibleHelpElements = true;
  bool _isCloseBottomSheet = true;
  bool isLoading = true;
  SliderBenchesUi _sliderBenchesUi;
  PersistentBottomSheetController _bottomSheetController;

  @override
  Widget build(BuildContext context) {
    final blocMap = BlocProvider.of<MapBloc>(context);

    return Material(
        child: MultiBlocListener(
      listeners: [
        BlocListener<MapBloc, MapState>(listener: (context, effect) async {
          if (effect is LoadDataFailture) {
            if (isLoading) {
              setState(() {
                isLoading = false;
              });
            }
            _scaffoldKey.currentState.showSnackBar(getSnackBarError(
                AppLocalizations.of(context)
                    .translate("network_connection_error"),
                context));
            return;
          }
          if (effect is Loading) {
            if (!isLoading) {
              setState(() {
                isLoading = true;
              });
            }
            return;
          }
          if (effect is UpdateUserLocationEffect) {
            await _controller.future.then((controller) {
              controller.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(effect.position.latitude, effect.position.longitude),
                  DEFAULT_ZOOM_SIZE));
            });
            return;
          }
          if (effect is CameraMoveEffect) {
            return;
          }
          if (effect is CameraIdleEffect) {
            if (effect.onMarkerTaped != true) return;
            //TODO не самый лучший код, на методы разбить хотябы ¯\_(ツ)_/¯
            if (_sliderBenchesUi == null &&
                effect.sliderBenchesUi.benches.isEmpty) {
              return;
            }
            if (_sliderBenchesUi == null || _isCloseBottomSheet) {
              _isCloseBottomSheet = false;
              if (_isVisibleHelpElements) {
                setState(() {
                  _isVisibleHelpElements = false;
                });
              }
              _bottomSheetController = _scaffoldKey.currentState
                  .showBottomSheet(
                      (context) => _getBenchSlider(effect.sliderBenchesUi));
              _sliderBenchesUi = SliderBenchesUi.from(effect.sliderBenchesUi);
              _bottomSheetController.closed.then((value) {
                _isCloseBottomSheet = true;
                if (!_isVisibleHelpElements) {
                  setState(() {
                    _isVisibleHelpElements = true;
                  });
                }
              });
              return;
            }
            //Скрывать диалог, если нечего показывать
            if (effect.sliderBenchesUi.benches.isEmpty) {
              _sliderBenchesUi = null;
              if (_bottomSheetController != null) {
                _bottomSheetController.close();
              }
              return;
            }
            //Нажали на маркер и надо обновить список
            if (_bottomSheetController != null) {
              _bottomSheetController?.setState(() {
                _sliderBenchesUi = SliderBenchesUi.from(effect.sliderBenchesUi);
              });
            }
            return;
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
                      builder: (context, snapshotMarkers) {
                        if (snapshotMarkers != null &&
                            snapshotMarkers.data != null) {
                          isLoading = false;
                        }
                        return Scaffold(
                          key: _scaffoldKey,
                          body: Stack(children: [
                            _getGoogleMap(snapshotMarkers.data),
                            _getMenuButton(context),
                            _getFilterButton(context),
                            Align(
                                alignment: Alignment.center,
                                child: isLoading
                                    ? CircularProgressIndicator()
                                    : SizedBox.shrink()),
                            Positioned(
                                bottom: 56,
                                right: 0,
                                child: Column(
                                  children: [
                                    _buildMyLocation(context),
                                    Container(
                                      margin: EdgeInsets.only(top: 26),
                                      child: _buildAddBenchButton(context),
                                    ),
                                  ],
                                ))
                          ]),
                          drawer: AppDrawer(),
                          endDrawer: FilterDrawer(
                              options: FilterOptions(
                                  onFilterChanged: _onFilterChanged),
                              filters: snapshotFilter.data != null
                                  ? snapshotFilter.data
                                  : Set()),
                          drawerEnableOpenDragGesture: false,
                          endDrawerEnableOpenDragGesture: false,
                        );
                      })),
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
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _isVisibleHelpElements
            ? RawMaterialButton(
                onPressed: () => BlocProvider.of<MapBloc>(context)
                    .add(OnMapLocationButtonClickedEvent()),
                elevation: 8.0,
                fillColor: Theme.of(context).buttonColor,
                child: SvgPicture.asset("assets/ic_location.svg"),
                padding: EdgeInsets.only(
                    left: 19.0, right: 19.0, top: 15, bottom: 15),
                shape: CircleBorder(),
              )
            : SizedBox.shrink());
  }

  Widget _buildAddBenchButton(BuildContext context) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _isVisibleHelpElements
            ? RawMaterialButton(
                onPressed: () {
                  var user = BlocProvider.of<AuthenticationBloc>(context).getUser;
                  if (user == null || user.uid ==""){
                    Navigator.pushNamed(context, ErrorLoginPage.routeName);
                  }
                  else {
                    Navigator.pushNamed(context, '/add_bench');
                  }
                },
                elevation: 8.0,
                fillColor: Theme.of(context).buttonColor,
                child: SvgPicture.asset("assets/ic_add_bench.svg"),
                padding: EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 10, bottom: 10),
                shape: CircleBorder(),
              )
            : SizedBox.shrink());
  }

  Widget _getGoogleMap(Map<String, Marker> data) {
    return GoogleMap(
      initialCameraPosition:
          CameraPosition(target: omskCenterPoint.toLatLng(), zoom: 10),
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      onMapCreated: _onMapCreated,
      onCameraMoveStarted: _onCameraMoveStarted,
      onCameraIdle: _onCameraIdle,
      markers: (data != null) ? Set<Marker>.from(data.values) : Set(),
      minMaxZoomPreference:
          const MinMaxZoomPreference(MIN_ZOOM_SIZE, MAX_ZOOM_SIZE),
    );
  }

  Widget _getBenchSlider(SliderBenchesUi benches) {
    return BenchSlider(
        items: benches.benches,
        options: BenchSliderOptions(
          currentBenches: benches.currentBenches,
          enableInfiniteScroll: !benches.isClusterState,
          height: 200,
          onPageChanged: _onBenchSliderPageChanged,
          onItemClicked: _onBenchSliderItemClicked,
        ),
        carouselController: _carouselController);
  }

  Widget _getMenuButton(BuildContext context) {
    return Positioned(
        top: 51,
        left: -24, //это хак
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
        right: -24, //это хак
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

  void _onFilterChanged(Set<FilterType> _filters) {
    if (_bottomSheetController != null && !_isCloseBottomSheet) {
      _bottomSheetController.close();
    }
    BlocProvider.of<MapBloc>(context)
        .add(OnFilterChangedEvent(filterTypes: _filters));
  }

  void _onBenchSliderPageChanged(BenchLight benchLight, int index) {
    BlocProvider.of<MapBloc>(context)
        .add(OnBenchSliderPageChanged(bench: benchLight, index: index));
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
