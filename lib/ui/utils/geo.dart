import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/data/models/geopoint.dart';

const omskCenterPoint = GeoPoint(latitude: 54.991351, longitude: 73.364528);

Future<String> getAddressString(GeoPoint geoPoint) async {
  try {
    final addresses = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(geoPoint.latitude, geoPoint.longitude));
    final mainAddress = addresses.first.addressLine.split(", ").take(3).join(
        " ");
    return mainAddress;
  } catch(ex) {
    return "${geoPoint.latitude}, ${geoPoint.longitude}";
  }
}

extension GeoPointMapper on GeoPoint {
  LatLng toLatLng() => LatLng(latitude, longitude);
}