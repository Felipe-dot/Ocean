import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserIdSecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _userIdKey = 'id';

  static Future setUserIdString(id) async =>
      await _storage.write(key: _userIdKey, value: id);

  static Future<String?> getUserId() async =>
      await _storage.read(key: _userIdKey);
}
