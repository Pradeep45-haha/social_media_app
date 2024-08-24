import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_mmvm_dp_clone/config/data.dart';
import 'package:instagram_mmvm_dp_clone/config/error_const.dart';
import 'package:instagram_mmvm_dp_clone/model/post.dart';
import 'package:instagram_mmvm_dp_clone/model/user.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseStorage = FirebaseFirestore.instance;

  //add image to firebase storage i.e. post or profile image
  Future<String> uploadImageToStorage(
    String childName,
    Uint8List file,
    bool isPost,
  ) async {
    try {
      //get ref for storage
      Reference ref =
          _storage.ref().child(childName).child(_auth.currentUser!.uid);
      if (isPost) {
        String id = const Uuid().v1();
        ref = _storage
            .ref()
            .child(childName)
            .child(_auth.currentUser!.uid)
            .child(id);
      }
      //create upload task
      UploadTask uploadTask = ref.putData(file);
      //upload data to storage
      TaskSnapshot snapshot = await uploadTask;
      //get url of the uploaded data
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  //method related to post

  //add post to current user
  Future<Data> addPost(
    String childName,
    Uint8List file,
    String description,
    bool isPost,
  ) async {
    String imageUrl = await uploadImageToStorage(
      childName,
      file,
      isPost,
    );
    try {
      //get current used id
      String currentUserUid = _auth.currentUser!.uid;
      //create post id
      String postId = const Uuid().v1();

      //get current user details
      DocumentSnapshot userDetails =
          await _firebaseStorage.collection("users").doc(currentUserUid).get();

      Post post = Post(
        description: description,
        uid: _auth.currentUser!.uid,
        userName: userDetails.get("username"),
        postUrl: imageUrl,
        postId: postId,
        datePublished: DateTime.now(),
        profileImageUrl: userDetails.data().toString().contains("photoUrl")
            ? userDetails.get("photoUrl")
            : "",
        noOfLikes: [],
      );

      await _firebaseStorage.collection("posts").doc(postId).set(
            post.toJson(),
          );
      return const SuccessData(successData: CSuccess(data: {}));
    } catch (e) {
      return FailureData(
        failureData: CError(errorType: ErrorType.genericError, errorObj: e),
      );
    }
  }

  //delete post from current user
  Future<Data> deletePost(String postId) async {
    try {
      await _firebaseStorage.collection('posts').doc(postId).delete();
      return const SuccessData(successData: CSuccess(data: {}));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

  //add user id to post likedids field
  Future<Data> addLikeUidToPost(String uid, String postId) async {
    FirebaseFirestore firestoreSetData = FirebaseFirestore.instance;

    try {
      await firestoreSetData.collection("posts").doc(postId).update({
        "noOfLikes": FieldValue.arrayUnion([uid])
      });
      return const SuccessData(successData: CSuccess(data: {}));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

  //remove user id from post likedids field
  Future<Data> removeLikeUidFromPost(String uid, String postId) async {
    try {
      await _firebaseStorage.collection("posts").doc(postId).update({
        "noOfLikes": FieldValue.arrayRemove([uid])
      });
      return const SuccessData(successData: CSuccess(data: {}));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

  //add bookmarked post id to current user
  Future<Data> savePost({required String postId}) async {
    try {
      await _firebaseStorage
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("savedPost")
          .doc(postId)
          .set({"postId": postId});
      return const SuccessData(successData: CSuccess(data: {}));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

  //remove bookmarked post id from current user
  Future<Data> removeSavedPost({required String postId}) async {
    try {
      await _firebaseStorage
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("savedPost")
          .doc(postId)
          .delete();
      return const SuccessData(successData: CSuccess(data: {}));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

////////////////////////////////////////////////////////////////////////////////////

  //method related to user
  Future<Data> getCurrentUserDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDetailsDoc =
          await _firebaseStorage
              .collection("users")
              .doc(_auth.currentUser!.uid)
              .get();
      AppUser appUser = AppUser.fromMap(userDetailsDoc.data()!);
      return SuccessData(successData: CSuccess(data: appUser));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

  Future<Data> getUserPostCount({required String userId}) async {
    try {
      AggregateQuerySnapshot postCountQuery = await _firebaseStorage
          .collection("posts")
          .where("uid", isEqualTo: userId)
          .count()
          .get();

      return SuccessData(successData: CSuccess(data: postCountQuery.count!));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

  Future<Data> getUserFollowingCount({required String userId}) async {
    try {
      AggregateQuerySnapshot followingCountQuery = await _firebaseStorage
          .collection("users")
          .doc(userId)
          .collection("following")
          .count()
          .get();

      return SuccessData(
          successData: CSuccess(data: followingCountQuery.count!));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

  Future<Data> getUserFollowerCount({required String userId}) async {
    try {
      AggregateQuerySnapshot followerCountQuery = await _firebaseStorage
          .collection("posts")
          .doc(userId)
          .collection("follower")
          .count()
          .get();

      return SuccessData(
          successData: CSuccess(data: followerCountQuery.count!));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

  Future<Data> getPostCountForCurrentUser() async {
    try {
      final postCount = await _firebaseStorage
          .collection("posts")
          .where("uid", isEqualTo: _auth.currentUser!.uid)
          .count()
          .get();

      return SuccessData(successData: CSuccess(data: postCount.count!));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

  //add liked post id to current user doc
  Future<Data> saveLikedPost({required String postId}) async {
    try {
      await _firebaseStorage
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("likedPost")
          .doc(postId)
          .set({"postId": postId});
      return const SuccessData(successData: CSuccess(data: {}));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

//remove liked post id from current user doc
  Future<Data> removeLikedPost({required String postId}) async {
    try {
      await _firebaseStorage
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("likedPost")
          .doc(postId)
          .delete();
      return const SuccessData(successData: CSuccess(data: {}));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

  Future<Data> getOtherUserProfileDetails({required String userId}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDetailsDoc =
          await _firebaseStorage.collection("users").doc(userId).get();
      AppUser appUser = AppUser.fromMap(userDetailsDoc.data()!);
      return SuccessData(successData: CSuccess(data: appUser));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

  Future<Data> addUserToFollowingList({required String userId}) async {
    try {
      await _firebaseStorage
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("following")
          .doc(userId)
          .set({"userId": userId});
      return const SuccessData(successData: CSuccess(data: {}));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

  removeUserFromFollowingList({required String userId}) async {
    try {
      debugPrint("removeUserFromFollowingList called");
      QuerySnapshot<Map<String, dynamic>> docId = await _firebaseStorage
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("following")
          .where("userId", isEqualTo: userId)
          .get();
      if (docId.docs.first.exists) {
        await _firebaseStorage
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .collection("following")
            .doc(docId.docs.first.id)
            .delete();
      }

      return const SuccessData(successData: CSuccess(data: {}));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

  // Future<Data> getListOfFollowingUser({required String userId}) async {
  //   try {
  //     await _firebaseStorage
  //         .collection("users")
  //         .doc(userId)
  //         .collection("following")
  //         .get();
  //     return SuccessData(successData: CSuccess(data: {}));
  //   } catch (e) {
  //     return FailureData(
  //         failureData: CError(errorType: ErrorType.genericError, errorObj: e));
  //   }
  // }

  Future<Data> getFollowingCount({required String userId}) async {
    try {
      AggregateQuerySnapshot followingCountQuery = await _firebaseStorage
          .collection("users")
          .doc(userId)
          .collection("following")
          .count()
          .get();

      return SuccessData(
          successData: CSuccess(data: followingCountQuery.count!));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

  Future<Data> getFollowingCountForCurrentUser() async {
    try {
      final followingCountQuery = await _firebaseStorage
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("following")
          .count()
          .get();
      return SuccessData(
          successData: CSuccess(data: followingCountQuery.count!));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

  Future<Data> isPostLikedByCurrentUser({required postId}) async {
    try {
      final isPostLikedByCurrentUserDoc =
          await _firebaseStorage.collection("posts").doc(postId).get();
      return SuccessData(
          successData: CSuccess(
              data: (isPostLikedByCurrentUserDoc.data()!["noOfLikes"]
                      as List<dynamic>)
                  .map((e) => e.toString())
                  .toList()
                  .contains(_auth.currentUser!.uid)));
    } catch (e) {
      return FailureData(
          failureData: CError(errorType: ErrorType.genericError, errorObj: e));
    }
  }

  Future<Data> isPostSavedByCurrentUser({required postId}) async {
    try {
      final isPostSavedByCurrentUserDoc = await _firebaseStorage
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("likedPost")
          .doc(postId)
          .get();

      return SuccessData(
        successData: CSuccess(
          data: (isPostSavedByCurrentUserDoc.data()!.isNotEmpty),
        ),
      );
    } catch (e) {
      return FailureData(
        failureData: CError(errorType: ErrorType.genericError, errorObj: e),
      );
    }
  }

  Future<Data> isCurrentUserFollowingThisUser({required userId}) async {
    try {
      final isCurrentUserFollowingThisUser = await _firebaseStorage
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("following")
          .where("userId", isEqualTo: userId)
          .get();

      debugPrint(
          "isCurrentUserFollowingThisUser data:${isCurrentUserFollowingThisUser.docs.length.toString()}");
      return SuccessData(
        successData: CSuccess(
          data: (isCurrentUserFollowingThisUser.docs.isNotEmpty),
        ),
      );
    } catch (e) {
      debugPrint("from isCurrentUserFollowingThisUser error: ${e.toString()} ");
      return FailureData(
        failureData: CError(errorType: ErrorType.genericError, errorObj: e),
      );
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////////////

  //method related to comment
  Future<Data> addCommentToPost(
    String postId,
    String comment,
    String uid,
    String profileImageUrl,
    String userName,
  ) async {
    try {
      String commentId = const Uuid().v1();
      await _firebaseStorage
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .set({
        "profileImageUrl": profileImageUrl,
        "userName": userName,
        "uid": uid,
        "comment": comment,
        "commentId": commentId,
        "datePublished": DateTime.now(),
      });

      return const SuccessData(successData: CSuccess(data: {}));
    } catch (e) {
      return FailureData(
        failureData: CError(errorType: ErrorType.genericError, errorObj: e),
      );
    }
  }

  removeCommentFromPost(
    String postId,
    String commentId,
    String uid,
    String profileImageUrl,
    String userName,
  ) async {
    try {
      String commentId = const Uuid().v1();
      await _firebaseStorage
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .delete();
      return const SuccessData(successData: CSuccess(data: {}));
    } catch (e) {
      return FailureData(
        failureData: CError(errorType: ErrorType.genericError, errorObj: e),
      );
    }
  }

  Future<Data> getCommentCountForPost({required String postId}) async {
    try {
      AggregateQuerySnapshot commentCountQuery = await _firebaseStorage
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .count()
          .get();

      return SuccessData(successData: CSuccess(data: commentCountQuery.count!));
    } catch (e) {
      return FailureData(
        failureData: CError(errorType: ErrorType.genericError, errorObj: e),
      );
    }
  }
}
