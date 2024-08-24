import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String userName;
  final String postUrl;
  final String postId;
  final DateTime datePublished;
  final String profileImageUrl;
  final List<String> noOfLikes;

  Post({
    required this.description,
    required this.uid,
    required this.userName,
    required this.postUrl,
    required this.postId,
    required this.datePublished,
    required this.profileImageUrl,
    required this.noOfLikes,
  });

  static Post fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Post(
      description: snap["description"],
      uid: snap["uid"],
      userName: snap["userName"],
      postUrl: snap["postUrl"],
      postId: snap["postId"],
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
      "postUrl": postUrl,
      "postId": postId,
      "datePublished": datePublished,
      "profileImageUrl": profileImageUrl,
      "noOfLikes": noOfLikes,
    };
  }

 
}
