import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/status.dart';
import 'models/user.dart';
import 'providers/sleep_time_provider.dart';
import 'providers/wake_up_provider.dart';
import 'providers/weight_provider.dart';
import 'screens/screens.dart';

void main() async {
  // Inicializando o hive
  await Hive.initFlutter();
  // Registrando o adaptador
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(WaterStatusAdapter());
  // Abrindo a box
  await Hive.openBox<User>('userBox');
  await Hive.openBox<WaterStatus>('statusBox');
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
  const MyApp({Key? key}) : super(key: key);

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
        '/mySliderScreen': (context) => const MySliderScreen(),
        '/myIntroConclusion': (context) => const MyIntroConclusionScreen(),
        '/myAvailableSoonScreen': (context) => const MyAvailableSoonScreen(),
        '/myStatusScreen': (context) => const MyStatusScreen(),
        '/mySettingsScreen': (context) => const MySettings(),
        '/myUserRegistrationScreen': (context) =>
            const MyUserRegistrationScreen(),
        '/myHomePage': (context) => const MyHomePageScreen(),
      },
    );
  }
}
