import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/bench_page/bench_page_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/data/repositories/geolocation_repository.dart';
import 'package:omsk_seaty_mobile/data/repositories/marker_repository.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';

import 'package:omsk_seaty_mobile/data/repositories/user_repository.dart';
import 'package:omsk_seaty_mobile/ui/pages/add_comment/add_comment.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/bench.dart';
import 'package:omsk_seaty_mobile/ui/pages/login/login.dart';

import 'package:omsk_seaty_mobile/ui/pages/favorites/favorites.dart';

import 'package:omsk_seaty_mobile/ui/pages/map.dart';
import 'package:omsk_seaty_mobile/ui/pages/profile/profile.dart';
import 'package:omsk_seaty_mobile/ui/utils/theme.dart';

import 'http.dart';

void main() async {
  dio.options
    ..baseUrl = "https://8ce1da6f30c6.ngrok.io/api/"
    ..connectTimeout = 5000
    ..receiveTimeout = 5000;

  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository _userRepository = UserRepository();
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  final bool isSigned =
      await _userRepository.isSignedIn() || await _userRepository.isSkipped();
  //runZoned(() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
            create: (context) =>
                AuthenticationBloc(userRepository: _userRepository)
                  ..add(AuthenticationStarted())),
        BlocProvider<MapBloc>(
            create: (context) => MapBloc(
                repository: MarkerRepository(),
                geolocationRepository: GeolocationRepository()))
      ],
      child: MyApp(userRepository: _userRepository, isSigned: isSigned),
    ),
  );
  //}, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;
  final bool _isSigned;

  MyApp(
      {Key key,
      @required UserRepository userRepository,
      @required bool isSigned})
      : assert(userRepository != null, isSigned != null),
        _userRepository = userRepository,
        _isSigned = isSigned,
        super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omsk Seaty',
      theme: lightTheme(),
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
      initialRoute: _isSigned ? '/map' : '/login',
      routes: {
        '/login': (context) => LoginScreen(userRepository: _userRepository),
        '/map': (context) => MapScreen(),
        '/profile': (context) => ProfilePage(),
        AddCommentPage.routeName: (context) => AddCommentPage(),
        FavoritesPage.roateName: (context) => FavoritesPage(),
        BenchPage.routeName: (context) => BenchPage(),
      },
    );
  }
}
