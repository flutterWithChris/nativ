import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nativ/data/model/user.dart';
import 'package:nativ/data/repositories/database_repository.dart';

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthRepository({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  var currentUser = User.empty;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      currentUser = user;
      return user;
    });
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      Map<String, dynamic> userInfoMap = {
        "email": email,
      };
      await DatabaseRepository()
          .storeUserInfoDB(_firebaseAuth.currentUser!.uid, userInfoMap);
    } catch (_) {}
  }

  Future<void> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (_) {
      throw Exception('Failed Login!');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await firebase_auth.FirebaseAuth.instance
          .signInWithCredential(credential);
    } catch (_) {
      throw Exception(firebase_auth.FirebaseAuthException);
    }
  }

  Future<void> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await firebase_auth.FirebaseAuth.instance
          .signInWithCredential(credential);
      Map<String, dynamic> userInfoMap = {
        "email": _firebaseAuth.currentUser!.email,
      };
      await DatabaseRepository()
          .storeUserInfoDB(_firebaseAuth.currentUser!.uid, userInfoMap);
    } catch (_) {
      throw Exception(firebase_auth.FirebaseAuthException);
    }
  }

  Future<void> logout() async {
    try {
      await Future.wait([_firebaseAuth.signOut()]);
    } catch (_) {}
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
