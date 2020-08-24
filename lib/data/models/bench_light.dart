import 'package:omsk_seaty_mobile/data/models/bench_type.dart';

class BenchLight {
  String id;
  String name;
  String address;
  double latitude;
  double longitude;
  String imageUrl;
  bool like;
  double score;
  Set<BenchType> feature;

  BenchLight(
      {this.id,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.imageUrl,
      this.like,
      this.score,
      this.feature});

  BenchLight.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    address = json['address'];
    latitude = json['lat'];
    longitude = json['lon'];
    imageUrl =
        'https://m.bk55.ru/fileadmin/bkinform/image/2017/12/29/1514539988/9c572fa5eeb303b8e665d6f7e1430e2f.jpg';
    like = json['like'];
    score = json['rating'];
    if (json['features'] != null) {
      feature = new Set<BenchType>();
      json['features'].forEach((v) {
        switch (v['feature']) {
          case "Высокий комфорт":
            feature.add(BenchType.HIGH_COMFORT);
            break;
          case "Урна рядом":
            feature.add(BenchType.URN_NEARBY);
            break;
          case "Стол Рядом":
            feature.add(BenchType.TABLE_NEARBY);
            break;
          case "Крытая лавочка":
            feature.add(BenchType.COVERED_BENCH);
            break;
          case "Для большой компании":
            feature.add(BenchType.FOR_A_LARGE_COMPANY);
            break;
          case "Живописный вид":
            feature.add(BenchType.SCENIC_VIEW);
            break;
          case "Остановка":
            feature.add(BenchType.BUS_STOP);
            break;
          default:
        }
      });
    }
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
