import 'dart:convert';
import 'gas_type.dart';

GetGasTypes gasTypesFromJson(String str, int statusCode) => GetGasTypes.fromJson(json.decode(str), statusCode);

class GetGasTypes {
  String? context;
  String? contextId;
  String? contextType;
  List<dynamic> gasTypes;
  int statusCode;
  int totalItems;

  @override
  String toString() {
    return '{context: $context, contextId: $contextId, contextType: $contextType}';
  }

  GetGasTypes({
    this.context,
    this.contextId,
    this.contextType,
    required this.gasTypes,
    required this.totalItems,
    required this.statusCode,
  });

  factory GetGasTypes.fromJson(Map<String, dynamic> json, int statusCode) {
    return GetGasTypes(
      context: json['@context'],
      contextId: json['@id'],
      contextType: json['@type'],
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
