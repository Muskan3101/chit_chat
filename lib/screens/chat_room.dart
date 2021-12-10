import 'package:chit_chat/authentication/authenticate.dart';
import 'package:chit_chat/authentication/authenticatefunction.dart';
import 'package:chit_chat/authentication/constants.dart';
import 'package:chit_chat/screens/message_screen.dart';
import 'package:chit_chat/screens/search.dart';
import 'package:chit_chat/services/auth.dart';
import 'package:chit_chat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream? chatRoomStream;
  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomStream,
        builder: (context,AsyncSnapshot snapshot) {
          return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context,index){
                return ChatRoomsTile(snapshot.data.docs[index].data["chatroomId"].toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                snapshot.data.docs[index].data["chatroomId"]);
              }):Container();
        }
    );
    }
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo()async{
    Constants.myName = (await AuthenticateFunction.getUserNameSharedPreference())!;
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomStream = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chit-Chat",
              style: GoogleFonts.dancingScript(
                  fontStyle: FontStyle.italic,
                  fontSize: 40,
                  fontWeight: FontWeight.w500)),
          backgroundColor: const Color(0xFF246EE9),
          actions: [
            GestureDetector(
              onTap: (){
                authMethods.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Authenticate()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.exit_to_app)
              ),
            )
          ],
        ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  const ChatRoomsTile(this.userName, this.chatRoomId,{Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MessageScreen(chatRoomId)));
      },
      child: Container(
        color: Colors.white60,
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}",style: const TextStyle(color: Colors.white,fontSize: 17),),
            ),
            const SizedBox(width: 8,),
            Text(userName,style: const TextStyle(color: Colors.white,fontSize: 17),)
          ],
        ),
      ),
    );
  }
}





