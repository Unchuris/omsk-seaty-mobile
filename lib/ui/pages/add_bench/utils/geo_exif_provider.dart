import 'package:exif/exif.dart';
import 'package:omsk_seaty_mobile/data/models/geopoint.dart';

class GeoPointExifProvider {
  static GeoPoint exifGPSToGeoPoint(Map<String, IfdTag> tags) {
    const GPS_TAG_LATITUDE = "GPS GPSLatitude";
    const GPS_TAG_LONGITUDE = "GPS GPSLongitude";
    if (!tags.containsKey(GPS_TAG_LATITUDE) ||
        !tags.containsKey(GPS_TAG_LONGITUDE)) {
      return null;
    }
    final latitudeValue = tags[GPS_TAG_LATITUDE]
        .values
        .map<double>(
            (item) => (item.numerator.toDouble() / item.denominator.toDouble()))
        .toList();
    final latitudeSignal = tags[GPS_TAG_LATITUDE + "Ref"].printable;

    final longitudeValue = tags[GPS_TAG_LONGITUDE]
        .values
        .map<double>(
            (item) => (item.numerator.toDouble() / item.denominator.toDouble()))
        .toList();
    final longitudeSignal = tags[GPS_TAG_LONGITUDE + "Ref"].printable;

    double latitude =
        latitudeValue[0] + (latitudeValue[1] / 60) + (latitudeValue[2] / 3600);

    double longitude = longitudeValue[0] +
        (longitudeValue[1] / 60) +
        (longitudeValue[2] / 3600);

    if (latitudeSignal == 'S') latitude = -latitude;
    if (longitudeSignal == 'W') longitude = -longitude;

    return GeoPoint(latitude: latitude, longitude: longitude);
  }
}