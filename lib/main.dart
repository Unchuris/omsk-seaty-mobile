import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/data/repositories/geolocation_repository.dart';
import 'package:omsk_seaty_mobile/data/repositories/marker_repository.dart';
import 'package:omsk_seaty_mobile/ui/pages/map_screen.dart';

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
      initialRoute: MapScreen().routeName,
      routes: {
        MapScreen().routeName: (context) => BlocProvider<MapBloc>(
              // добавляю в контекст BLoC с картой дабы в mapScreen можно было ссылаться на него
              create: (context) => mapBloc,

              child: MapScreen(),
            ),
      },
    );
  }
}
