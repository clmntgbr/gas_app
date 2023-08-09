import 'dart:convert';
import 'address_filter.dart';

GetAddressDepartments getAddressDepartmentsFromJson(String str, int statusCode) => GetAddressDepartments.fromJson(json.decode(str), statusCode);

class GetAddressDepartments {
  List<dynamic> departments;
  int statusCode;
  int totalItems;

  @override
  String toString() {
    return '{totalItems: $totalItems, cities: ${departments.toString()}}';
  }

  GetAddressDepartments({
    required this.departments,
    required this.totalItems,
    required this.statusCode,
  });

  factory GetAddressDepartments.fromJson(Map<String, dynamic> json, int statusCode) {
    return GetAddressDepartments(
      departments: json['hydra:member']
          .map(
            (tagJson) => AddressFilter.fromJson(tagJson),
          )
          .toList(),
      totalItems: json['hydra:totalItems'],
      statusCode: statusCode,
    );
  }
}
