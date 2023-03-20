// ignore_for_file: prefer_const_constructors,

import 'package:chat_app_firebase/screens/home_page.dart';
import 'package:chat_app_firebase/services/database_services.dart';
import 'package:chat_app_firebase/shared/constants.dart';
import 'package:chat_app_firebase/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfoPage extends StatefulWidget {
  final String adminName;
  final String groupId;
  final String groueName;
  const GroupInfoPage(
      {super.key,
      required this.groueName,
      required this.groupId,
      required this.adminName});

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Group Info",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("EXIT"),
                          content:
                              Text("Are you sure you want to Exit the group?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      await DatabaseServices(
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .toggleGroupJoin(
                                              getName(widget.adminName),
                                              widget.groupId,
                                              widget.groueName)
                                          .whenComplete(() {
                                        nextScreenReplacement(
                                            context, HomePage());
                                      });
                                    },
                                    icon: Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    ))
                              ],
                            ),
                          ],
                        );
                      });
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30)),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: primaryColor,
                  child: Text(
                    widget.groueName.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Group: ${widget.groueName.toUpperCase()}",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Admin: ${getName(widget.adminName)}",
                    ),
                  ],
                )
              ]),
            ),
            memberList(),
          ]),
        ));
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data["members"] != null) {
              if (snapshot.data['members'].length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data['members'].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: primaryColor,
                            child: Text(
                              getName(snapshot.data["members"][index])
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                          title: Text(getName(snapshot.data['members'][index])
                              .toString()),
                          subtitle:
                              Text(getId(snapshot.data['members'][index])),
                        ),
                      );
                    });
              } else {
                return Center(
                  child: Text("No Members"),
                );
              }
            } else {
              return Center(
                child: Text("No Members"),
              );
            }
          } else {
            return CircularProgressIndicator(
              color: primaryColor,
              backgroundColor: Colors.grey,
            );
          }
        });
  }
}
