import 'package:chit_chat/screens/sign_in.dart';
import 'package:chit_chat/screens/sign_up.dart';
import 'package:flutter/material.dart';
class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
     if(showSignIn){
       return SignIn(toggleView);
     }else{
       return SignUp(toggleView);
     }
  }
}
