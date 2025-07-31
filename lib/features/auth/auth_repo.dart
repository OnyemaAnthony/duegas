import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duegas/features/auth/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.firebaseAuth, required this.firestore});

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        throw 'Invalid email or password.';
      }
      throw 'An error occurred. Please try again.';
    }
  }

  Future<void> createUserWithEmailAndPassword(
      {required UserModel userObject}) async {
    try {
      UserCredential user = await firebaseAuth.createUserWithEmailAndPassword(
          email: userObject.email!, password: userObject.password!);
      await firestore
          .collection('Users')
          .doc(user.user?.uid)
          .set(userObject.toJson());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'An account already exists for that email.';
      }
      throw 'An error occurred. Please try again.';
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
