import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const jwtKey = "jwt_token";
  static const storage = FlutterSecureStorage();

  void saveJwt(String token) async {
    await storage.write(key: jwtKey, value: token);
  }

  Future<String?> getJwt() async {
    return await storage.read(key: jwtKey);
  }

  Future<void> deleteJwt() async {
    return await storage.delete(key: jwtKey);
  }
}