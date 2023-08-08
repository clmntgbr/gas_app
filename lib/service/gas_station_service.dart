import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../model/get_gas_stations_map.dart';

class GasStationService {
  Future<GetGasStationsMap> getGasStationsMap(double latitude, double longitude, double radius, String? gasType) async {
    String url =
        '${Constants.baseApiUrl}${Constants.gasStationsMapEndpoint}?latitude=$latitude&longitude=$longitude&radius=$radius&gasTypeUuid=$gasType';

    debugPrint('GET $url');

    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/ld+json',
        'Accept': 'application/ld+json',
      },
    );

    debugPrint('*** GET $url status code is ${response.statusCode}');

    GetGasStationsMap model = gasStationsMapFromJson(
      response.body.toString(),
      response.statusCode,
    );

    model.statusCode = response.statusCode;
    return model;
  }
}
