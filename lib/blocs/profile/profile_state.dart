
import 'package:equatable/equatable.dart';
import 'package:omsk_seaty_mobile/data/models/user_info.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {
  const ProfileLoading();

  @override
  List<Object> get props => [];
}

class ProfileSuccess extends ProfileState {
  final UserInfo userInfo;
  const ProfileSuccess({this.userInfo});

  @override
  List<Object> get props => [];
}

class ProfileError extends ProfileState {
  const ProfileError();

  @override
  List<Object> get props => [];
}
