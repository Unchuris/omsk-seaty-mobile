/*
  Первая версия модели лавочки по полям которые у меня есть в данный момент.
  json с лавочками в assets 
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
