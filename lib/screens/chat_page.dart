// ignore_for_file: prefer_const_constructors

import 'package:chat_app_firebase/screens/group_info.dart';
import 'package:chat_app_firebase/services/database_services.dart';
import 'package:chat_app_firebase/shared/constants.dart';
import 'package:chat_app_firebase/widgets/message_tile.dart';
import 'package:chat_app_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groueName;
  const ChatPage(
      {super.key,
      required this.groueName,
      required this.groupId,
      required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  Stream<QuerySnapshot>? chats;
  String adminName = "";
  @override
  void initState() {
    getChatAdmin();
    super.initState();
  }

  getChatAdmin() {
    DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getChats(widget.groupId)
        .then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupAdmin(widget.groupId)
        .then((value) {
      setState(() {
        adminName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          widget.groueName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfoPage(
                      groueName: widget.groueName,
                      groupId: widget.groupId,
                      adminName: adminName,
                    ));
              },
              icon: Icon(Icons.info))
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              color: Colors.grey[700],
              width: MediaQuery.of(context).size.width,
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Send a message...",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      border: InputBorder.none),
                )),
                SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: ((context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message: snapshot.data.docs[index]['message'],
                        sentByMe: widget.userName ==
                            snapshot.data.docs[index]['sender'],
                        sender: snapshot.data.docs[index]['sender']);
                  })
              : Container();
        }));
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
          .sendMessage(widget.groupId, chatMessageMap);
    }
    setState(() {
      messageController.clear();
    });
  }
}
