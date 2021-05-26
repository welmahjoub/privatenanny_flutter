import 'package:firebase_auth/firebase_auth.dart';
import 'user.dart';

class Service {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<UserModal> get user {
    return auth.authStateChanges().asyncMap(
          (user) => UserModal(user.uid, user.email, ""),
        );
  }

  Future<UserModal> create(email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print("create ok ");
      UserModal user = UserModal(userCredential.user.uid, email, password);

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserModal> connecter(email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      UserModal user = UserModal(userCredential.user.uid, email, password);

      return user;
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}