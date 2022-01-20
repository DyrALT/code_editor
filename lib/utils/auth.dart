import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      if (_auth.currentUser == null) {
        var user = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        return user.user;
      } else {
        return _auth.currentUser;
      }
    } catch (e) {
      print("****************HATA $e");
    }
  }

  signOut() async {
    return await _auth.signOut();
  }

  Future<User?> createUser(String email, String password) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }
}
