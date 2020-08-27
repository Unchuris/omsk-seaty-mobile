import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:omsk_seaty_mobile/ui/pages/favorites/model/ui_bench_card.dart';
import '../../http.dart';
part 'top_benches_event.dart';
part 'top_benches_state.dart';

class TopBenchesBloc extends Bloc<TopBenchesEvent, TopBenchesState> {
  TopBenchesBloc() : super(TopBenchesInitial());

  @override
  Stream<TopBenchesState> mapEventToState(
    TopBenchesEvent event,
  ) async* {
    if (event is GetTopBenchesEvent) {
      try {
        yield TopBenchesPageLoading();
        final response = await dio.get("/benches/top/");
        var data = response.data;
        List<UIBencCard> uiBench =
            List<UIBencCard>.from(data.map((i) => UIBencCard.fromJson(i)));

        yield TopBenchesPageInitialed(benchCard: uiBench);
      } on DioError catch (e) {
        yield TopBenchesPageError();
      }
    }
  }
}
