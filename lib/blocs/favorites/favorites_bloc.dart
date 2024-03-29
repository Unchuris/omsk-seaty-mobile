import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:omsk_seaty_mobile/ui/pages/favorites/model/ui_bench_card.dart';

import '../../http.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial());

  @override
  Stream<FavoritesState> mapEventToState(
    FavoritesEvent event,
  ) async* {
    if (event is GetFavoritesEvent) {
      try {
        yield FavoritesPageLoading();
        final response = await dio.get("/favorites/");
        var data = response.data['favorites'];
        List<UIBencCard> uiBench =
            List<UIBencCard>.from(data.map((i) => UIBencCard.fromJson(i)));

        yield FavoritesPageInitialed(benchCard: uiBench);
      } on DioError catch (e) {
        if (e.response == null) {
          yield FavoritesPageError();
        } else if (e.response.statusCode == 403) {
          yield FavoritesPage403();
        } else {
          yield FavoritesPageError();
        }
      }
    }
  }
}
