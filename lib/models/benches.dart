/*
  Первая версия модели лавочки по полям которые у меня есть в данный момент.
  json с лавочками в assets 
 */

import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/* class MapMarker extends Clusterable {
  String locationName;
  String thumbnailSrc;

  MapMarker(
      {this.locationName,
      latitude,
      longitude,
      this.thumbnailSrc,
      isCluster = false,
      clusterId,
      pointsSize,
      markerId,
      childMarkerId})
      : super(
            latitude: latitude,
            longitude: longitude,
            isCluster: isCluster,
            clusterId: clusterId,
            pointsSize: pointsSize,
            markerId: markerId,
            childMarkerId: childMarkerId);
}
 */
class Benches {
  String location;
  double latitude;
  double longitude;
  bool isPending;
  bool isCovered;

  Benches(
      {this.location,
      this.latitude,
      this.longitude,
      this.isPending,
      this.isCovered});

  factory Benches.fromJson(Map<String, dynamic> json) => Benches(
      location: json["location"],
      latitude: json["lattitude"],
      longitude: json["longtitude"],
      isPending: json["is_pending"],
      isCovered: json["is_covered"]);
}
