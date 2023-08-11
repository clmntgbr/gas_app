import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../model/address_filter.dart';
import '../model/get_gas_stations_map.dart';

class GasStationService {
  Future<GetGasStationsMap> getGasStationsMap(
    double latitude,
    double longitude,
    double radius,
    String? gasType,
    AddressFilter? selectedAddressCities,
    AddressFilter? selectedAddressDepartments,
  ) async {
    String url =
        '${Constants.baseApiUrl}${Constants.gasStationsMapEndpoint}?latitude=$latitude&longitude=$longitude&radius=$radius&gasTypeUuid=$gasType';

    url = getAddressCitiesFilter(selectedAddressCities, url);
    url = getAddressDepartmentsFilter(selectedAddressDepartments, url);

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

  String getAddressCitiesFilter(AddressFilter? selectedAddressCities, String url) {
    if (selectedAddressCities is AddressFilter) {
      return "$url&filter_city=${selectedAddressCities.code}";
    }
    return url;
  }

  String getAddressDepartmentsFilter(AddressFilter? selectedAddressDepartments, String url) {
    if (selectedAddressDepartments is AddressFilter) {
      return "$url&filter_department=${selectedAddressDepartments.code}";
    }
    return url;
  }
}
