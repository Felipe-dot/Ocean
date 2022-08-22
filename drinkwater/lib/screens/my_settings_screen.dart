import 'package:drinkwater/components/my_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class MySettings extends StatefulWidget {
  const MySettings({Key? key}) : super(key: key);

  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  bool temp = false;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    int? _currentIndex = args as int?;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: kWhite,
          ),
          child: ListView(
            children: [
              ListTile(
                title: Text("Agenda de notificações"),
                trailing: Icon(Icons.notifications),
              ),
              SwitchListTile(
                title: Text("Lembrete adicional"),
                onChanged: (bool newValue) {
                  setState(() {
                    temp = newValue;
                    print(temp);
                  });
                },
                value: temp,
              ),
              ListTile(
                title: Text("Meta de ingestão"),
                trailing: Text("1500"),
              ),
              ListTile(
                title: Text("Peso"),
                trailing: Text("53 kg"),
              ),
              ListTile(
                title: Text("Hora de acordar"),
                trailing: Text("06:00"),
              ),
              ListTile(
                title: Text("Hora de dormir"),
                trailing: Text("22:30"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(
        iconSize: 30,
        selectedIndex: _currentIndex!,
        backgroundColor: kMainColor,
        showElevation: false,
        itemCornerRadius: 20,
        curve: Curves.easeIn,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          switch (_currentIndex) {
            case 0:
              {
                Navigator.pushNamed(context, '/myHomePage');
                break;
              }
            case 1:
              {
                Navigator.pushNamed(context, '/myStatusScreen',
                    arguments: _currentIndex);
                break;
              }
            case 2:
              {
                break;
              }
            default:
              {
                Navigator.pushNamed(context, '/myAvailableSoonScreen',
                    arguments: _currentIndex);
              }
          }
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(
              Icons.home,
              color: kWhite,
            ),
            activeColor: kLightBlue1,
            inactiveColor: kMainColor,
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.event_available,
              color: kWhite,
            ),
            activeColor: kLightBlue1,
            inactiveColor: kMainColor,
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.settings,
              color: kWhite,
            ),
            activeColor: kLightBlue1,
            inactiveColor: kMainColor,
          ),
        ],
      ),
    );
  }
}
