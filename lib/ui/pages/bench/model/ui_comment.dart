class UiComment {
  String id;
  String uid;
  String displayName;
  String rank;
  String photoUrl;
  String text;
  int rating;

  UiComment(
      {this.uid,
      this.id,
      this.displayName,
      this.text,
      this.rank,
      this.photoUrl,
      this.rating});

  UiComment.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    var user = json['author'];
    uid = user['uid'];
    displayName = user['displayName'];
    text = json['text'];
    rank = "Магистр лавочек";
    photoUrl = user['photoUrl'];
    rating = json['rating'];
  }
}
