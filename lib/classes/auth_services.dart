import 'package:firebase_auth/firebase_auth.dart';

class AuthServices{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<User?> signIn()async{
    UserCredential userCredential = await firebaseAuth.signInAnonymously();
    final User? user = userCredential.user;
    return user;
  }

  User? getCurrentUser(){
    User? user = firebaseAuth.currentUser;
    if(user!=null){
      return user;
    }
    return null;
  }

}