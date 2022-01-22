import 'package:flutter/material.dart';
import '../components/my_info_page.dart';
import 'package:drinkwater/components/my_number_picker.dart';

class MyAddWeightScreen extends StatelessWidget {
  const MyAddWeightScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyInfoPage(
      titulo: "Qual seu peso?",
      desc: "Vamos calcular a sua meta diaria de ingestão de agua de acordo com seu peso",
      imagem: "assets/images/balanca.png",
      link: "myAddWakeUpTimeScreen",
      widget: MyNumberPicker(),);
  }
}