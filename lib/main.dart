import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nlmanager/pages/course_page.dart';
import 'package:nlmanager/pages/downloader_page.dart';
import 'package:nlmanager/pages/login_page.dart';
import 'package:nlmanager/pages/menu_page.dart';
import 'package:nlmanager/pages/settings_page.dart';
import 'package:nlmanager/tasks/course_state.dart';
import 'package:nlmanager/tasks/downloader_state.dart';
import 'package:nlmanager/tasks/session_state.dart';
import 'package:nlmanager/tasks/settings_state.dart';
import 'package:nlmanager/themes/dark_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  // test inside states
  await Hive.initFlutter(); // init
  await Hive.openBox('nlmanager'); // Open a Hive box
  // notifications
  AwesomeNotifications().initialize(
    null, // Use 'resource://drawable/app_icon' for a custom icon
    [
      NotificationChannel(
        channelKey: 'NLManager',
        channelName: 'Progress Notifications',
        channelDescription: 'Notification with a progress bar',
        // icon: 'resource://drawable/res_app_icon',
        defaultColor: const Color(0xFF2979FF),
        ledColor: Colors.blue,
        importance: NotificationImportance.High,
        enableVibration: true,
      )
    ],
    debug: false,
  );

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
        ChangeNotifierProvider(create: (context) => SettingsStateProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NL File Manager',
        theme: darkTheme,
        home: const LoginPage(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/menu': (context) => const MenuPage(),
          '/modules': (context) => const CoursePage(),
          '/downloader': (context) => const DownloaderPage(),
          '/settings': (context) => const SettingsPage(),
        },
      ),
    );
  }
}
