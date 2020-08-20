import 'package:omsk_seaty_mobile/data/models/bench_type.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/model/ui_comment.dart';

class UiBench {
  String imageLink;
  String locationName;
  String address;
  double rate;
  bool isFavorites;
  Set<BenchType> filters;
  List<UiComment> comments;
  UiBench(
      {this.imageLink,
      this.locationName,
      this.address,
      this.rate,
      this.isFavorites,
      this.filters,
      this.comments});
}
