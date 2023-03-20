import 'package:chat_app_firebase/screens.dart';

class CustomNameField extends StatelessWidget {
  const CustomNameField({
    super.key,
    required this.nameController,
  });

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      validator: (val) {
        return (val!.isEmpty) ? "Name cannot be empty" : null;
      },
      decoration: textinputdecoration.copyWith(
        label: const Text(
          "Full Name",
        ),
        prefixIcon: const Icon(
          Icons.person,
          color: primaryColor,
        ),
      ),
    );
  }
}
