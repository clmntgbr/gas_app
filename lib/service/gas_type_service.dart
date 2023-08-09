import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../model/get_gas_types.dart';

class GasTypeService {
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

    debugPrint('*** GET $url status code is ${response.statusCode}');

    GetGasTypes model = gasTypesFromJson(
      response.body.toString(),
      response.statusCode,
    );

    model.statusCode = response.statusCode;
    return model;
  }
}
