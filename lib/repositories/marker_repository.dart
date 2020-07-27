import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/models/benches.dart';
import 'package:flutter/services.dart';
import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/models/map_marker.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as images;

/* Преобразую json в объекты лабочек затем в словарь с маркерами */
class MarkerRepository {
  Future<List<Benches>> getMarkers() async {
    var data =
        await rootBundle.loadString("assets/127_0_0_1.json").then((data) {
      var file = jsonDecode(data);
      List<Benches> benches =
          List<Benches>.from(file["Benches"].map((i) => Benches.fromJson(i)));

      /*    markers = Map.fromIterable(benches,
          key: (e) => MarkerId(e.location),
          value: (e) => Marker(
              markerId: MarkerId(e.location),
              position: LatLng(e.latitude, e.longitude),
              infoWindow: InfoWindow(title: e.location)));
      return markers; */
      return benches;
    });
    return data;
  }
}
