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
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.center,
              stops: [1, 1.2],
              colors: [kLightBlue4, kWhite],
            )),
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
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 34,
                    fontWeight: FontWeight.normal,
                    color: kDark2,
                  ),
                ),
                const Image(
                  image: AssetImage("assets/images/imagem1.png"),
                  width: 247,
                  height: 208,
                ),
                const Text(
                  "Para começarmos precisamos pegar alguns dados seus para que você aproveite da melhor forma o app.",
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: kGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {},
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
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        "COMEÇAR",
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: kWhite,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(180, 56),
                        primary: kMainColor,
                        elevation: 2,
                        padding: const EdgeInsets.all(10),
                        enableFeedback: true,
                      ),
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
