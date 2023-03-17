import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserTokenSecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _userTokenKey = 'token';

  static Future setUserToken(String token) async =>
      await _storage.write(key: _userTokenKey, value: token);

  static Future<String?> getUserToken() async =>
      await _storage.read(key: _userTokenKey);
}
