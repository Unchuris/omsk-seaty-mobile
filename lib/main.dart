import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/data/repositories/geolocation_repository.dart';
import 'package:omsk_seaty_mobile/data/repositories/marker_repository.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/data/repositories/user_repository.dart';
import 'package:omsk_seaty_mobile/ui/pages/login/login.dart';
import 'package:omsk_seaty_mobile/ui/pages/map.dart';
import 'package:omsk_seaty_mobile/ui/pages/profile/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository _userRepository = UserRepository();
  final bool isLogged = await _userRepository.isSignedIn();
  runApp(BlocProvider(
    create: (context) => AuthenticationBloc(userRepository: _userRepository)
      ..add(AuthenticationStarted()),
    child: MyApp(userRepository: _userRepository, isLogged: isLogged),
  ));
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;
  final bool _isLogged;

  MyApp(
      {Key key,
      @required UserRepository userRepository,
      @required bool isLogged})
      : assert(userRepository != null, isLogged != null),
        _userRepository = userRepository,
        _isLogged = isLogged,
        super(key: key);

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
      initialRoute: _isLogged ? '/map' : '/login',
      routes: {
        '/login': (context) => LoginScreen(userRepository: _userRepository),
        '/map': (context) => BlocProvider<MapBloc>(
              // добавляю в контекст BLoC с картой дабы в mapScreen можно было ссылаться на него
              create: (context) => MapBloc(
                  repository: MarkerRepository(),
                  geolocationRepository: GeolocationRepository()),
              child: MapScreen(),
            ),
        '/profile': (context) => ProfilePage()
      },
    );
  }
}
