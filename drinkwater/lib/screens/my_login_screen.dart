import 'package:flutter/material.dart';

import '../constant.dart';
import '../data/remote/api.dart';
import '../utils/user_token_storage.dart';

class MyLoginScreen extends StatefulWidget {
  const MyLoginScreen({Key? key}) : super(key: key);

  @override
  State<MyLoginScreen> createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<MyLoginScreen> {
  final controllerUsername = TextEditingController();
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
                  controller: controllerUsername,
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void doUserLogin() async {
    Api api = Api();

    final email = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();

    String response = await api.login(email, password);

    await UserTokenSecureStorage.setUserToken(response);

    print("BEM VINDO USUÁRIO ${response}");

    Navigator.pushNamed(context, '/myInitialSetupScreen');
  }
}
