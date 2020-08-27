import 'package:flutter/cupertino.dart';

class GeoPoint {
  final double latitude;
  final double longitude;

  GeoPoint({@required double latitude, @required double longitude})
      : latitude = latitude,
        longitude = longitude;

  @override
  String toString() {
    return "($latitude, $longitude)";
  }
}
