part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class GetFavoritesEvent extends FavoritesEvent {
  const GetFavoritesEvent();

  @override
  List<Object> get props => [];
}
