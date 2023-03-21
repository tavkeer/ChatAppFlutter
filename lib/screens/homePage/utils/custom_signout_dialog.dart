import 'package:chat_app_firebase/screens.dart';

class CustomSignoutDialog extends StatelessWidget {
  const CustomSignoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text("Are you sure you want to logout?"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            ),
            IconButton(
              onPressed: () async {
                await AuthService().signout().whenComplete(
                      () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false),
                    );
              },
              icon: const Icon(
                Icons.done,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
