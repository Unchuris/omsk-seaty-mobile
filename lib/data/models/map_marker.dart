import 'package:fluster/fluster.dart';

class MapMarker extends Clusterable {
  String locationName;
  String thumbnailSrc;
  bool isFavorites;
  String imageUrl;
  bool isSelect;

  set isSelected(bool s) {
    this.isSelect = s;
  }

  MapMarker(
      {this.locationName,
      latitude,
      longitude,
      this.thumbnailSrc,
      this.imageUrl,
      this.isFavorites,
      isCluster = false,
      clusterId,
      pointsSize,
      markerId,
      childMarkerId,
      this.isSelect = false})
      : super(
            latitude: latitude,
            longitude: longitude,
            isCluster: isCluster,
            clusterId: clusterId,
            pointsSize: pointsSize,
            markerId: markerId,
            childMarkerId: childMarkerId);
}
