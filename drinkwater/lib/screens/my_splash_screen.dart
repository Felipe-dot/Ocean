import 'package:drinkwater/models/user.dart';
import 'package:drinkwater/screens/my_home_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../data/remote/api.dart';
import '../utils/user_token_storage.dart';
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

  Future<bool> _validateToken() async {
    Api api = Api();
    var token = await UserTokenSecureStorage.getUserToken();
    var response = await api.validateToken(token);

    return response == "TOKEN_INVÁLIDO" ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return _isBoxEmpty() ? const MyLoginScreen() : const MyHomePageScreen();
    // _isBoxEmpty() ? const MyLoginScreen() : const MyTestScreen(),
  }
}
