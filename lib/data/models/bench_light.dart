import 'package:omsk_seaty_mobile/data/models/bench_type.dart';

class BenchLight {
  String id;
  String name;
  String address;
  double latitude;
  double longitude;
  String imageUrl;
  bool like;
  int score;
  Set<BenchType> feature;

  BenchLight({
    this.id,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.imageUrl,
    this.like,
    this.score,
    this.feature});

  BenchLight.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    latitude = json['lat'];
    longitude = json['lon'];
    imageUrl = json['imageUrl'];
    like = json['like'];
    score = json['score'];
    feature = json['feature']; //TODO
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['lat'] = this.latitude;
    data['lon'] = this.longitude;
    data['imageUrl'] = this.imageUrl;
    data['like'] = this.like;
    data['score'] = this.score;
    data['feature'] = this.feature; //TODO
    return data;
  }
}
