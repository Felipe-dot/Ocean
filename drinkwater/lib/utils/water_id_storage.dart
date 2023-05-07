import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WaterIdSecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _waterIdKey = 'waterId';

  static Future setWaterIdString(id) async =>
      await _storage.write(key: _waterIdKey, value: id);

  static Future<String?> getWaterId() async =>
      await _storage.read(key: _waterIdKey);
}
