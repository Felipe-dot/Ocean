import 'package:flutter/material.dart';

class MyHomePageScreen extends StatefulWidget {
  const MyHomePageScreen({Key key}) : super(key: key);

  @override
  _MyHomePageScreenState createState() => _MyHomePageScreenState();
}

class _MyHomePageScreenState extends State<MyHomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.blue),
        child: Center(
          child: Text("Iniciando a home"),
        ),
      ),
    );
  }
}
