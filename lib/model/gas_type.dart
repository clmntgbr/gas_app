class GasType {
  String uuid;
  String name;
  String reference;
  String imagePath;

  GasType({
    required this.uuid,
    required this.name,
    required this.reference,
    required this.imagePath,
  });

  factory GasType.fromJson(dynamic json) {
    return GasType(
      uuid: json['uuid'],
      name: json['name'],
      reference: json['reference'],
      imagePath: json['imagePath'],
    );
  }

  @override
  String toString() {
    return '{uuid: $uuid, name: $name}';
  }
}
