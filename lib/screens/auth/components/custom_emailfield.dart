import 'package:chat_app_firebase/screens.dart';

class CustomEmailField extends StatelessWidget {
  const CustomEmailField({
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      validator: (val) {
        return RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(val!)
            ? null
            : "Please enter a valid email";
      },
      decoration: textinputdecoration.copyWith(
        label: const Text("Email"),
        prefixIcon: const Icon(
          Icons.email,
          color: primaryColor,
        ),
      ),
    );
  }
}
