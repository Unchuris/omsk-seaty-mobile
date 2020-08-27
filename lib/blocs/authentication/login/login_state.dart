part of 'login_bloc.dart';

class LoginState {
  final bool isSuccess;
  final bool isFailture;
  final bool isLoading;
  LoginState({this.isFailture, this.isSuccess, this.isLoading});

  factory LoginState.initial() {
    return LoginState(isSuccess: false, isFailture: false, isLoading: false);
  }
  factory LoginState.loading() {
    return LoginState(isSuccess: false, isFailture: false, isLoading: true);
  }
  factory LoginState.success() {
    return LoginState(isSuccess: true, isFailture: false, isLoading: false);
  }

  factory LoginState.failture() {
    return LoginState(isSuccess: false, isFailture: true, isLoading: false);
  }
}
