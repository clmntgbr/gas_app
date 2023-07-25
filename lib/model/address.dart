class Address {
  String uuid;
  String? vicinity;
  String? street;
  String? number;
  String? city;
  String? region;
  String? postalCode;
  String? country;
  String longitude;
  String latitude;

  Address({
    required this.uuid,
    required this.vicinity,
    required this.street,
    required this.number,
    required this.city,
    required this.region,
    required this.postalCode,
    required this.country,
    required this.longitude,
    required this.latitude,
  });

  factory Address.fromJson(dynamic json) {
    return Address(
      uuid: json['uuid'],
      vicinity: json['vicinity'],
      street: json['street'],
      number: json['number'],
      city: json['city'],
      region: json['region'],
      postalCode: json['postalCode'],
      country: json['country'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }

  @override
  String toString() {
    return '{uuid: $uuid}';
  }
}
