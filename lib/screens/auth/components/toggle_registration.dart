import 'package:chat_app_firebase/screens.dart';

class ToggleLoginRegisterPage extends StatelessWidget {
  const ToggleLoginRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: ' Register Here!',
            style: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                nextScreen(
                  context,
                  const RegisterPage(),
                );
              },
          )
        ],
        text: "Don't have an account?",
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }
}
