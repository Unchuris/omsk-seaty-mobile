class UIBencCard {
  String id;
  String name;
  String imageUrl;
  double rate;
  double lat;
  double lon;
  bool like;
  UIBencCard(this.name, this.rate, this.imageUrl, this.like);
  UIBencCard.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lat = json['lat'];
    lon = json['lon'];
    imageUrl =
        'https://m.bk55.ru/fileadmin/bkinform/image/2017/12/29/1514539988/9c572fa5eeb303b8e665d6f7e1430e2f.jpg';
    like = true;
    rate = 4.0;
    id = json['id'].toString();
  }
}
