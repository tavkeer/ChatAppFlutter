import 'package:chat_app_firebase/screens.dart';

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
