import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:omsk_seaty_mobile/models/benches.dart';

/* Преобразую json в объекты лабочек затем в словарь с маркерами */
class MarkerRepository {
  Future<List<Benches>> getMarkers() async {
    var data =
        await rootBundle.loadString("assets/127_0_0_1.json").then((data) {
      var file = jsonDecode(data);
      List<Benches> benches =
          List<Benches>.from(file["Benches"].map((i) => Benches.fromJson(i)));
      return benches;
    });
    return data;
  }
}
/* markers = Map.fromIterable(benches,
          key: (e) => e.location,
          value: (e) => Marker(
              markerId: MarkerId(e.location),
              position: LatLng(e.latitude, e.longitude),
              infoWindow: InfoWindow(title: e.location)));
      return markers; */
