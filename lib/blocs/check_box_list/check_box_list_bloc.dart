import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'check_box_list_event.dart';
part 'check_box_list_state.dart';

class CheckBoxListBloc extends Bloc<CheckBoxListEvent, CheckBoxListState> {
  CheckBoxListBloc() : super(CheckBoxListInitial());

  @override
  Stream<CheckBoxListState> mapEventToState(
    CheckBoxListEvent event,
  ) async* {
    if (event is CheckBoxListChanged)
      yield* _mapCheckBoxListChangedToState(event.map);
    else if (event is CheckBoxListDialogOpened)
      yield* _mapCheckBoxListDialogOpenedToState();
  }

  Stream<CheckBoxListState> _mapCheckBoxListDialogOpenedToState() async* {
    yield CheckBoxListOpen();
  }

  Stream<CheckBoxListState> _mapCheckBoxListChangedToState(
      Map<Object, bool> map) async* {
    yield CheckBoxListDone(map);
  }
}
