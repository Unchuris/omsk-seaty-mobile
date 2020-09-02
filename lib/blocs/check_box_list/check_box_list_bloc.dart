import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:omsk_seaty_mobile/data/models/bench_type.dart';

part 'check_box_list_event.dart';
part 'check_box_list_state.dart';

class CheckBoxListBloc extends Bloc<CheckBoxListEvent, CheckBoxListState> {
  CheckBoxListBloc() : super(CheckBoxListInitial());
  Map<BenchType, bool> benches = {
    BenchType.TABLE_NEARBY: false,
    BenchType.COVERED_BENCH: false,
    BenchType.SCENIC_VIEW: false,
    BenchType.FOR_A_LARGE_COMPANY: false,
    BenchType.URN_NEARBY: false
  };
  @override
  Stream<CheckBoxListState> mapEventToState(
    CheckBoxListEvent event,
  ) async* {
    if (event is CheckBoxListChanged) {
      benches = event.map;
      yield CheckBoxListDone(benches);
    } else if (event is CheckBoxListDialogOpened) {
      yield CheckBoxListOpen(benches);
    } else if (event is CheckBoxItemDelete) {
      benches[event.item] = false;
      yield CheckBoxItemChange(item: event.item, map: benches);
    } else if (event is CheckBoxClouse) {
      yield CheckBoxPageClosed();
    } else if (event is CheckBoxListOpened) {
      yield CheckBoxListInitOpen(benches);
    }
  }
}
