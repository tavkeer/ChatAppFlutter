// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app_firebase/screens.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String email;
  const ProfilePage({
    super.key,
    required this.userName,
    required this.email,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        centerTitle: true,
      ),
      drawer: CustomNavigationDrawer(
        email: widget.email,
        userName: widget.userName,
        profile: true,
      ),
      body: ProfileBody(widget: widget),
    );
  }
}
