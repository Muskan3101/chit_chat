import 'package:chit_chat/authentication/authenticatefunction.dart';
import 'package:chit_chat/screens/chat_room.dart';
import 'package:chit_chat/services/auth.dart';
import 'package:chit_chat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class SignIn extends StatefulWidget {
  final Function toggle;
  const SignIn(this.toggle, {Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  bool isLoading = false;
  QuerySnapshot <Map<String, dynamic>>? snapshotUserInfo;

  signIn(){
    if(formKey.currentState!.validate()){

      AuthenticateFunction.saveUserEmailSharedPreference(emailTextEditingController.text);
      // TODO function to get User Details
      setState(() {
        isLoading = true;
      });

      databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
        snapshotUserInfo = val;
        AuthenticateFunction.saveUserEmailSharedPreference(snapshotUserInfo!.docs[0].data()["name"]);

      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
        if(val!=null){
          AuthenticateFunction.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("Chit-Chat",
                style: GoogleFonts.dancingScript(
                    fontStyle: FontStyle.italic,
                    fontSize: 40,
                    fontWeight: FontWeight.w500))),
        backgroundColor: const Color(0xFF246EE9),
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val!)
                                ? null
                                : "Enter valid email";
                          },
                          controller: emailTextEditingController,
                          decoration: const InputDecoration(hintText: "e-mail"),
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (val){
                            return val!.length > 6 ? null : "Please provide password 6+ characters";
                          },
                          controller: passwordTextEditingController,
                          decoration: const InputDecoration(hintText: "password"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child:  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: GestureDetector(
                        onTap: (){},
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(
                              color: Colors.black54, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: (){
                      signIn();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                          color: const Color(0xFF246EE9),
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const[
                          Icon(Icons.login,color: Colors.white,),
                          Text(
                                " Sign in with Google",
                                style: TextStyle(color: Colors.white),
                              ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have account?"),
                      GestureDetector(
                        onTap: (){
                          widget.toggle();
                          },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                            "Register now",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF246EE9),
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 50,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//13:02 part 3
