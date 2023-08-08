import 'package:flutter/material.dart';

class Constants {
  static String baseUrl = 'https://gas.traefik.me';
  static String baseApiUrl = 'https://gas.traefik.me/api';

  static String gasStationsMapEndpoint = '/gas_stations/map';
  static String addressEndpoint = '/address';
  static String gasTypesEndpoint = '/gas_types';
  static String authenticateEndpoint = '/authenticate';
  static String usersEndpoint = '/users';

  static String gasTypeDefault = '719190d5-dd67-4f06-b308-39d3326ab749';

  static Color kPrimaryColor = const Color(0xFF27AE60);
  static BoxShadow kBoxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 2,
    blurRadius: 8,
    offset: const Offset(0, 0),
  );

  static String expiredApiToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJPbmxpbmUgSldUIEJ1aWxkZXIiLCJpYXQiOjE2NzI1MzEyMDAsImV4cCI6MTY3MjUzMTIwMCwiYXVkIjoiYWxlcnQuaW8iLCJzdWIiOiJhZG1pbkBhbGVydC5pbyJ9.eF_6bb7n2C9VOjo7FnGmOVk3Onq8_V4VREM4xpSz8Ug';
}
