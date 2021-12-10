import 'package:chit_chat/authentication/authenticatefunction.dart';
import 'package:chit_chat/screens/chat_room.dart';
import 'package:chit_chat/services/auth.dart';
import 'package:chit_chat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class SignUp extends StatefulWidget {
  final Function toggle;
  const SignUp(this.toggle, {Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  final formkey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      TextEditingController();
  TextEditingController emailTextEditingController =
      TextEditingController();
  TextEditingController passwordTextEditingController =
      TextEditingController();

  signUsUp() {
    if (formkey.currentState!.validate()) {
      Map<String,String> userInfoMap = {
        "name" : userNameTextEditingController.text,
        "email" : emailTextEditingController.text,
      };

      AuthenticateFunction.saveUserEmailSharedPreference(emailTextEditingController.text);
      AuthenticateFunction.saveUserNameSharedPreference(userNameTextEditingController.text);

      setState(() {
        isLoading = true;
      });
      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
        // print("${val.uid}");

        databaseMethods.uploadUserInfo(userInfoMap);
        AuthenticateFunction.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatRoom()));
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
        child: isLoading ? Container(
          child: Center(child: CircularProgressIndicator()),
        ):SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) {
                            return val!.isEmpty || val.length < 3
                                ? "Please Provide UserName"
                                : null;
                          },
                          controller: userNameTextEditingController,
                          decoration:
                              const InputDecoration(hintText: "username"),
                        ),
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
                          decoration:
                              const InputDecoration(hintText: "password"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: (){
                      signUsUp();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: const Text(
                        "Sign Up",
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
                        children: const [
                          Icon(Icons.login,color: Colors.white,),
                          Text(
                                " Sign up with Google",
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
                      const Text("Already have an account?"),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: const Text(
                            "LogIn",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF246EE9),
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
