import 'package:drinkwater/components/buttons/my_cta_with_icon_left.dart';
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                  style: kBody1,
                  textAlign: TextAlign.center,
                ),
                MyCtaWithIconLeft(
                  height: 60,
                  width: 330,
                  icon: FontAwesomeIcons.google,
                  text: 'logar com o google',
                  textStyle: kButtonWhite,
                  background: kMainColor,
                  function: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Row(children: const [
                    Expanded(
                      child: Divider(
                        color: kLightBlue2,
                        thickness: 3,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        "OU",
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 12,
                          color: kLightBlue2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: kLightBlue2,
                        thickness: 3,
                      ),
                    ),
                  ]),
                ),
                TextButton(
                  child: const Text(
                    "Entrar como convidado",
                    style: kHeadline6,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/myInitialSetupScreen');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
