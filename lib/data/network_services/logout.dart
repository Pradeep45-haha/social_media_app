import 'package:firebase_auth/firebase_auth.dart';


class AuthMethodLogout {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> logout() async {
    await _auth.signOut();

    if (_auth.currentUser == null) {
      return true;
    }
    return false;
  }
}
