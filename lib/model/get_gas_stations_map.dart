import 'dart:convert';

import 'gas_station.dart';

GetGasStationsMap gasStationsMapFromJson(String str, int statusCode) => GetGasStationsMap.fromJson(json.decode(str), statusCode);

class GetGasStationsMap {
  String? context;
  String? contextId;
  String? contextType;
  List<dynamic> gasStations;
  int statusCode;
  int totalItems;

  @override
  String toString() {
    return '{context: $context, contextId: $contextId, contextType: $contextType, gasStations: ${gasStations.toString()}}';
  }

  GetGasStationsMap({
    this.context,
    this.contextId,
    this.contextType,
    required this.gasStations,
    required this.totalItems,
    required this.statusCode,
  });

  factory GetGasStationsMap.fromJson(Map<String, dynamic> json, int statusCode) {
    return GetGasStationsMap(
      context: json['@context'],
      contextId: json['@id'],
      contextType: json['@type'],
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
