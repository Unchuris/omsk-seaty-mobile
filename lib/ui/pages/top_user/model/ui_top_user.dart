class UiTopUser {
  String id;
  String uid;
  String displayName;
  String rank;
  String photoUrl;
  int benches;

  UiTopUser(
      {this.id,
      this.uid,
      this.displayName,
      this.benches,
      this.rank,
      this.photoUrl});

  UiTopUser.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    uid = json['uid'];
    displayName = json['displayName'];
    benches = json['benches'];
    rank = "Магистр лавочек";
    photoUrl = json['photoUrl'];
  }
}
