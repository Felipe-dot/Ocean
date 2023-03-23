import 'package:flutter/material.dart';

import '../constant.dart';
import '../data/remote/api.dart';

class MyUserRegistrationScreen extends StatefulWidget {
  const MyUserRegistrationScreen({Key? key}) : super(key: key);

  @override
  _MyUserRegistrationScreenState createState() =>
      _MyUserRegistrationScreenState();
}

class _MyUserRegistrationScreenState extends State<MyUserRegistrationScreen> {
  final controllerPassword = TextEditingController();
  final controllerPasswordEqual = TextEditingController();
  final controllerEmail = TextEditingController();

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
                  child: Text('Cadastre-se',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Center(
                  child: Text('Crie uma conta, para usufruir do Ocean',
                      style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: controllerEmail,
                  keyboardType: TextInputType.emailAddress,
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
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  obscureText: true,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Senha'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPasswordEqual,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Repita a senha'),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 50,
                  child: TextButton(
                    child: const Text('Criar conta'),
                    onPressed: () => doUserRegistration(),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                SizedBox(
                  height: 50,
                  child: TextButton(
                    child: const Text('Voltar'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void showSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sucesso!"),
          content: const Text("O usuário foi criado!"),
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

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Erro!"),
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

  void doUserRegistration() async {
    Api api = Api();

    //Sigup code here
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();
    final passwordEqual = controllerPasswordEqual.text.trim();

    if (password != passwordEqual) {
      showError('As senhas não coincidem');
      return;
    }

    String response = await api.signUp(email, password);

    showSuccess();

    print("OLA MEU AMIGO : ${response}");

    Navigator.pop(context);
  }
}
