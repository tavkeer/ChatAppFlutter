import 'package:chat_app_firebase/screens.dart';

class ToggleLoginRegisterPage extends StatelessWidget {
  final String leadingText;
  final String buttonText;
  final dynamic nextPage;
  const ToggleLoginRegisterPage({
    Key? key,
    required this.leadingText,
    required this.buttonText,
    required this.nextPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: buttonText,
            style: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => nextScreen(context, nextPage),
          )
        ],
        text: leadingText,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }
}
