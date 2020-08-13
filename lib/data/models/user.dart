class User {
  String uid;
  String displayName;
  String email;
  String photoUrl;

  User(this.uid, this.displayName, this.email, this.photoUrl);

  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        displayName = json['displayName'],
        email = json['email'],
        photoUrl = json['photoUrl'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl
      };
}
