import 'package:chat_app_firebase/screens.dart';

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
