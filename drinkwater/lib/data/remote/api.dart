import 'package:dio/dio.dart';

class Api {
  Future<String> signUp(email, password) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['Content-Type'] = ' application/json';

    response = await dio.post(
        "https://parseapi.back4app.com/parse/functions/sign-up",
        data: {"email": email, "password": password});

    if (response.statusCode == 200) {
      return response.data['result'];
    } else {
      return 'Erro ao cadastrar usuário';
    }
  }

  Future<dynamic> login(email, password) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['Content-Type'] = ' application/json';

    response = await dio.post(
        "https://parseapi.back4app.com/parse/functions/login",
        data: {"email": email, "password": password});

    if (response.statusCode == 200) {
      return response.data['result'];
    } else {
      return response.statusMessage;
    }
  }

  Future<dynamic> logout(String? userToken) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    response = await dio.post(
      "https://parseapi.back4app.com/parse/functions/logout",
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      return response;
    }
  }

  Future<dynamic> createUserData(
      String? userToken,
      int waterIntakeGoal,
      DateTime wakeUpTime,
      DateTime sleepTime,
      int userWeight,
      List<DateTime> notificationTimeList) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    List<String> test = [];

    notificationTimeList.forEach((v) => test.add(v.toIso8601String()));

    print("---------------------");
    print("--- Ola userToken $userToken");
    print("--- Ola waterIntakeGoal $waterIntakeGoal");
    print("--- Ola wakeUpTime $wakeUpTime");
    print("--- Ola sleepTime $sleepTime");
    print("--- Ola userWeight $userWeight");
    print("--- Ola notification $test");
    print("---------------------");

    try {
      response = await dio.post(
          "https://parseapi.back4app.com/parse/functions/create-userData",
          data: {
            "waterIntakeGoal": waterIntakeGoal,
            "wakeUpTime": wakeUpTime.toIso8601String(),
            "sleepTime": sleepTime.toIso8601String(),
            "userWeight": userWeight,
            "notificationTimeList": test
          });
      print("MINHA RESPONSE ${response}");
    } catch (e) {
      print("meu erro e $e");
      return e;
    }

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return response;
    }
  }
}
