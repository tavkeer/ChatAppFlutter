// ignore_for_file: unnecessary_brace_in_string_interps, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final String? uid;
  DatabaseServices({required this.uid});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  // saving the userdata
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //gettig user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  //creating a group

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "groupAdmin": "${id}_${userName}",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": ""
    });
    //update the members
    //in this case we only add admin as group member
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userdocumentReference = userCollection.doc(uid);
    return await userdocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_${groupName}"]),
    });
  }

  //getchats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  //get group admin
  Future getGroupAdmin(String groupid) async {
    DocumentReference d = groupCollection.doc(groupid);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["groupAdmin"];
  }

  //get members
  getGroupMembers(String groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  //search by name
  searchByName(String groupName) async {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains('${groupId}_${groupName}')) {
      return true;
    } else {
      return false;
    }
  }

  Future toggleGroupJoin(
      String userName, String groupId, String groupName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_${groupName}")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_${groupName}"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_${userName}"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_${groupName}"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_${userName}"])
      });
    }
  }
}
