import 'package:omsk_seaty_mobile/ui/pages/bench/model/ui_comment.dart';

enum FilterType {
  trashcan,
  covered,
  beautifulView,
  busstop,
  bigGroup,
  luxury,
  withTable
}

class UiBench {
  String imageLink;
  String locationName;
  String address;
  double rate;
  bool isFavorites;
  List<FilterType> filters;
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
