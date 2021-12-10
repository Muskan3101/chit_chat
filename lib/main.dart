import 'package:chit_chat/authentication/authenticate.dart';
import 'package:chit_chat/screens/chat_room.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'authentication/authenticatefunction.dart';

void main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState() {

    super.initState();
  }

  getLoggedInState() async {
    await AuthenticateFunction.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn = value!;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chit-Chat",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn ?  ChatRoom() : Authenticate(),
    );
  }
}