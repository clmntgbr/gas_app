class GasStationBrand {
  String uuid;
  String name;
  String imagePath;
  String imageLowPath;

  GasStationBrand({
    required this.uuid,
    required this.name,
    required this.imagePath,
    required this.imageLowPath,
  });

  factory GasStationBrand.fromJson(dynamic json) {
    return GasStationBrand(
      uuid: json['uuid'],
      name: json['name'],
      imagePath: json['imagePath'],
      imageLowPath: json['imageLowPath'] ?? json['imagePath'],
    );
  }

  @override
  String toString() {
    return '{uuid: $uuid, name: $name}';
  }
}
