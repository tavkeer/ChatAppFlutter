import 'package:chat_app_firebase/screens.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  //hide/unhide password
  bool hidePass = true;

  //change view password color
  Color hidePassColor = Colors.grey;

  //form key
  final formkey = GlobalKey<FormState>();

  //email controller
  TextEditingController emailController = TextEditingController();

  // password controller
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              backgroundColor: primaryColor,
              color: Colors.white,
            ))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 80,
                ),
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Groupie",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Login now to see what they are talking",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          )),
                      Image.asset("assets/login.png"),

                      //email field
                      CustomEmailField(emailController: emailController),
                      const SizedBox(height: 15),

                      //password field
                      CustomPasswordField(
                        passwordController: passwordController,
                        hidePassword: hidePass,
                        hidePasswordColor: hidePassColor,
                        hide: passwordHide,
                      ),
                      const SizedBox(height: 20),

                      //loginbutton
                      CustomButton(ontap: login, text: "Login"),
                      const SizedBox(height: 15),

                      //Registration toggle
                      const ToggleLoginRegisterPage()
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  //hide password function
  void passwordHide() {
    hidePass = !hidePass;
    hidePassColor = hidePassColor == Colors.grey ? primaryColor : Colors.grey;
    setState(() {});
  }

  //login function
  login() async {
    if (formkey.currentState!.validate()) {
      setState(() => isLoading = true);
      await AuthService()
          .loggInWithUserNameAndPassord(
              emailController.text, passwordController.text)
          .then(
        (value) async {
          if (value == true) {
            QuerySnapshot snapshot =
                await DatabaseServices(uid: AuthService.user).gettingUserData(
              emailController.text,
            );
            //saving the value to our shared preferences
            await HelperFunctions.saveUserLoggedInStatus(true);
            await HelperFunctions.saveUserEmailSF(emailController.text);
            await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
            getNextDesiredPage();
          } else {
            showSnackBar(
              context,
              Colors.red.shade400,
              value.toString(),
            );
            setState(() => isLoading = false);
          }
        },
      );
    }
  }

  getNextDesiredPage() {
    nextScreenReplacement(context, const HomePage());
  }
}
