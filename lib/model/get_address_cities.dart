import 'dart:convert';
import 'package:gas_app/model/address_filter.dart';

GetAddressCities getAddressCitiesFromJson(String str, int statusCode) => GetAddressCities.fromJson(json.decode(str), statusCode);

class GetAddressCities {
  List<dynamic> cities;
  int statusCode;
  int totalItems;

  @override
  String toString() {
    return '{totalItems: $totalItems, cities: ${cities.toString()}}';
  }

  GetAddressCities({
    required this.cities,
    required this.totalItems,
    required this.statusCode,
  });

  factory GetAddressCities.fromJson(Map<String, dynamic> json, int statusCode) {
    return GetAddressCities(
      cities: json['hydra:member']
          .map(
            (tagJson) => AddressFilter.fromJson(tagJson),
          )
          .toList(),
      totalItems: json['hydra:totalItems'],
      statusCode: statusCode,
    );
  }
}
