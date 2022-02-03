import 'package:drinkwater/components/buttons/my_cta_with_icon_right.dart';
import 'package:drinkwater/constant.dart';
import 'package:flutter/material.dart';

class MyIntroConclusionScreen extends StatelessWidget {
  const MyIntroConclusionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 30, bottom: 60),
          color: kMainColor,
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Image(
                  image: AssetImage('assets/images/logoSplashScreen.png'),
                  height: 89,
                  width: 145,
                ),
                Text(
                  'Pronto! já calculamos tudo',
                  style: kHeadline5.copyWith(color: kWhite),
                ),
                const Image(
                  image: AssetImage('assets/images/metaCalculada.png'),
                  height: 112,
                  width: 99,
                ),
                Text(
                  'Sua meta de ingestão de água diaria é',
                  style: kHeadline6.copyWith(color: kLightBlue3),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '2000',
                      style: kHeadline1.copyWith(color: kWhite),
                    ),
                    Text('ml', style: kCaption.copyWith(color: kWhite)),
                  ],
                ),
                SizedBox(
                  height: 45,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'isso é equivalente a:',
                        style: kSubtitle1.copyWith(color: kLightBlue2),
                      ),
                      SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '10 copos de 200ml',
                              style: kHeadline6.copyWith(color: kLightBlue3),
                            ),
                            const Image(
                              image: AssetImage('assets/images/copoWhite.png'),
                              height: 20,
                              width: 18,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: MyCtaWithIconRight(
                    background: kWhite,
                    textStyle: kButton.copyWith(color: kMainColor),
                    function: () {},
                    height: 70,
                    width: 280,
                    icon: Icons.arrow_right_alt_outlined,
                    text: 'Continuar',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
