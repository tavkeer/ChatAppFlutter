import 'screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getDevice();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //letting user signed in
  late bool _isSignedIn;
  @override
  void initState() {
    getLoggedInStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.grey.shade200,
      ),
      debugShowCheckedModeBanner: false,
      home: _isSignedIn ? const HomePage() : const LoginPage(),
    );
  }

  void getLoggedInStatus() {
    HelperFunctions.getUserLoggedInStatus().then(
      (value) {
        if (value != null) {
          setState(() => _isSignedIn = value);
        }
      },
    );
  }
}

getDevice() async {
  if (kIsWeb) {
    //run web app
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "Your-own-API-key",
        appId: "Your-own-App_Id",
        messagingSenderId: "Your-own-MessagingSenderId",
        projectId: "Your-own-ProjectId",
      ),
    );
  } else {
    //run for ios or android
    await Firebase.initializeApp();
  }
}
