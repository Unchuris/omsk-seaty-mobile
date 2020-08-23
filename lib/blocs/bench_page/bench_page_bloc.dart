import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:omsk_seaty_mobile/http.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/model/ui_bench.dart';

part 'bench_page_event.dart';
part 'bench_page_state.dart';

class BenchPageBloc extends Bloc<BenchPageEvent, BenchPageState> {
  BenchPageBloc() : super(BenchPageInitial());

  @override
  Stream<BenchPageState> mapEventToState(
    BenchPageEvent event,
  ) async* {
    if (event is GetBenchEvent) {
      try {
        yield BenchPageLoading();
        final responce = await dio.get("/comments/${event.benchId}");
        var uiBench = UiBench.fromJson(responce.data);
        yield BenchPageInitialed(benchUi: uiBench);
      } catch (e) {}
    }
  }
}
