import 'package:chat_app_firebase/screens.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream? groups;
  String userName = "";
  String email = "";
  bool isloading = false;
  String groupName = "";

  AuthService authService = AuthService();

  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => nextScreen(context, const SearchPage()),
            icon: const Icon(Icons.search),
          )
        ],
        title: const Text(
          "Groups",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: CustomNavigationDrawer(
        userName: userName,
        email: email,
        groups: true,
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => popUpDialog(context),
        backgroundColor: primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  //String manuplation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  //String manuplation
  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  //getting user personal data
  gettingUserData() async {
    await HelperFunctions.getUserNameFromSF().then(
      (value) {
        setState(() => userName = value!);
      },
    );
    await HelperFunctions.getUserEmailFromSF().then(
      (value) {
        setState(() => email = value!);
      },
    );
    //getting the list of snapshots in our stream
    await DatabaseServices(uid: AuthService.user).getUserGroups().then(
      (snapshot) {
        setState(() => groups = snapshot);
      },
    );
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        //before returning make some checks
        if (snapshot.hasData) {
          if (snapshot.data["groups"] != null) {
            if (snapshot.data["groups"].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data["groups"].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      groueName: getName(snapshot.data["groups"][reverseIndex]),
                      groupId: getId(snapshot.data["groups"][reverseIndex]),
                      userName: snapshot.data["fullName"]);
                },
              );
            } else {
              return noGroupWidget(context);
            }
          } else {
            return noGroupWidget(context);
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
              backgroundColor: Colors.grey,
            ),
          );
        }
      },
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          title: const Text(
            "Create a group",
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isloading
                  ? const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: primaryColor,
                      ),
                    )
                  : TextField(
                      onChanged: (value) {
                        setState(() => groupName = value);
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() => isloading = true);
                      DatabaseServices(
                        uid: FirebaseAuth.instance.currentUser!.uid,
                      )
                          .createGroup(userName,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(
                            () => isloading = false,
                          );
                      Navigator.of(context).pop();
                      showSnackBar(
                        context,
                        Colors.green,
                        "Group created successfully",
                      );
                    }
                  },
                  child: const Text(
                    "CREATE",
                    style: TextStyle(),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  noGroupWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Center(
              child: Icon(
                Icons.add_circle,
                color: Colors.grey[700],
                size: 75,
              ),
            ),
            onPressed: () => popUpDialog(context),
          ),
          const SizedBox(
            height: 50,
          ),
          const Center(
            child: Text(
              "You have not joined any group Yet!!!",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
