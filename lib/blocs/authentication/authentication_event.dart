part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {}

class AuthenticationSkipped extends AuthenticationEvent {}

class AuthenticationLoggedOut extends AuthenticationEvent {}

class LoginWithGooglePressed extends AuthenticationEvent {}
