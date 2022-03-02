import 'package:drinkwater/components/buttons/my_cta.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class MyInitialSetupScreen extends StatelessWidget {
  const MyInitialSetupScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Container(
            color: kLightBlue4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage("assets/images/logo.png"),
                  height: 89,
                  width: 145,
                ),
                const Text(
                  "Vamos começar!",
                  style: kHeadline4,
                ),
                const Image(
                  image: AssetImage("assets/images/imagem1.png"),
                  width: 240,
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "Para começarmos precisamos pegar alguns dados seus para que você aproveite da melhor forma o app.",
                    style: kHeadline6.copyWith(
                      color: kGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "CANCELAR",
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: kRedAccent,
                        ),
                      ),
                    ),
                    MyCta(
                      function: () {
                        Navigator.pushNamed(context, '/mySliderScreen');
                      },
                      text: "começar",
                      textStyle: kButton.copyWith(
                        color: kWhite,
                      ),
                      height: 60,
                      width: 180,
                      background: kMainColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
