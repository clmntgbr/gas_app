import 'package:gas_app/model/get_gas_stations_map.dart';
import '../constants.dart';
import 'api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class GasStationService {
  final apiService = ApiService();

  Future<GetGasStationsMap> getGasStationsMap(double latitude, double longitude, double radius) async {
    String url = '${Constants.baseApiUrl}${Constants.gasStationsMapEndpoint}?latitude=$latitude&longitude=$longitude&radius=$radius';

    debugPrint('GET $url');

    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/ld+json',
        'Accept': 'application/ld+json',
      },
    );

    debugPrint('GET $url status code is ${response.statusCode}');

    GetGasStationsMap model = gasStationsMapFromJson(
      response.body.toString(),
      response.statusCode,
    );

    model.statusCode = response.statusCode;
    return model;
  }
}
