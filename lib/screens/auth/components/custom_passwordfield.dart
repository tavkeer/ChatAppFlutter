import 'package:chat_app_firebase/screens.dart';

class CustomPasswordField extends StatelessWidget {
  const CustomPasswordField({
    Key? key,
    required this.hide,
    required this.passwordController,
    required this.hidePassword,
    required this.hidePasswordColor,
  }) : super(key: key);
  final void Function()? hide;
  final TextEditingController passwordController;
  final bool hidePassword;
  final Color hidePasswordColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      validator: (value) {
        if (value!.length < 6) {
          return "Password must be at least 6 char long";
        } else {
          return null;
        }
      },
      obscureText: hidePassword,
      decoration: textinputdecoration.copyWith(
        label: const Text(
          "Password",
          style: TextStyle(),
        ),
        prefixIcon: const Icon(
          Icons.lock,
          color: primaryColor,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: hidePasswordColor,
          ),
          onPressed: hide,
        ),
      ),
    );
  }
}
