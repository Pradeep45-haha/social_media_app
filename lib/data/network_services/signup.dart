import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:instagram_mmvm_dp_clone/config/data.dart';
import 'package:instagram_mmvm_dp_clone/config/error_const.dart';
import 'package:instagram_mmvm_dp_clone/data/network_services/storage..dart';
import 'package:instagram_mmvm_dp_clone/model/user.dart';

class AuthMethodsSignup {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign up user
  Future<Data> signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? file,
  }) async {
    try {
      if (email.isEmpty ||
          password.isEmpty ||
          username.isEmpty ||
          bio.isEmpty ||
          file == null) {
        return const FailureData(
            failureData: CError(
                errorType: ErrorType.emptyCredentialsError,
                errorObj: {"error": "PLease provide mandatory fields"}));
      }

      //register the user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      

      String picUrl = await StorageMethods()
          .uploadImageToStorage("profilePic", file, false);

      AppUser user = AppUser(
        email: email,
        uid: userCredential.user!.uid,
        photoUrl: picUrl,
        userName: username,
        bio: bio,
      );
      //add user data to our database
      await _firestore
          .collection("users")
          .doc(
            userCredential.user!.uid,
          )
          .set(
            user.toJson(),
          );

      return SuccessData(successData: CSuccess(data: userCredential));
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email" || err.code == "weak-password") {
        return FailureData(
            failureData: CError(errorType: ErrorType.authError, errorObj: err));
      }
      return FailureData(
          failureData:
              CError(errorType: ErrorType.genericError, errorObj: err));
    } catch (err) {
      return FailureData(
          failureData:
              CError(errorType: ErrorType.genericError, errorObj: err));
    }
  }
}
