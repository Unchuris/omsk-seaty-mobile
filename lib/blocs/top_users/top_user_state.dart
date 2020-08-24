part of 'top_user_bloc.dart';

abstract class TopUserState extends Equatable {
  const TopUserState();

  @override
  List<Object> get props => [];
}

class TopuserInitial extends TopUserState {}

class TopUserPageLoading extends TopUserState {
  const TopUserPageLoading();

  @override
  List<Object> get props => [];
}

class TopUserPageInitialed extends TopUserState {
  final List<UiTopUser> uiTopUsers;
  const TopUserPageInitialed({this.uiTopUsers});

  @override
  List<Object> get props => [];
}

class TopUserPageError extends TopUserState {
  const TopUserPageError();

  @override
  List<Object> get props => [];
}
