import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProvider {

  final FirebaseAuth firebaseAuth;
  
  //FirebaseAuth instance
  AuthenticationProvider(this.firebaseAuth);
  //Constuctor to initalize the FirebaseAuth instance
  
  //Using Stream to listen to Authentication State
  Stream<User?> get authState => firebaseAuth.idTokenChanges();

  //SIGN UP METHOD
  Future<String?> signUp({required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up!";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  
  //SIGN IN METHOD
  Future<String?> signIn({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in!";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  
  //SIGN OUT METHOD
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }


  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // get user => _auth.currentUser;

  // //SIGN UP METHOD
  // Future signUp({required String email, required String password}) async {
  //   try {
  //     await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   }
  // }

  // //SIGN IN METHOD
  // Future signIn({required String email, required String password}) async {
  //   try {
  //     await _auth.signInWithEmailAndPassword(email: email, password: password);
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   }
  // }

  // //SIGN OUT METHOD
  // Future signOut() async {
  //   await _auth.signOut();

  //   print('signout');
  // }

 }