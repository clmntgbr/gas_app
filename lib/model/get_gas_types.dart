import 'dart:convert';

import 'gas_type.dart';

GetGasTypes gasTypesFromJson(String str, int statusCode) => GetGasTypes.fromJson(json.decode(str), statusCode);

class GetGasTypes {
  List<dynamic> gasTypes;
  int statusCode;
  int totalItems;

  @override
  String toString() {
    return '{totalItems: $totalItems, gasTypes: ${gasTypes.toString()}}';
  }

  GetGasTypes({
    required this.gasTypes,
    required this.totalItems,
    required this.statusCode,
  });

  factory GetGasTypes.fromJson(Map<String, dynamic> json, int statusCode) {
    return GetGasTypes(
      gasTypes: json['hydra:member']
          .map(
            (tagJson) => GasType.fromJson(tagJson),
          )
          .toList(),
      totalItems: json['hydra:totalItems'],
      statusCode: statusCode,
    );
  }
}
