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
    return ListTile(
      title: Text(widget.groupId),
      subtitle: Text(widget.groueName),
    );
  }
}
