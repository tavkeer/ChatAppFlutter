// ignore_for_file: prefer_const_constructors

import 'package:chat_app_firebase/screens/group_info.dart';
import 'package:chat_app_firebase/services/database_services.dart';
import 'package:chat_app_firebase/shared/constants.dart';
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
      body: Center(child: Text(widget.groueName.toUpperCase())),
    );
  }
}
