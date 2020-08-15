import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'right_draver_event.dart';
part 'right_draver_state.dart';

class RightDraverBloc extends Bloc<RightDraverEvent, RightDraverState> {
  RightDraverBloc() : super(RightDraverInitial());

  Map<String, bool> _checkBox = {
    "Высокий комфорт": false,
    "Урна рядом": false,
    "Стол рядом": false,
    "Крытая лавочка": false,
    "Для большой компании": false,
    "Живописный вид": false,
    "Остановка": false
  };

  @override
  Stream<RightDraverState> mapEventToState(
    RightDraverEvent event,
  ) async* {
    if (event is OnFilterTapEvent) {
      _checkBox.update(event.title, (value) => event.isTaped);
      yield OnFilterTapState(checkBox: _checkBox);
    }
  }
}
