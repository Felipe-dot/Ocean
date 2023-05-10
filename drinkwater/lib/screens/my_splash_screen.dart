import 'package:drinkwater/constant.dart';
import 'package:drinkwater/models/user.dart';
import 'package:drinkwater/screens/my_home_page_screen.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'my_login_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  late Box<User> box;

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    box = Hive.box('userBox');
  }

  bool _isBoxEmpty() {
    return box.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logoWidth: 50,
      logo: Image(
        image: AssetImage("assets/images/logo.png"),
        width: 150,
        height: 150,
      ),
      backgroundColor: kLightBlue4,
      showLoader: true,
      loadingText: Text(
        "Carregando...",
        style: TextStyle(color: kDark2),
      ),
      loaderColor: kDark1,
      navigator:
          _isBoxEmpty() ? const MyLoginScreen() : const MyHomePageScreen(),
      durationInSeconds: 6,
    );
  }
}
