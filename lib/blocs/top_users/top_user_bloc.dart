import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:omsk_seaty_mobile/http.dart';
import 'package:omsk_seaty_mobile/ui/pages/top_user/model/ui_top_user.dart';

part 'top_user_event.dart';
part 'top_user_state.dart';

class TopUserBloc extends Bloc<TopUserEvent, TopUserState> {
  TopUserBloc() : super(TopuserInitial());

  @override
  Stream<TopUserState> mapEventToState(
    TopUserEvent event,
  ) async* {
    if (event is GetTopUserEvent) {
      try {
        yield TopUserPageLoading();
        final response = await dio.get("/users/top/");
        var data = response.data;
        List<UiTopUser> uiTopUser =
            List<UiTopUser>.from(data.map((i) => UiTopUser.fromJson(i)));

        yield TopUserPageInitialed(uiTopUsers: uiTopUser);
      } on DioError catch (e) {
        yield TopUserPageError();
      }
    }
  }
}
