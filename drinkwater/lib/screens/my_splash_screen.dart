import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import '../constant.dart';
import 'my_login_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 14,
      navigateAfterSeconds: const MyLoginScreen(),
      image: Image.asset(
        "assets/images/logoSplashScreen.png",
        alignment: Alignment.center,
      ),
      backgroundColor: kMainColor,
      loaderColor: kWhite,
      photoSize: 200,
    );
  }
}