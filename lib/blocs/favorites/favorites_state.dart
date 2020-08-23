part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesPageLoading extends FavoritesState {
  const FavoritesPageLoading();

  @override
  List<Object> get props => [];
}

class FavoritesPageInitialed extends FavoritesState {
  final List<UIBencCard> benchCard;
  const FavoritesPageInitialed({this.benchCard});

  @override
  List<Object> get props => [];
}

class FavoritesPageError extends FavoritesState {
  const FavoritesPageError();

  @override
  List<Object> get props => [];
}
