class UIBencCard {
  String id;
  String name;
  String imageUrl;
  double rate;
  double lat;
  double lon;
  bool like;
  UIBencCard(this.id, this.name, this.rate, this.imageUrl, this.like, this.lat, this.lon);
  UIBencCard.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lat = json['lat'];
    lon = json['lon'];
    (json['imageUrl'] == "")
        ? imageUrl =
            'https://m.bk55.ru/fileadmin/bkinform/image/2017/12/29/1514539988/9c572fa5eeb303b8e665d6f7e1430e2f.jpg'
        : imageUrl = json['imageUrl'];

    like = json['like'];
    rate = json['rating'];
    id = json['id'].toString();
  }
}
