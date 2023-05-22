import 'package:drinkwater/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/status.dart';
import 'models/user.dart';
import 'providers/sleep_time_provider.dart';
import 'providers/wake_up_provider.dart';
import 'providers/weight_provider.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
  SharedPreferences prefs = await SharedPreferences.getInstance();

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
    child: MyApp(prefs: prefs),
  ));
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const MyApp({required this.prefs, Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ocean",
      debugShowCheckedModeBanner: false,
      navigatorKey: MyApp.navigatorKey,
      initialRoute: '/',
      builder: (context, widget) => ResponsiveWrapper.builder(
          ClampingScrollWrapper.builder(context, widget as Widget),
          defaultScale: true,
          minWidth: 460,
          breakpoints: [
            ResponsiveBreakpoint.resize(645, name: MOBILE),
            ResponsiveBreakpoint.resize(646, name: DESKTOP),
          ]),
      routes: {
        '/': (context) => const MySplashScreen(),
        '/myInitialSetupScreen': (context) => const MyInitialSetupScreen(),
        '/mySliderScreen': (context) => const MySliderScreen(),
        '/myIntroConclusion': (context) => const MyIntroConclusionScreen(),
        '/myAvailableSoonScreen': (context) => const MyAvailableSoonScreen(),
        '/myStatusScreen': (context) => const MyStatusScreen(),
        '/myLoginScreen': (context) => const MyLoginScreen(),
        '/mySettingsScreen': (context) => MySettings(prefs: widget.prefs),
        '/myUserRegistrationScreen': (context) =>
            const MyUserRegistrationScreen(),
        '/myHomePage': (context) => const MyHomePageScreen(),
      },
    );
  }
}
