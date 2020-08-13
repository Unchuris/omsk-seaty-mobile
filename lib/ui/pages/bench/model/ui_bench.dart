enum FilterType { trashcan, covered, back, busstop, destroyed, luxury }

class UiBench {
  String imageLink;
  String locationName;
  String address;
  double rate;
  bool isFavorites;
  List<FilterType> filters;
  UiBench(
      {this.imageLink,
      this.locationName,
      this.address,
      this.rate,
      this.isFavorites,
      this.filters});
}
