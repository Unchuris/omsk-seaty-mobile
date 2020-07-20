import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/pages/googlemap_screen.dart';
import 'package:omsk_seaty_mobile/pages/mapbox_screen.dart';
import 'package:omsk_seaty_mobile/repositories/geolocation_repository.dart';
import 'package:omsk_seaty_mobile/repositories/marker_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MapBloc mapBloc = MapBloc(
      repository: MarkerRepository(),
      geolocationRepository: GeolocationRepository());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: MapBoxPage.routeName,
      routes: {
        GoogleMapScreen.routeName: (context) => BlocProvider(
              // добавляю в контекст BLoC с картой дабы в mapScreen можно было ссылаться на него
              create: (context) => mapBloc,
              child: GoogleMapScreen(),
            ),
        MapBoxPage.routeName: (context) => BlocProvider(
              // добавляю в контекст BLoC с картой дабы в mapScreen можно было ссылаться на него
              create: (context) => mapBloc,
              child: MapBoxPage(),
            ),
      },
    );
  }
}