import 'package:firebase_auth/firebase_auth.dart';

final currentUser = FirebaseAuth.instance.currentUser!;

signUserIn(String username, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: username,
      password: password,
    );
  } catch (e) {
    // Handle the error
    if (e is FirebaseAuthException) {
      // Firebase Authentication error
      if (e.code == 'user-not-found') {
        // Handle user not found error
      } else if (e.code == 'wrong-password') {
        // Handle wrong password error
      } else {
        // Handle other Firebase Authentication errors
      }
    } else {
      // Handle non-Firebase Authentication errors
      print('An unexpected error occurred: $e');
    }
  }
}

signUserUp(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

userSignOut() {
  FirebaseAuth.instance.signOut();
}
