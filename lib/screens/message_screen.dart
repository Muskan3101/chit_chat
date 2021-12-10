import 'package:chit_chat/authentication/constants.dart';
import 'package:chit_chat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class MessageScreen extends StatefulWidget {
  final String chatRoomId;
  const MessageScreen(this.chatRoomId, {Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageTextEditingController = TextEditingController();

  Stream? chatMessageStream;
  Widget chatMessageList(){
    return StreamBuilder(
      stream: chatMessageStream,
        builder: (context,AsyncSnapshot snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context,index){
            return MessageTile(snapshot.data.docs[index].data["message"],
            snapshot.data.docs[index].data["sendBy"] == Constants.myName
            );
          }) : Container();
        }
    );
  }
  sendMessage(){
    if(messageTextEditingController.text.isNotEmpty){
      Map<String,dynamic> messageMap={
        "message" : messageTextEditingController.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId,messageMap);
      messageTextEditingController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
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
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black12,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                            controller: messageTextEditingController,
                            decoration: const InputDecoration(
                                hintText: "Message....",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none))),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [Colors.white60, Colors.white12]),
                              borderRadius: BorderRadius.circular(40)),
                          padding: const EdgeInsets.all(12),
                          child: Image.asset("images/send.png")),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  const MessageTile(this.message, this.isSendByMe, {Key? key}) : super(key: key)  ;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe? 0 :24 , right: isSendByMe? 24 : 0 ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [
              const Color(0xFF007EF4),
              const Color(0xFF2A75BC)
            ] : [
              Colors.white12,
              Colors.white12
            ]
          ),
          borderRadius: isSendByMe ? const BorderRadius.only(topLeft: Radius.circular(23),topRight: Radius.circular(23),bottomLeft: Radius.circular(23)):
          const BorderRadius.only(topLeft: Radius.circular(23),topRight: Radius.circular(23),bottomRight: Radius.circular(23))
        ),
        child: Text(message,style: const TextStyle(fontSize: 17),),
      ),
    );
  }
}

//24:10 part 4
