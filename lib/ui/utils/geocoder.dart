import 'package:geocoder/geocoder.dart';
import 'package:omsk_seaty_mobile/data/models/geopoint.dart';

Future<String> getAddressString(GeoPoint geoPoint) async {
  final addresses = await Geocoder.local.findAddressesFromCoordinates(Coordinates(geoPoint.latitude, geoPoint.longitude));
  final mainAddress = addresses.first.addressLine.split(", ").take(3).join(" ");
  return mainAddress;
}