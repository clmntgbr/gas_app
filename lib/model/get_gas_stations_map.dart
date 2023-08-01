import 'dart:convert';

import 'gas_station.dart';

GetGasStationsMap gasStationsMapFromJson(String str, int statusCode) => GetGasStationsMap.fromJson(json.decode(str), statusCode);

class GetGasStationsMap {
  List<dynamic> gasStations;
  int statusCode;
  int totalItems;

  @override
  String toString() {
    return 'gasStations: ${gasStations.toString()}}';
  }

  GetGasStationsMap({
    required this.gasStations,
    required this.totalItems,
    required this.statusCode,
  });

  factory GetGasStationsMap.fromJson(Map<String, dynamic> json, int statusCode) {
    return GetGasStationsMap(
      gasStations: json['hydra:member']
          .map(
            (tagJson) => GasStation.fromJson(tagJson),
          )
          .toList(),
      totalItems: json['hydra:totalItems'],
      statusCode: statusCode,
    );
  }
}
