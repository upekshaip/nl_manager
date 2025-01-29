import 'package:flutter/material.dart';
import 'package:nlmanager/pages/course_page.dart';
import 'package:nlmanager/pages/downloader_page.dart';
import 'package:nlmanager/pages/login_page.dart';
import 'package:nlmanager/pages/menu_page.dart';
import 'package:nlmanager/tasks/course_state.dart';
import 'package:nlmanager/tasks/downloader_state.dart';
import 'package:nlmanager/tasks/session_state.dart';
import 'package:nlmanager/themes/dark_theme.dart';
import 'package:nlmanager/themes/light_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SessionStateProvider()),
        ChangeNotifierProvider(create: (context) => DownloadStateProvider()),
        ChangeNotifierProvider(create: (context) => CourseStateProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NL File Manager',
        theme: darkTheme,
        darkTheme: darkTheme,
        home: const LoginPage(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/menu': (context) => const MenuPage(),
          '/modules': (context) => const CoursePage(),
          '/downloader': (context) => const DownloaderPage(),
        },
      ),
    );
  }
}
