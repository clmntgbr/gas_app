class GasType {
  String uuid;
  String name;
  String imagePath;

  GasType({
    required this.uuid,
    required this.name,
    required this.imagePath,
  });

  factory GasType.fromJson(dynamic json) {
    return GasType(
      uuid: json['uuid'],
      name: json['name'],
      imagePath: json['imagePath'],
    );
  }

  @override
  String toString() {
    return '{uuid: $uuid, name: $name}';
  }
}
