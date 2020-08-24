class UiTopUser {
  String uid;
  String displayName;
  String rank;
  String photoUrl;
  int benches;

  UiTopUser(
      {this.uid, this.displayName, this.benches, this.rank, this.photoUrl});

  UiTopUser.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    displayName = json['displayName'];
    benches = json['benches'];
    rank = "Магистр лавочек";
    photoUrl = json['photoUrl'];
  }
}
