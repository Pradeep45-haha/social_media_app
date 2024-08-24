import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_mmvm_dp_clone/config/data.dart';
import 'package:instagram_mmvm_dp_clone/config/error_const.dart';

class AuthMethodsLogin {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Data isLoggedIn() {
    return SuccessData(
        successData: CSuccess(data: {"loggedIn": _auth.currentUser != null}));
  }

  Future<Data> loginUser(
      {required String email, required String password}) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return const FailureData(
            failureData: CError(
                errorType: ErrorType.emptyCredentialsError,
                errorObj: {"msg": "Please provide email and password"}));
      }
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint(userCredential.user!.email);
      return SuccessData(
          successData: CSuccess(
        data: userCredential,
      ));
    } on FirebaseAuthException catch (err) {
      debugPrint("firebaseAuth error ${err.toString()}");
      return FailureData(
          failureData: CError(errorType: ErrorType.authError, errorObj: err));
    } catch (err) {
      debugPrint("generic error ${err.toString()}");
      return FailureData(
          failureData:
              CError(errorType: ErrorType.genericError, errorObj: err));
    }
  }
}
