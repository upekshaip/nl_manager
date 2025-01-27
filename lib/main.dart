import 'package:flutter/material.dart';
import 'package:nl_manager/pages/course_page.dart';
import 'package:nl_manager/pages/login_page.dart';
import 'package:nl_manager/pages/menu_page.dart';
import 'package:nl_manager/tasks/session_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => SessionStateProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NL File Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black26),
          useMaterial3: true,
        ),
        home: const LoginPage(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/menu': (context) => const MenuPage(),
          '/modules': (context) => const CoursePage(),
        },
      ),
    );
  }
}
