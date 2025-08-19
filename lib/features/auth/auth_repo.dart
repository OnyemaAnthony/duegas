import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duegas/features/auth/model/customer_model.dart';
import 'package:duegas/features/auth/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.firebaseAuth, required this.firestore});

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    DocumentSnapshot<Map<String, dynamic>> user =
        await firestore.collection('Users').doc(userCredential.user?.uid).get();
    return UserModel.fromJson(user.data()!, user.id);
  }

  Future<UserModel> createUserWithEmailAndPassword(
      {required UserModel userObject}) async {
    UserCredential user = await firebaseAuth.createUserWithEmailAndPassword(
        email: userObject.email!, password: userObject.password!);
    await firestore
        .collection('Users')
        .doc(user.user?.uid)
        .set(userObject.toJson());
    return await getUserById();
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Stream<List<CustomerModel>> getCustomers() {
    return firestore.collection('Customers').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => CustomerModel.fromJson(doc.data(), id: doc.id))
          .toList();
    });
  }

  Future<UserModel> getUserById() async {
    if (firebaseAuth.currentUser == null) {
      return UserModel();
    }
    String id = firebaseAuth.currentUser!.uid;
    final user = await firestore.collection('Users').doc(id).get();
    return UserModel.fromJson(user.data()!, user.id);
  }

  Future<void> saveCustomer(CustomerModel customer) async {
    await firestore.collection('Customers').add(customer.toJson());
  }
}
