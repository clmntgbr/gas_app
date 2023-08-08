import 'dart:convert';
import 'package:gas_app/model/address_filter.dart';

GetAddressPostalCodes getAddressPostalCodesFromJson(String str, int statusCode) => GetAddressPostalCodes.fromJson(json.decode(str), statusCode);

class GetAddressPostalCodes {
  List<dynamic> postalCodes;
  int statusCode;
  int totalItems;

  @override
  String toString() {
    return '{totalItems: $totalItems, cities: ${postalCodes.toString()}}';
  }

  GetAddressPostalCodes({
    required this.postalCodes,
    required this.totalItems,
    required this.statusCode,
  });

  factory GetAddressPostalCodes.fromJson(Map<String, dynamic> json, int statusCode) {
    return GetAddressPostalCodes(
      postalCodes: json['hydra:member']
          .map(
            (tagJson) => AddressFilter.fromJson(tagJson),
          )
          .toList(),
      totalItems: json['hydra:totalItems'],
      statusCode: statusCode,
    );
  }
}
