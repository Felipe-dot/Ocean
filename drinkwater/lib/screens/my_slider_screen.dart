import 'package:drinkwater/components/buttons/my_cta_with_icon_right.dart';
import 'package:drinkwater/components/my_info_page.dart';
import 'package:drinkwater/components/my_number_picker.dart';
import 'package:drinkwater/components/my_slider_progress_indicator.dart';
import 'package:drinkwater/components/my_time_picker.dart';
import 'package:drinkwater/constant.dart';
import 'package:flutter/material.dart';

class MySliderScreen extends StatefulWidget {
  const MySliderScreen({Key? key}) : super(key: key);

  @override
  _MySliderScreenState createState() => _MySliderScreenState();
}

class _MySliderScreenState extends State<MySliderScreen> {
  int currentPage = 0;
  List<Widget> myPages = [
    const MyInfoPage(
      titulo: "Qual seu peso?",
      desc:
          "Vamos calcular a sua meta diaria de ingestão de agua de acordo com seu peso",
      imagem: "assets/images/balanca.png",
      widget: MyNumberPicker(),
    ),
    const MyInfoPage(
      titulo: "Qual sua hora de acordar?",
      desc:
          "para que não enviemos seus lembretes em uma hora inoportuna é importante saber sua hora de acordar",
      imagem: "assets/images/despertador.png",
      widget: MyTimePicker(
        isSleepTime: false,
      ),
    ),
    const MyInfoPage(
      titulo: "Qual sua hora de dormir?",
      desc:
          "para que não enviemos seus lembretes em uma hora inoportuna é importante saber sua hora de dormir",
      imagem: "assets/images/dormindo.png",
      widget: MyTimePicker(
        isSleepTime: true,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: kLightBlue4,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage("assets/images/logo.png"),
                  height: 80,
                  width: 140,
                ),
                SizedBox(
                  height: 420,
                  child: myPages[currentPage],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_left,
                            size: 40,
                            color: kMainColor,
                          ),
                          Text(
                            'Voltar',
                            style: kButton.copyWith(color: kMainColor),
                          ),
                        ],
                      ),
                      onTap: () {
                        if (currentPage > 0) {
                          setState(() {
                            currentPage--;
                          });
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    MyCtaWithIconRight(
                      icon: Icons.arrow_right_alt,
                      text: 'Proximo',
                      background: kMainColor,
                      textStyle: kButton,
                      height: 60,
                      width: 170,
                      function: () {
                        if (currentPage < myPages.length - 1) {
                          setState(() {
                            currentPage++;
                          });
                        } else {
                          Navigator.pushNamed(context, '/myIntroConclusion');
                        }
                      },
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: MySliderProgressIndicator(current: currentPage),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
