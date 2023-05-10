import 'package:flutter/material.dart';

import '../constant.dart';

class MyInfoPage extends StatelessWidget {
  final String titulo;
  final String desc;
  final String imagem;
  final Widget widget;
  const MyInfoPage(
      {Key? key,
      required this.titulo,
      required this.desc,
      required this.imagem,
      required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image(
                image: AssetImage(imagem),
                width: 120,
                height: 120,
              ),
              widget,
            ],
          ),
        ),
      ],
    );
  }
}
