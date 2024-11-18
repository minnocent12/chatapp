import 'package:firebase_auth/firebase_auth.dart';
import 'database_service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<bool> register(
      String email, String password, Map<String, dynamic> userDetails) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await DatabaseService.saveUserDetails(
          userCredential.user!.uid, userDetails);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }
}
