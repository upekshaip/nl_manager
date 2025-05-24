import 'package:flutter/material.dart';
import 'package:nlmanager/components/my_loading.dart';
import 'package:nlmanager/components/my_text_feild.dart';
import 'package:nlmanager/components/primary_btn.dart';
import 'package:nlmanager/pages/menu_page.dart';
import 'package:nlmanager/tasks/course_state.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:nlmanager/tasks/session_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool autoLogin = false;
  int schedule = 6;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  // user login
  Future userLogIn() async {
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MenuPage()),
        (route) => false, // Remove all routes
      );
    }
  }

  void loadSettings() {
    var box = Hive.box('nlmanager');

    autoLogin = box.get("auto_login", defaultValue: false);
    Map<String, dynamic> defaultValue = {
      "username": "",
      "password": "",
      "schedule": 6
    };
    Map<dynamic, dynamic>? userData =
        box.get("user_data", defaultValue: defaultValue);

    usernameController.text = userData?["username"] ?? "";
    passwordController.text = userData?["password"] ?? "";
    schedule = userData?["schedule"] ?? 6;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SessionState, CourseStateProvider>(
      builder: (context, mySession, myCourse, child) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Image.asset(
                  'assets/NLearn_Bg.png',
                  height: 75,
                ),
                const SizedBox(
                  height: 60,
                ),
                // welcome message
                Text(
                  "Welcome to NL File Manager",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 25,
                ),
                // login fields
                MyTextFeild(
                  controller: usernameController,
                  isEnabled: !(mySession.isLoginLoading),
                  hintText: "Username",
                  obscureText: false,
                ),
                const SizedBox(
                  height: 25,
                ),
                MyTextFeild(
                  controller: passwordController,
                  isEnabled: !(mySession.isLoginLoading),
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                // login button
                if (!mySession.isLoginLoading)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: PrimaryBtn(
                      text: "Login",
                      onTap: () async {
                        bool islogin = await mySession.login(
                          myCourse,
                          usernameController.text,
                          passwordController.text,
                        );
                        if (islogin) {
                          await userLogIn();
                        }
                      },
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                // login status message
                if (mySession.loginStatus.isNotEmpty &&
                    !mySession.isLoginLoading)
                  Text(
                    mySession.loginStatus,
                    style: const TextStyle(fontSize: 14, color: Colors.red),
                  ),
                if (mySession.isLoginLoading) const MyLoading(),
                // developer info
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Developed by Group 21",
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
