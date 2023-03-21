import 'package:chat_app_firebase/screens.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({
    Key? key,
    this.groups = false,
    this.profile = false,
    required this.userName,
    required this.email,
  }) : super(key: key);
  final bool groups;
  final bool profile;
  final String userName;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(top: 50),
        children: [
          Icon(
            Icons.account_circle,
            size: 150,
            color: Colors.grey[700],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            userName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Divider(
            height: 2,
            color: Colors.black45,
          ),
          ListTile(
            onTap: () => (!groups)
                ? nextScreenReplacement(context, const HomePage())
                : null,
            selectedColor: primaryColor,
            selected: groups,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.group,
            ),
            title: const Text(
              "Groups",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () => (!profile)
                ? nextScreenReplacement(
                    context,
                    ProfilePage(userName: userName, email: email),
                  )
                : null,
            selectedColor: primaryColor,
            selected: profile,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.person,
            ),
            title: const Text(
              "Profile",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () => popUp(context),
            selectedColor: primaryColor,
            selected: false,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.exit_to_app,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}

popUp(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
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
                    () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (route) => false);
                    },
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
    },
  );
}
