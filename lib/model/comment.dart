import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String description;
  final String uid;
  final String userName;
  final DateTime datePublished;
  final String profileImageUrl;
  final List<String> noOfLikes;

  Comment({
    required this.description,
    required this.uid,
    required this.userName,
    required this.datePublished,
    required this.profileImageUrl,
    required this.noOfLikes,
  });

  static Comment fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Comment(
      description: snap["description"],
      uid: snap["uid"],
      userName: snap["userName"],
      datePublished: snap["datePublished"],
      profileImageUrl: snap["profileImageUrl"],
      noOfLikes: snap["noOfLikes"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "uid": uid,
      "userName": userName,
      "datePublished": datePublished,
      "profileImageUrl": profileImageUrl,
      "noOfLikes": noOfLikes,
    };
  }
}
