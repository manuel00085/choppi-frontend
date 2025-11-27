import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) =>
      storage.write(key: 'token', value: token);

  static Future<String?> readToken() =>
      storage.read(key: 'token');

  static Future<void> clearToken() =>
      storage.delete(key: 'token');
}
