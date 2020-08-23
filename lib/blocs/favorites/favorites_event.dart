part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class GetFavoritesEvent extends FavoritesEvent {
  final String uid;
  const GetFavoritesEvent({this.uid});

  @override
  List<Object> get props => [uid];
}
