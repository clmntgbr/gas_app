import '../model/get_gas_stations_map.dart';
import '../constants.dart';
import '../model/get_gas_types.dart';
import 'api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class GasTypeService {
  final apiService = ApiService();

  Future<GetGasTypes> getGasTypes() async {
    String url = '${Constants.baseApiUrl}${Constants.gasTypesEndpoint}';

    debugPrint('GET $url');

    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/ld+json',
        'Accept': 'application/ld+json',
      },
    );

    debugPrint('GET $url status code is ${response.statusCode}');

    GetGasTypes model = gasTypesFromJson(
      response.body.toString(),
      response.statusCode,
    );

    model.statusCode = response.statusCode;
    return model;
  }
}