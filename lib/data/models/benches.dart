class Bench {
  List<Benches> benches;

  Bench({this.benches});

  Bench.fromJson(Map<String, dynamic> json) {
    if (json['benches'] != null) {
      benches = new List<Benches>();
      json['benches'].forEach((v) {
        benches.add(new Benches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.benches != null) {
      data['benches'] = this.benches.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Benches {
  int pk;
  int authorId;
  bool isPending;
  double latitude;
  double longitude;
  String title;
  String description;
  String place;
  bool isDestroyed;
  bool isCovered;
  int numberOfSeats;
  bool isBusstop;
  bool isWarm;
  bool isLuxury;
  bool hasBack;
  bool hasTrashcan;

  Benches(
      {this.pk,
      this.authorId,
      this.isPending,
      this.latitude,
      this.longitude,
      this.title,
      this.description,
      this.place,
      this.isDestroyed,
      this.isCovered,
      this.numberOfSeats,
      this.isBusstop,
      this.isWarm,
      this.isLuxury,
      this.hasBack,
      this.hasTrashcan});

  Benches.fromJson(Map<String, dynamic> json) {
    pk = json['pk'];
    authorId = json['author_id'];
    isPending = json['is_pending'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    title = json['title'];
    description = json['description'];
    place = json['place'];
    isDestroyed = json['is_destroyed'];
    isCovered = json['is_covered'];
    numberOfSeats = json['number_of_seats'];
    isBusstop = json['is_busstop'];
    isWarm = json['is_warm'];
    isLuxury = json['is_luxury'];
    hasBack = json['has_back'];
    hasTrashcan = json['has_trashcan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pk'] = this.pk;
    data['author_id'] = this.authorId;
    data['is_pending'] = this.isPending;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['title'] = this.title;
    data['description'] = this.description;
    data['place'] = this.place;
    data['is_destroyed'] = this.isDestroyed;
    data['is_covered'] = this.isCovered;
    data['number_of_seats'] = this.numberOfSeats;
    data['is_busstop'] = this.isBusstop;
    data['is_warm'] = this.isWarm;
    data['is_luxury'] = this.isLuxury;
    data['has_back'] = this.hasBack;
    data['has_trashcan'] = this.hasTrashcan;
    return data;
  }
}
