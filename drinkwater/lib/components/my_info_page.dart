import 'package:flutter/material.dart';
import '../components/my_number_picker.dart';

import '../constant.dart';

class MyInfoPage extends StatelessWidget {
  final String titulo;
  final String desc;
  final String imagem;
  final String link;
  final Widget widget;
  const MyInfoPage({Key key, this.titulo, this.desc, this.imagem, this.link, this.widget}) : super(key: key);

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
                Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 34,
                    fontWeight: FontWeight.normal,
                    color: kDark2,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: kGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                Row(
                  children: [
                    Image(
                      image: AssetImage(imagem),
                      width: 247,
                      height: 208,
                    ),
                    const MyNumberPicker(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Voltar",
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: kRedAccent,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/$link');
                      },
                      child: const Text(
                        "Proximo",
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