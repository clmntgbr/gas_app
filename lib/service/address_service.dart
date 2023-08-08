import 'package:flutter/material.dart';
import 'package:gas_app/model/get_address_cities.dart';
import 'package:gas_app/model/get_address_departments.dart';
import 'package:gas_app/model/get_address_postal_codes.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class AddressService {
  Future<GetAddressCities> getAddressCities() async {
    String url = '${Constants.baseApiUrl}${Constants.addressEndpoint}/cities';

    debugPrint('GET $url');

    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/ld+json',
        'Accept': 'application/ld+json',
      },
    );

    debugPrint('GET $url status code is ${response.statusCode}');

    GetAddressCities model = getAddressCitiesFromJson(
      response.body.toString(),
      response.statusCode,
    );

    model.statusCode = response.statusCode;
    return model;
  }

  Future<GetAddressDepartments> getAddressDepartments() async {
    String url = '${Constants.baseApiUrl}${Constants.addressEndpoint}/departments';

    debugPrint('GET $url');

    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/ld+json',
        'Accept': 'application/ld+json',
      },
    );

    debugPrint('GET $url status code is ${response.statusCode}');

    GetAddressDepartments model = getAddressDepartmentsFromJson(
      response.body.toString(),
      response.statusCode,
    );

    model.statusCode = response.statusCode;
    return model;
  }

  Future<GetAddressPostalCodes> getAddressPostalCodes() async {
    String url = '${Constants.baseApiUrl}${Constants.addressEndpoint}/postal_codes';

    debugPrint('GET $url');

    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/ld+json',
        'Accept': 'application/ld+json',
      },
    );

    debugPrint('GET $url status code is ${response.statusCode}');

    GetAddressPostalCodes model = getAddressPostalCodesFromJson(
      response.body.toString(),
      response.statusCode,
    );

    model.statusCode = response.statusCode;
    return model;
  }
}
