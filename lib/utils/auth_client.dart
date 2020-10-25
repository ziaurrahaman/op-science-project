import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:opScienceProject/models/user.dart';

class AuthClient {
  AuthClient._privateConstructor();
  static final AuthClient instance = AuthClient._privateConstructor();

  User currentUser;
  String userId;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> getCurrentUserById() async {
    final userId = await uid();
    final document =
        await Firestore.instance.collection('users').document(userId).get();
    currentUser = User.fromMap(document.data);
    return currentUser;
  }

  Future<String> uid() async {
    final FirebaseUser user = await auth.currentUser();
    userId = user.uid;
    return userId;
  }
}
