import 'package:drinkwater/screens/my_intro_conclusion_screen.dart';
import 'package:drinkwater/screens/my_slider_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'providers/sleep_time_provider.dart';
import 'providers/wake_up_provider.dart';
import 'providers/weight_provider.dart';
import 'screens/my_home_page_screen.dart';
import 'screens/my_splash_screen.dart';
import 'screens/my_initial_setup_screen.dart';

void main() async {
  // Inicializando o hive
  await Hive.initFlutter();
  // Registrando o adaptador
  Hive.registerAdapter(UserAdapter());
  // Abrindo a box
  await Hive.openBox<User>('userBox');
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Weight()),
      ChangeNotifierProvider(create: (_) => WakeUp()),
      ChangeNotifierProvider(create: (_) => Sleep()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Box<User> box;

  // @override
  // void initState() {
  //   super.initState();
  //   // Get reference to an already opened box
  //   box = Hive.box('userBox');
  // }

  // bool _isBoxEmpty() {
  //   if (box. == null) {
  //     false;
  //   } else {
  //     return true;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Drink Water",
      debugShowCheckedModeBanner: false,
      initialRoute: true ? '/' : '/myHomePage',
      routes: {
        '/': (context) => const MySplashScreen(),
        '/myInitialSetupScreen': (context) => const MyInitialSetupScreen(),
        '/mySliderScreen': (context) => const MySliderScreen(),
        '/myIntroConclusion': (context) => const MyIntroConclusionScreen(),
        '/myHomePage': (context) => const MyHomePageScreen(),
      },
    );
  }
}
