import 'package:fluster/fluster.dart';

class MapMarker extends Clusterable {
  String locationName;
  String thumbnailSrc;
  String description;
  MapMarker({
    this.locationName,
    latitude,
    longitude,
    this.thumbnailSrc,
    this.description,
    isCluster = false,
    clusterId,
    pointsSize,
    markerId,
    childMarkerId,
  }) : super(
            latitude: latitude,
            longitude: longitude,
            isCluster: isCluster,
            clusterId: clusterId,
            pointsSize: pointsSize,
            markerId: markerId,
            childMarkerId: childMarkerId);
}
