import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:omsk_seaty_mobile/data/models/user.dart';
import 'package:omsk_seaty_mobile/data/repositories/user_repository.dart';
import 'package:omsk_seaty_mobile/http.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  User _user;
  User get getUser => _user;
  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedInToState();
    } else if (event is AuthenticationLoggedOut) {
      _userRepository.signOut();
      yield AuthenticationFailure();
    } else if (event is AuthenticationSkipped) {
      yield* _mapAuthenticationSkippedToState();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    yield AuthenticationStart();
    final isSignedIn = await _userRepository.isSignedIn();
    if (isSignedIn) {
      _user = await _userRepository.getUser();
      var response = await dio.post('users/', data: _user.toJson());

      yield AuthenticationSuccess(_user);
    } else {
      yield AuthenticationFailure();
    }
  }

  Stream<AuthenticationState> _mapLoginWithGooglePressedToState() async* {
    try {
      yield AuthenticationInProgress();
      await _userRepository.signInWithGoogle();
      yield* _mapAuthenticationLoggedInToState();
    } catch (_) {
      yield AuthenticationFailure();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedInToState() async* {
    _user = await _userRepository.getUser();
    //TODO что это?)
    var response = await dio.post('users/', data: _user.toJson());

    _userRepository.saveUserToPreferences(_user);
    if (await _userRepository.isSkipped()) _userRepository.removeIsSkipped();
    yield AuthenticationSuccess(_user);
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    _userRepository.signOut();
    yield AuthenticationFailure();
  }

  Stream<AuthenticationState> _mapAuthenticationSkippedToState() async* {
    _userRepository.saveIsSkipped();
  }
}
