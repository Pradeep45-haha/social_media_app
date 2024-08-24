import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String email;
  final String uid;
  final String photoUrl;
  final String userName;
  final String bio;

  const AppUser({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.userName,
    required this.bio,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": userName,
      "uid": uid,
      "email": email,
      "photoUrl": photoUrl,
      "bio": bio,
    };
  }

  static AppUser fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return AppUser(
      email: snap["email"],
      uid: snap["uid"],
      photoUrl: snap["photoUrl"],
      userName: snap["username"],
      bio: snap["bio"],
    );
  }

  static AppUser fromMap(Map<String, dynamic> snapshot) {
    var snap = snapshot;
    return AppUser(
      email: snap["email"],
      uid: snap["uid"],
      photoUrl: snap["photoUrl"],
      userName: snap["username"],
      bio: snap["bio"],
    );
  }

  @override
  String toString() {
    return "email: $email \n uid: $uid \n userName: $userName \n photoUrl: $photoUrl \n bio: $bio \n";
  }

  @override
  List<Object?> get props => [userName, uid, bio, email, photoUrl];
}
