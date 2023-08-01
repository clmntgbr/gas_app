import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'login_service.dart';

class ApiService {
  Future<bool> checkToken() async {
    debugPrint('is Token Valid ...');
    String token = await LoginService().getLoginStorageToken();
    debugPrint('Token is ${!Jwt.isExpired(token)} ...');
    return !Jwt.isExpired(token);
  }

  Future<String> getFavoriteGasType() async {
    return await storage.read(key: 'favoriteGasTypeUuid') ?? '';
  }

  Future setFavoriteGasType(String value) async {
    await storage.write(key: 'favoriteGasTypeUuid', value: value);
  }
}
