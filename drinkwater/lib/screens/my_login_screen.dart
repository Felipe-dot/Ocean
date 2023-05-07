import 'package:drinkwater/models/userData.dart';
import 'package:drinkwater/models/waterHistory.dart';
import 'package:drinkwater/utils/water_id_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constant.dart';
import '../data/remote/api.dart';
import '../models/status.dart';
import '../models/user.dart';
import '../utils/my_utils.dart';
import '../utils/user_id_storage.dart';
import '../utils/user_token_storage.dart';

class MyLoginScreen extends StatefulWidget {
  const MyLoginScreen({Key? key}) : super(key: key);

  @override
  State<MyLoginScreen> createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<MyLoginScreen> {
  late Box<User> userBox;
  late Box<WaterStatus> waterStatusBox;
  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    userBox = Hive.box('userBox');
    waterStatusBox = Hive.box('statusBox');
  }

  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        color: kLightBlue4,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 250,
                  child: Image.asset('assets/images/logo.png'),
                ),
                const Center(
                  child: Text('Bem Vindo',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Center(
                  child: Text('Entre ou Cadastre-se',
                      style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: controllerEmail,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Email'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Senha'),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 50,
                  child: TextButton(
                    child: const Text('Entrar'),
                    onPressed: () => doUserLogin(),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                SizedBox(
                  height: 50,
                  child: TextButton(
                    child: const Text('Cadastrar-se'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/myUserRegistrationScreen');
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pushNamed(context, '/myLoginScreen');
              },
            ),
          ],
        );
      },
    );
  }

  Future<int> getDataForParseServer() async {
    Api api = Api();

    var token = await UserTokenSecureStorage.getUserToken();

    List<dynamic> response = await api.getUserData(token);
    List<dynamic> waterHistory = await api.getWaterHistory(token);

    UserData user = createUserData(response[0]);
    List<WaterHistory> waterHistoryList =
        createAListOfWaterHistory(waterHistory);

    try {
      userBox.add(
        User(
          userWeight: user.userWeight,
          userWakeUpTime: user.wakeUpTime,
          userSleepTime: user.sleepTime,
          additionalReminder: false,
          notificationTimeList: user.notificationTimeList,
        ),
      );

      waterHistoryList.forEach((element) {
        waterStatusBox.add(WaterStatus(
          drinkingWaterGoal: user.waterIntakeGoal,
          amountOfWaterDrank: element.amountOfWaterDrank,
          goalOfTheDayWasBeat: element.goalOfTheDayWasBeat,
          statusDay: element.statusDay,
          drinkingFrequency: element.drinkFrequency,
        ));
      });

      await WaterIdSecureStorage.setWaterIdString(waterHistoryList.last.id);

      return 1;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  void doUserLogin() async {
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();

    if (password.isEmpty && email.isEmpty) {
      showError('Informe um email e senha');
      return;
    } else if (password.isEmpty) {
      showError('Informe uma senha');
      return;
    } else if (email.isEmpty) {
      showError('Informe um email');
      return;
    }

    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    Api api = Api();

    try {
      String response = await api.login(email, password);

      await UserTokenSecureStorage.setUserToken(response);
      var userId = await api.getCurrentUser(response);

      await UserIdSecureStorage.setUserIdString(userId['id']);

      print("BEM VINDO USUÁRIO ${response}");

      Navigator.of(context).pop();

      List<dynamic> userData = await api.getUserData(response);

      if (userData.isEmpty) {
        Navigator.pushNamed(context, '/myInitialSetupScreen');
      } else {
        await getDataForParseServer();
        Navigator.pushNamed(context, '/myHomePage');
      }
    } catch (e) {
      showError('Algo deu errado tente novamente');
      return;
    }
  }
}
