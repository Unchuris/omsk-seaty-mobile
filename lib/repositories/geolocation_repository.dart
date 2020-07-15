import 'package:geolocator/geolocator.dart';

/* Получаю поток с текущим местоположением*/
class GeolocationRepository {
  Geolocator geolocator = Geolocator();

  Stream<Position> getCurrentPositionStream() {
    return geolocator.getPositionStream();
  }
}
