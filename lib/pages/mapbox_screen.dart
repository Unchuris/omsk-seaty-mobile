import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/models/benches.dart';
import 'package:omsk_seaty_mobile/widgets/custom_drawer.dart';

class MapBoxPage extends StatefulWidget {
  static String routeName = "MapBox";

  @override
  _MapBoxPageState createState() => _MapBoxPageState();
}

class _MapBoxPageState extends State<MapBoxPage> {
  Completer<MapboxMapController> mapController = Completer();
  Symbol _selectedSymbol;
  bool isSelected = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onMapCreated(MapboxMapController controller) {
    mapController.complete(controller);
    controller.onSymbolTapped.add(_onSymbolTapped);
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
              await mapController.future
                  .then((mapController) => mapController.moveCamera(
                        CameraUpdate.newLatLngZoom(
                            LatLng(state.position.latitude,
                                state.position.longitude),
                            18.0),
                      ));
            } else if (state is MapInitial) {
              print(state.toString());
            } else if (state is MarkersInitial) {
              print(state.toString());
            } else if (state is MarkersInitialed) {
              await addImageFromAsset('pin', 'assets/pin.png');
              await addImageFromAsset('selectedpin', 'assets/selected-pin.png');
              await addImageFromAsset('pin1', 'assets/pin1.png');
              state.benches.forEach((element) {
                mapController.future.then((mapController) =>
                    mapController.addSymbol(_getSymbolOptions(element)));
              });

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
              onMapClick: _onMapClick,
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
          //BlocProvider.of<MapBloc>(context).add(MapMarkerInitialing());
        },
        child: Icon(Icons.pages),
      ),
    );
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.future
        .then((mapController) => mapController.addImage(name, list, true));
  }

  SymbolOptions _getSymbolOptions(Benches bench) {
    return SymbolOptions(
        geometry: LatLng(bench.latitude, bench.longitude),
        iconSize: 0.2,
        iconOffset: Offset(0, -60.0),
        iconImage: "pin1");
  }

  void _onSymbolTapped(Symbol symbol) {
    if (_selectedSymbol != null) {
      mapController.future.then((mapController) => mapController.moveCamera(
          CameraUpdate.newLatLng(LatLng(symbol.options.geometry.latitude,
              symbol.options.geometry.longitude))));
      _updateSelectedSymbol(
        SymbolOptions(
          iconImage: "pin1",
          iconColor: "#ffff00",
          iconSize: 0.2,
          iconOffset: Offset(0, -60.0),
        ),
      );
    }
    setState(() {
      _selectedSymbol = symbol;
    });

    _updateSelectedSymbol(
      SymbolOptions(
        iconImage: "pin1",
        iconColor: "#ff0000",
        iconSize: 0.2,
        iconOffset: Offset(0, -60.0),
      ),
    );
  }

  void _updateSelectedSymbol(SymbolOptions changes) async {
    await mapController.future.then((mapController) =>
        mapController.updateSymbol(_selectedSymbol, changes));
  }

  void _onMapClick(Point<double> point, LatLng coordinates) {
    /*   if (_selectedSymbol != null &&
        ((_selectedSymbol.options.geometry.latitude * 1000 % 10).round()) !=
            (coordinates.latitude * 1000 % 10).round() &&
        (_selectedSymbol.options.geometry.longitude * 1000 % 10).round() !=
            (coordinates.longitude * 1000 % 10).round()) {
      _updateSelectedSymbol(
        SymbolOptions(
          iconImage: "pin1",
          iconColor: "#ffff00",
          iconSize: 0.2,
          iconOffset: Offset(0, -60.0),
        ),
      );
    }
    print("Point $point");
    print(
        "Координаты тапа ${(coordinates.latitude * 1000 % 10).round()} ${(coordinates.longitude * 1000 % 10).round()}");
    print(
        "Координаты лавочки ${(_selectedSymbol.options.geometry.latitude * 1000 % 10).round()} ${(_selectedSymbol.options.geometry.longitude * 1000 % 10).round()}"); */
  }
}
