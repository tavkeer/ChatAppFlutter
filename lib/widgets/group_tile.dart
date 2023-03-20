// ignore_for_file: prefer_const_constructors

import 'package:chat_app_firebase/screens/chat_page.dart';
import 'package:chat_app_firebase/shared/constants.dart';
import 'package:chat_app_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groueName;
  const GroupTile(
      {super.key,
      required this.groueName,
      required this.groupId,
      required this.userName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
              groueName: widget.groueName,
              groupId: widget.groupId,
              userName: widget.userName,
            ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: primaryColor,
            child: Text(
              widget.groueName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            widget.groueName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Join the conversation as ${widget.userName}",
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
