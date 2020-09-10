class UserInfo {
  String uid;
  String displayName;
  String email;
  String photoUrl;
  int score;
  bool premium;
  int benches;
  int comments;
  String title;

  UserInfo(this.uid, this.displayName, this.email, this.photoUrl, this.score, this.premium, this.benches, this.comments, this.title);

  UserInfo.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        displayName = json['displayName'],
        email = json['email'],
        photoUrl = json['photoUrl'],
        score = json['score'],
        premium = json['premium'],
        benches = json['benches_count'],
        comments = json['comments_count'],
        title = json['title'];

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'displayName': displayName,
    'email': email,
    'score': score,
    'premium': premium,
    'benches_count': benches,
    'comments_count': comments,
    'title': title,
  };
}
