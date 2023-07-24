import 'dart:convert';
import '../constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class LoginService {
  Future<Map> login(String email, String password) async {
    String url = '${Constants.baseApiUrl}${Constants.authenticateEndpoint}';
    Map body = {'email': email, 'password': password};

    debugPrint('POST $url');
    debugPrint(body.toString());

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/ld+json',
        'Accept': 'application/json',
      },
      body: json.encode(body),
    );

    Map data = {'code': response.statusCode};
    final responseBody = json.decode(response.body);

    debugPrint('Get Status Code : ${response.statusCode}');

    if (response.statusCode == 200) {
      data['message'] = responseBody['token'];
      return data;
    }

    data['message'] = responseBody['message'] ?? 'Try again !';
    return data;
  }

  Future<Map> register(String email, String password) async {
    String url = '${Constants.baseApiUrl}${Constants.usersEndpoint}';
    Map body = {'email': email, 'plainPassword': password};

    debugPrint('POST $url');
    debugPrint(body.toString());

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/ld+json',
        'Accept': 'application/json',
      },
      body: json.encode(body),
    );

    Map data = {'code': response.statusCode};
    debugPrint('Get Status Code : ${response.statusCode}');

    if (response.statusCode == 201) {
      return login(email, password);
    }

    if (response.statusCode == 422) {
      data['message'] = 'There is already an account with this email.';
    }

    return data;
  }

  Future loginStorage(Map response) async {
    debugPrint(response.toString());
    if (response['code'] == 200) {
      await writeLoginStorageToken(response['message']);
    }
  }

  Future writeLoginStorageToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<String> getLoginStorageToken() async {
    debugPrint('GET Storage Token');
    return await storage.read(key: 'token') ?? Constants.expiredApiToken;
  }
}
