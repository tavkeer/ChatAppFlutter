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

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    super.key,
    required this.widget,
  });

  final dynamic widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 180,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.account_circle,
            size: 200,
            color: Colors.grey[700],
          ),
          const SizedBox(
            height: 15,
          ),
          CustomProfileItems(
            detail: widget.userName,
            text: "Full Names :",
          ),
          const Divider(height: 20),
          CustomProfileItems(
            detail: widget.email,
            text: "Email :",
          ),
        ],
      ),
    );
  }
}

class CustomProfileItems extends StatelessWidget {
  const CustomProfileItems({
    Key? key,
    required this.detail,
    required this.text,
  }) : super(key: key);

  final String detail;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 17),
        ),
        Text(
          detail,
          style: const TextStyle(fontSize: 17),
        ),
      ],
    );
  }
}
