import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/semantics.dart';

part 'add_comment_step_event.dart';
part 'add_comment_step_state.dart';

class AddCommentStepBloc
    extends Bloc<AddCommentStepEvent, AddCommentStepState> {
  AddCommentStepBloc() : super(AddCommentStepInitial());

  @override
  Stream<AddCommentStepState> mapEventToState(
    AddCommentStepEvent event,
  ) async* {
    if (event is CloseTextFieldEvent) {
      yield CloseTextFiledState(text: event.text, rating: event.rating);
    }
  }
}
