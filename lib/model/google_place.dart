import 'dart:convert';

GooglePlace getGasStationFromJson(String str) => GooglePlace.fromJson(json.decode(str));

class GooglePlace {
  String uuid;
  String? googleId;
  String? url;
  String? website;

  GooglePlace({
    required this.uuid,
    required this.googleId,
    required this.url,
    required this.website,
  });

  factory GooglePlace.fromJson(dynamic json) {
    return GooglePlace(
      uuid: json['uuid'],
      googleId: json['googleId'],
      url: json['url'],
      website: json['website'],
    );
  }

  @override
  String toString() {
    return '{uuid: $uuid}';
  }
}
