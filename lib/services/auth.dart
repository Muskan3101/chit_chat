import 'package:chit_chat/modals/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  WeUser? _userFromFirebaseUser(User user){
    if (user !=null) {
      return WeUser(userId: user.uid);
    } else {
      return null;
    }
  }
   Future signInWithEmailAndPassword(String email,String password) async {
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      return _userFromFirebaseUser(user!);
    }catch(e){
      print(e.toString());
    }
  }
  Future signUpWithEmailAndPassword(String email,String password) async {
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      return _userFromFirebaseUser(user!);
    }catch(e){
      print(e.toString());
    }
  }
  Future resetPassword(String email) async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }
}