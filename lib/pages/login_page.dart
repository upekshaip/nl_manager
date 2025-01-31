import 'package:flutter/material.dart';
import 'package:nlmanager/components/my_loading.dart';
import 'package:nlmanager/components/my_text_feild.dart';
import 'package:nlmanager/components/primary_btn.dart';
import 'package:nlmanager/pages/menu_page.dart';
import 'package:nlmanager/tasks/course_state.dart';
import 'package:nlmanager/tasks/session_state.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Consumer2<SessionStateProvider, CourseStateProvider>(
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
                  isEnabled: !mySession.isLoginLoading,
                  hintText: "Username",
                  obscureText: false,
                ),
                const SizedBox(
                  height: 25,
                ),
                MyTextFeild(
                  controller: passwordController,
                  isEnabled: !mySession.isLoginLoading,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                // login button
                if (mySession.isLoginLoading == false)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: PrimaryBtn(
                      text: "Login",
                      onTap: () async {
                        bool islogin = await mySession.login(myCourse, usernameController.text, passwordController.text);
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
                if (mySession.loginStatus.isNotEmpty && mySession.isLoginLoading == false)
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
                  "Developed by upekshaip",
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          ))),
    );
  }
}
