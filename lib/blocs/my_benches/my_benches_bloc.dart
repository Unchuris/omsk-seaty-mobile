import 'dart:async';
import 'package:dio/dio.dart';

import '../../http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:omsk_seaty_mobile/ui/pages/my_benches/model/my_bench_ui.dart';

part 'my_benches_event.dart';
part 'my_benches_state.dart';

class MyBenchesBloc extends Bloc<MyBenchesEvent, MyBenchesState> {
  MyBenchesBloc() : super(MyBenchesInitial());

  @override
  Stream<MyBenchesState> mapEventToState(
    MyBenchesEvent event,
  ) async* {
    if (event is GetMyBenchesEvent) {
      try {
        yield MyBenchesPageLoading();
        final response = await dio.get("/mybenches/");
        var data = response.data['mybenches'];
        List<UiMyBench> uiBench =
            List<UiMyBench>.from(data.map((i) => UiMyBench.fromJson(i)));

        yield MyBenchesPageInitialed(benchCard: uiBench);
      } on DioError catch (e) {
        if (e.response == null) {
          yield MyBenchesPageError();
        } else if (e.response.statusCode == 403) {
          yield MyBenchesPage403Error();
        } else {}
      }
    }
  }
}
