import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exif/exif.dart';
import 'package:omsk_seaty_mobile/data/models/geopoint.dart';
import 'package:omsk_seaty_mobile/ui/pages/add_bench/utils/geo_exif_provider.dart';
import 'package:omsk_seaty_mobile/ui/utils/geo.dart';

part 'add_image_event.dart';
part 'add_image_state.dart';

class AddImageBloc extends Bloc<AddImageEvent, AddImageState> {
  AddImageBloc() : super(AddImageInitial());

  String _imagePath;

  @override
  Stream<AddImageState> mapEventToState(
    AddImageEvent event,
  ) async* {
    if (event is AddImageStarted) {
      _imagePath = event.imagePath;
      yield* _mapAddImageStartedToState(event.imagePath);
    } else if (event is AddImageCanceled) {
      yield* _mapAddImageCanceledToState();
    } else if (event is AddImageLocation) {
      yield* _mapImageLocationToState(_imagePath, event.location);
    }
  }
}

Stream<AddImageState> _mapAddImageStartedToState(String imagePath) async* {
  if (imagePath != null) {
    yield AddImageLocationLoading(imagePath);
    final file = File(imagePath);
    final bytes = await readExifFromBytes(file.readAsBytesSync());
    final geoPoint = GeoPointExifProvider.exifGPSToGeoPoint(bytes);
    if (geoPoint == null)
      yield AddImageSuccess(imagePath, null, null);
    else {
      String mainAddress = await getAddressString(geoPoint);
      yield AddImageSuccess(imagePath, mainAddress, geoPoint);
    }
  } else
    yield AddImageFailture();
}

Stream<AddImageState> _mapImageLocationToState(String imagePath, GeoPoint location) async* {
  if (location != null && imagePath != null) {
    yield AddImageLocationLoading(imagePath);
    String mainAddress = await getAddressString(location);
    yield AddImageSuccess(imagePath, mainAddress, location);
  } else
    yield AddImageFailture();
}

Stream<AddImageState> _mapAddImageCanceledToState() async* {
  yield AddImageFailture();
}
