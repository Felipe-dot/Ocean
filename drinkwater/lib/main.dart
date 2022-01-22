import 'package:flutter/material.dart';

import 'screens/my_splash_screen.dart';
import 'screens/my_initial_setup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Drink Water",
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MySplashScreen(),
        '/myInitialSetupScreen': (context) => const MyInitialSetupScreen(),
      },
    );
  }
}
