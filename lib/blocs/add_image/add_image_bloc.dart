import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'add_image_event.dart';
part 'add_image_state.dart';

class AddImageBloc extends Bloc<AddImageEvent, AddImageState> {
  AddImageBloc() : super(AddImageInitial());

  @override
  Stream<AddImageState> mapEventToState(
    AddImageEvent event,
  ) async* {
    if (event is AddImageStarted) {
      yield* _mapAddImageStartedToState(event.image);
    } else if (event is AddImageCanceled) {
      yield* _mapAddImageCanceledToState();
    }
  }
}

Stream<AddImageState> _mapAddImageStartedToState(Widget image) async* {
  if (image != null) {
    yield AddImageSuccess(image);
  } else
    yield AddImageFailture();
}

Stream<AddImageState> _mapAddImageCanceledToState() async* {
  yield AddImageFailture();
}
