import 'dart:math';

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

  Future<String?> getFavoriteGasType() async {
    return await storage.read(key: 'favoriteGasTypeUuid');
  }

  Future setFavoriteGasType(String value) async {
    await storage.write(key: 'favoriteGasTypeUuid', value: value);
  }

  double distanceBetweenTwoCoordinates(firstLatitude, firstLongitude, secondLatitude, secondLongitude) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((secondLatitude - firstLatitude) * p) / 2 +
        c(firstLatitude * p) * c(secondLatitude * p) * (1 - c((secondLongitude - firstLongitude) * p)) / 2;
    return (12742 * asin(sqrt(a))) * 1000;
  }
}
