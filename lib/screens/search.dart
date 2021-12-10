import 'package:chit_chat/authentication/constants.dart';
import 'package:chit_chat/screens/message_screen.dart';
import 'package:chit_chat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();
  QuerySnapshot<Map<String, dynamic>>? searchSnapshot;

  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  /// create chatroom,send user to the conversation screen,pushreplacement
  createChatroomAndStartConversation(String userName) {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) =>  MessageScreen(chatRoomId)));
    } else {
      print("You can not send message to YourSelf");
    }
  }

  Widget searchTile({required String userName, required String userEmail}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName),
            Text(userEmail),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        IconButton(
            onPressed: () {
              createChatroomAndStartConversation(userName);
            },
            icon: const Icon(
              Icons.message_outlined,
              color: Colors.blue,
            ))
      ],
    );
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshot!.docs[index].data()["name"],
                userEmail: searchSnapshot!.docs[index].data()["email"],
              );
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text("Chit-Chat",
              style: GoogleFonts.dancingScript(
                  fontStyle: FontStyle.italic,
                  fontSize: 40,
                  fontWeight: FontWeight.w500)),
        ),
        backgroundColor: const Color(0xFF246EE9),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.black12,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: searchTextEditingController,
                          decoration: const InputDecoration(
                              hintText: "search username....",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none))),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.white60, Colors.white12]),
                            borderRadius: BorderRadius.circular(40)),
                        padding: const EdgeInsets.all(12),
                        child: Image.asset("images/search_icon.png")),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) async {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
