import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constant.dart';

class MyLoginScreen extends StatelessWidget {
  const MyLoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: kWhite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Image(
                image: AssetImage("assets/images/logo.png"),
                height: 89,
                width: 145,
              ),
              const SizedBox(
                width: 203,
                height: 41,
                child: Text(
                  "Bem vindo(a)",
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 34,
                    fontWeight: FontWeight.normal,
                    color: kDark1,
                  ),
                ),
              ),
              const Image(
                image: AssetImage("assets/images/imagem.png"),
                width: 247,
                height: 208,
              ),
              const Text(
                "Faça login com o google  ou inicie uma sessão como convidado",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: kGray,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Icon(FontAwesomeIcons.google),
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        "LOGAR COM O GOOGLE",
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 18,
                          color: kWhite,
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: kMainColor,
                    elevation: 2,
                    padding: const EdgeInsets.all(20),
                    enableFeedback: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Row(children: const [
                  Expanded(
                      child: Divider(
                    color: kLightBlue3,
                  )),
                  Text(
                    "OU",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 12,
                      color: kLightBlue3,
                    ),
                  ),
                  Expanded(
                      child: Divider(
                    color: kLightBlue3,
                  )),
                ]),
              ),
              TextButton(
                child: const Text(
                  "Entrar como convidado",
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 20,
                    color: kLightBlue1,
                  ),
                ),
                onPressed: () {
                    Navigator.pushNamed(context, '/myInitialSetupScreen');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
