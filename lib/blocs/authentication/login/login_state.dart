part of 'login_bloc.dart';

class LoginState {
  final bool isSuccess;
  final bool isFailture;

  LoginState({this.isFailture, this.isSuccess});

  factory LoginState.initial() {
    return LoginState(isSuccess: false, isFailture: false);
  }

  factory LoginState.success() {
    return LoginState(isSuccess: true, isFailture: false);
  }

  factory LoginState.failture() {
    return LoginState(isSuccess: false, isFailture: true);
  }
}
