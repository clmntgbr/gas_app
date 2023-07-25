import 'dart:convert';
import 'package:gas_app/model/address.dart';
import 'package:gas_app/model/gas_service.dart';
import 'package:gas_app/model/google_place.dart';
import 'package:gas_app/model/last_gas_price.dart';

GasStation getGasStationFromJson(String str) => GasStation.fromJson(json.decode(str));

class GasStation {
  String id;
  String uuid;
  String pop;
  String imagePath;
  String? name;
  String? company;
  String? status;
  String? closedAt;

  Address address;
  GooglePlace googlePlace;
  List<dynamic> gasServices;
  List<dynamic> lastGasPrices;

  bool hasLowPrices;

  GasStation({
    required this.id,
    required this.uuid,
    required this.pop,
    required this.name,
    required this.imagePath,
    required this.company,
    required this.status,
    required this.closedAt,
    required this.address,
    required this.googlePlace,
    required this.gasServices,
    required this.lastGasPrices,
    required this.hasLowPrices,
  });

  factory GasStation.fromJson(dynamic json) {
    return GasStation(
      id: json['gasStationId'],
      uuid: json['uuid'],
      pop: json['pop'],
      name: json['name'],
      imagePath: json['imagePath'],
      company: json['company'],
      status: json['status'],
      closedAt: json['closedAt'],
      address: Address.fromJson(
        json['address'],
      ),
      googlePlace: GooglePlace.fromJson(
        json['googlePlace'],
      ),
      gasServices: json['gasServices']
          .map(
            (tagJson) => GasService.fromJson(tagJson),
          )
          .toList(),
      lastGasPrices: json['lastPrices']
          .map(
            (tagJson) => LastGasPrice.fromJson(tagJson),
          )
          .toList(),
      hasLowPrices: json['hasLowPrices'],
    );
  }

  @override
  String toString() {
    return '{id: $id, lastGasPrices: ${lastGasPrices.toString()}}';
  }
}