// ignore_for_file: prefer_const_constructors

import 'package:chat_app_firebase/screens.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  bool hidePass = true;
  Color hidePassColor = Colors.grey;
  final formkey = GlobalKey<FormState>();

  //email Controller
  TextEditingController emailController = TextEditingController();

  //password controller
  TextEditingController passwordController = TextEditingController();

  //name controller
  TextEditingController nameController = TextEditingController();

  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                backgroundColor: primaryColor,
                color: Colors.white,
              ),
            )
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
                      Text(
                        "Groupie",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Create your account to chat and explore!",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Image.asset("assets/register.png"),

                      //full name field
                      CustomNameField(nameController: nameController),
                      SizedBox(height: 15),

                      //email field
                      CustomEmailField(emailController: emailController),
                      SizedBox(height: 15),

                      //password field
                      CustomPasswordField(
                        hide: hidePassOnTap,
                        passwordController: passwordController,
                        hidePassword: hidePass,
                        hidePasswordColor: hidePassColor,
                      ),
                      SizedBox(height: 20),

                      //toggle Registration Screen
                      CustomButton(text: "Resgister", ontap: register),
                      SizedBox(
                        height: 15,
                      ),

                      //toggle Registration
                      ToggleLoginRegisterPage(
                        leadingText: "Already have an Account  ",
                        buttonText: "Login!",
                        nextPage: const LoginPage(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  //to avoid build context error
  void nextScreen() {
    nextScreenReplacement(context, HomePage());
  }

  //toggle hide password
  void hidePassOnTap() {
    hidePass = !hidePass;
    hidePassColor = hidePassColor == Colors.grey ? primaryColor : Colors.grey;
    setState(() {});
  }

  //register user for first time
  register() async {
    if (formkey.currentState!.validate()) {
      setState(() => isLoading = true);
      await authService
          .registerUser(nameController.text, emailController.text,
              passwordController.text)
          .then(
        (value) async {
          if (value == true) {
            //saving the shared preference
            await HelperFunctions.saveUserLoggedInStatus(true);
            await HelperFunctions.saveUserEmailSF(emailController.text);
            await HelperFunctions.saveUserNameSF(nameController.text);

            //for avoiding build context errors
            nextScreen();
          } else {
            showSnackBar(context, Colors.red.shade400, value);
            setState(() => isLoading = false);
          }
        },
      );
    }
  }
}
