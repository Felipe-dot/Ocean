import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:drinkwater/components/my_bottom_nav_bar.dart';
import 'package:drinkwater/models/status.dart';
import 'package:drinkwater/models/user.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../services/notification_service.dart';
import '../utils/my_utils.dart';

class MyHomePageScreen extends StatefulWidget {
  const MyHomePageScreen({Key? key}) : super(key: key);

  @override
  _MyHomePageScreenState createState() => _MyHomePageScreenState();
}

class _MyHomePageScreenState extends State<MyHomePageScreen> {
  int _currentIndex = 0;
  late Box<User> userBox;
  late Box<WaterStatus> waterStatusBox;

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    userBox = Hive.box('userBox');
    waterStatusBox = Hive.box('statusBox');
    // Iniciando o sistema de notificação do aplicativo

    isDayChanged(waterStatusBox);
  }

  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  final controllerWaterIntakeCustom = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var waterStatusData = waterStatusBox.getAt(waterStatusBox.length - 1);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: getGoalStatus(waterStatusBox) ? kMainColor : kWhite,
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getGoalStatus(waterStatusBox)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(45),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 140),
                                child: const Text(
                                  "ml",
                                  style: TextStyle(
                                    color: kGreenAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Text(
                                "${waterStatusData!.amountOfWaterDrank}",
                                style: const TextStyle(
                                  color: kGreenAccent,
                                  fontSize: 60,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 75),
                          height: 80,
                          decoration: const BoxDecoration(
                            color: kMainColor,
                            image: DecorationImage(
                              alignment: Alignment.bottomCenter,
                              scale: 0.5,
                              image: AssetImage(
                                'assets/images/meta_batida.png',
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const Text(
                          "Parabéns!",
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          "Suas metas de hoje foram cumpridas",
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 5.0,
                          percent: percentageCalc(waterStatusBox) / 100,
                          center: Text(
                            "${percentageCalc(waterStatusBox).toStringAsFixed(0)}%",
                            style: const TextStyle(
                              color: kMainColor,
                              fontSize: 25,
                            ),
                          ),
                          progressColor: kDark1,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 140),
                              child: const Text(
                                "ml",
                                style: TextStyle(
                                  color: kMainColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Text(
                              "${waterStatusData!.amountOfWaterDrank}",
                              style: const TextStyle(
                                color: kMainColor,
                                fontSize: 60,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              "faltando: ${howMuchIsMissing(waterStatusBox)}",
                              style: const TextStyle(
                                color: kLightBlue2,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
              getGoalStatus(waterStatusBox)
                  ? Container()
                  : Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        color: kWhite,
                        image: DecorationImage(
                          alignment: Alignment.bottomCenter,
                          scale: 0.5,
                          image: AssetImage(
                            'assets/images/wave.png',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: kLightBlue4,
          onPressed: () => {
                showModalBottomSheet(
                  backgroundColor: kLightBlue3,
                  useSafeArea: true,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Tab(
                                      icon: Image.asset(
                                        'assets/images/copo.png',
                                        height: 23,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '200ml',
                                      style: const TextStyle(
                                        color: kMainColor,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Marker-Felt',
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  updateAmountOfWaterDrank(
                                      waterStatusBox, 200, waterStatusData);
                                  setState(() {});
                                  updateWaterStatusOnParseServer(
                                      waterStatusData);
                                  howMuchIsMissing(waterStatusBox);
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Tab(
                                      icon: Image.asset(
                                        'assets/images/garrafa.png',
                                        height: 25,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '350ml',
                                      style: const TextStyle(
                                        color: kMainColor,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Marker-Felt',
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  updateAmountOfWaterDrank(
                                      waterStatusBox, 350, waterStatusData);

                                  setState(() {});
                                  updateWaterStatusOnParseServer(
                                      waterStatusData);

                                  howMuchIsMissing(waterStatusBox);
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Tab(
                                      icon: Image.asset(
                                        'assets/images/jarra.png',
                                        height: 25,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '400ml',
                                      style: const TextStyle(
                                        color: kMainColor,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Marker-Felt',
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  updateAmountOfWaterDrank(
                                      waterStatusBox, 400, waterStatusData);
                                  setState(() {});
                                  updateWaterStatusOnParseServer(
                                      waterStatusData);
                                  howMuchIsMissing(waterStatusBox);
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 40),
                                    child: Row(
                                      children: [
                                        Tab(
                                          icon: Image.asset(
                                            'assets/images/gota.png',
                                            height: 25,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Personalizado',
                                          style: const TextStyle(
                                            color: kMainColor,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Marker-Felt',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () => showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          title: Text(
                                              'Digite a quantidade de água consumida'),
                                          content: SingleChildScrollView(
                                            child: Container(
                                              height: 100,
                                              width: 100,
                                              child: TextField(
                                                controller:
                                                    controllerWaterIntakeCustom,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: kMainColor)),
                                                  labelText: 'Ml',
                                                ),
                                              ),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Voltar'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Confirmar'),
                                              onPressed: () {
                                                int waterIntake = int.parse(
                                                    controllerWaterIntakeCustom
                                                        .value.text);

                                                updateAmountOfWaterDrank(
                                                    waterStatusBox,
                                                    waterIntake,
                                                    waterStatusData);

                                                setState(() {});
                                                updateWaterStatusOnParseServer(
                                                    waterStatusData);

                                                howMuchIsMissing(
                                                    waterStatusBox);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      })),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
              },
          child: Icon(
            Icons.add,
            color: kMainColor,
            size: 40,
          )),
      bottomNavigationBar: MyBottomNavBar(
        iconSize: 30,
        selectedIndex: _currentIndex,
        backgroundColor: kMainColor,
        showElevation: false,
        itemCornerRadius: 20,
        curve: Curves.easeIn,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          switch (_currentIndex) {
            case 0:
              {
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
                Navigator.pushNamed(context, '/mySettingsScreen',
                    arguments: _currentIndex);
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
