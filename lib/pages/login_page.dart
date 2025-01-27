import 'package:flutter/material.dart';
import 'package:nl_manager/components/my_button.dart';
import 'package:nl_manager/components/my_loading.dart';
import 'package:nl_manager/components/my_text_feild.dart';
import 'package:nl_manager/pages/menu_page.dart';
import 'package:nl_manager/tasks/course_task.dart';
import 'package:nl_manager/tasks/login_task.dart';
import 'package:nl_manager/tasks/session_state.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String loginStatus = "";
  bool isLoading = false;

  // user login
  void userLogIn() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        loginStatus = "Please enter username and password";
      });
      return;
    }
    setState(() {
      isLoading = true;
    });

    final sessionProvider = context.read<SessionStateProvider>();
    sessionProvider.startNewSession();
    final session = sessionProvider.getMySession();

    var myLogin = Login(username: usernameController.text, password: passwordController.text, session: session);
    var tokens = await myLogin.getToken();

    if (tokens!.containsKey("error")) {
      setState(() {
        loginStatus = tokens["error"]!;
        isLoading = false;
      });
      return;
    }
    if (tokens.containsKey("cookie")) {
      setState(() {
        sessionProvider.setTokens(tokens);
        sessionProvider.setUser(usernameController.text, passwordController.text);
        loginStatus = "";
        isLoading = false;
      });
      Map<String, dynamic> todos = await Course(tokens: tokens.cast<String, String?>(), session: session, reverseDays: 15).getTodos();
      if (!todos.containsKey("error")) {
        sessionProvider.setTodos(todos["todos"]);
      }
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MenuPage()),
          (route) => false, // Remove all routes
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
              ),
              const SizedBox(
                height: 25,
              ),
              // login fields
              MyTextFeild(
                controller: usernameController,
                isEnabled: !isLoading,
                hintText: "Username",
                obscureText: false,
              ),
              const SizedBox(
                height: 25,
              ),
              MyTextFeild(
                controller: passwordController,
                isEnabled: !isLoading,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(
                height: 30,
              ),
              // login button
              if (isLoading == false)
                MyButton(
                  onTap: userLogIn,
                ),
              const SizedBox(
                height: 20,
              ),
              // login status message
              if (loginStatus.isNotEmpty && isLoading == false)
                Text(
                  loginStatus,
                  style: const TextStyle(fontSize: 14, color: Colors.red),
                ),

              if (isLoading)
                const MyLoading(
                  message: "Loading...",
                ),
              // developer info
              const SizedBox(
                height: 8,
              ),
              Text(
                "Developed by upekshaip",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              )
            ],
          ),
        )));
  }
}
