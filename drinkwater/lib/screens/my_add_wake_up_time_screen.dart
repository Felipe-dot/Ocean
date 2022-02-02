import 'package:drinkwater/components/my_info_page.dart';
import 'package:drinkwater/components/my_time_picker.dart';
import 'package:flutter/material.dart';


class MyAddWakeUpTimeScreen extends StatelessWidget {
  const MyAddWakeUpTimeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyInfoPage(
      titulo: "Qual sua hora de acordar?",
      desc: "para que não enviemos seus lembretes em uma hora inoportuna é importante saber sua hora de acordar",
      imagem: "assets/images/despertador.png",
      link: "myAddSleepTimeScreen",
      widget: MyTimePicker(),);
  }
}