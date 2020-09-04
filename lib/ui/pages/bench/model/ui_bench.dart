import 'package:omsk_seaty_mobile/data/models/bench_type.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/model/ui_comment.dart';

class UiBench {
  String imageUrl;
  String name;
  String address;
  double rate;
  double lat;
  double lon;
  bool like;
  List<BenchType> features;
  List<UiComment> comments;

  UiBench(
      {this.imageUrl,
      this.name,
      this.address,
      this.rate,
      this.like,
      this.features,
      this.comments});
  UiBench.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    (json['imageUrl'] == "")
        ? imageUrl =
            'https://m.bk55.ru/fileadmin/bkinform/image/2017/12/29/1514539988/9c572fa5eeb303b8e665d6f7e1430e2f.jpg'
        : imageUrl = json['imageUrl'];
    like = json['like'];
    lat = json['lat'];
    lon = json['lon'];
    rate = json['rating'];
    if (json['features'] != null) {
      features = new List<BenchType>();
      json['features'].forEach((v) {
        switch (v['feature']) {
          case "Высокий комфорт":
            features.add(BenchType.HIGH_COMFORT);
            break;
          case "Урна рядом":
            features.add(BenchType.URN_NEARBY);
            break;
          case "Стол Рядом":
            features.add(BenchType.TABLE_NEARBY);
            break;
          case "Крытая лавочка":
            features.add(BenchType.COVERED_BENCH);
            break;
          case "Для большой компании":
            features.add(BenchType.FOR_A_LARGE_COMPANY);
            break;
          case "Живописный вид":
            features.add(BenchType.SCENIC_VIEW);
            break;
          case "Остановка":
            features.add(BenchType.BUS_STOP);
            break;
          default:
        }
      });
    }
    if (json['comments'] != null) {
      comments = new List<UiComment>();
      json['comments'].forEach((comment) {
        comments.add(UiComment.fromJson(comment));
      });
    }
  }
}
