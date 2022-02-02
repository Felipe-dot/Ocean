import 'package:drinkwater/components/my_info_page.dart';
import 'package:drinkwater/components/my_time_picker.dart';
import 'package:flutter/material.dart';


class MyAddSleepTimeScreen extends StatelessWidget {
  const MyAddSleepTimeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyInfoPage(
      titulo: "Qual sua hora de dormir?",
      desc: "para que não enviemos seus lembretes em uma hora inoportuna é importante saber sua hora de dormir",
      imagem: "assets/images/dormindo.png",
      link: "myIntroConclusion",
      widget: MyTimePicker(),);
  }
}