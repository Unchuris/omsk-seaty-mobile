import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/data/repositories/geolocation_repository.dart';
import 'package:omsk_seaty_mobile/data/repositories/marker_repository.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/ui/pages/favorites/favorites.dart';
import 'package:omsk_seaty_mobile/ui/pages/map.dart';
import 'package:omsk_seaty_mobile/ui/pages/profile/profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MapBloc mapBloc = MapBloc(
      repository: MarkerRepository(),
      geolocationRepository: GeolocationRepository());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omsk Seaty',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      supportedLocales: [Locale('en', 'US'), Locale('ru', 'RU')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      initialRoute: '/',
      routes: {
        '/': (context) => BlocProvider<MapBloc>(
              // добавляю в контекст BLoC с картой дабы в mapScreen можно было ссылаться на него
              create: (context) => mapBloc,

              child: MapScreen(),
            ),
        '/profile': (context) => ProfilePage(),
        FavoritesPage.roateName: (context) => BlocProvider.value(
              // добавляю в контекст BLoC с картой дабы в mapScreen можно было ссылаться на него
              value: mapBloc,

              child: FavoritesPage(),
            ),
      },
    );
  }
}
