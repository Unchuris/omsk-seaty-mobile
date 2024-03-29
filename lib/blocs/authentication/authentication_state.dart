part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationStart extends AuthenticationState {
  @override
  String toString() => 'Authenticated start }';
}

class AuthenticationSuccess extends AuthenticationState {
  final User user;

  const AuthenticationSuccess(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Authenticated { displayName: ${user.displayName} }';
}

class AuthenticationFailure extends AuthenticationState {
  @override
  String toString() => 'Authenticated faile}';
}

class AuthenticationInProgress extends AuthenticationState {
  @override
  String toString() => 'Authenticated in progress}';
}
