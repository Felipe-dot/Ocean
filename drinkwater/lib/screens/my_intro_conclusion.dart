import 'package:drinkwater/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyIntroConclusion extends StatelessWidget {
  const MyIntroConclusion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 30, bottom: 60),
          width: MediaQuery.of(context).size.width,
          color: kMainColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Image(
                image: AssetImage('assets/images/logoSplashScreen.png'),
                height: 89,
                width: 145,
              ),
              const Text(
                'Pronto! já calculamos tudo',
                style: TextStyle(
                  color: kWhite,
                  fontSize: 21,
                ),
              ),
              const Image(
                image: AssetImage('assets/images/metaCalculada.png'),
                height: 112,
                width: 99,
              ),
              const Text(
                'Sua meta de ingestão de água diaria é',
                style: TextStyle(
                  color: kLightBlue3,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '2000',
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 86,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -0.15,
                    ),
                  ),
                  Text(
                    'ml',
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'isso é equivalente a:',
                      style: TextStyle(
                        color: kLightBlue2,
                        fontSize: 16,
                        letterSpacing: 0.015,
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            '10 copos de 200ml',
                            style: TextStyle(
                              color: kLightBlue4,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Image(
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
              Container(
                width: 280,
                height: 70,
                margin: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.symmetric(horizontal: 55),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      primary: kMainColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text(
                          'continuar',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Center(
                          child: Icon(
                            Icons.arrow_right_alt_outlined,
                            size: 35,
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
