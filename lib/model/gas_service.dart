class GasService {
  String uuid;
  String name;

  GasService({
    required this.uuid,
    required this.name,
  });

  factory GasService.fromJson(dynamic json) {
    return GasService(
      uuid: json['uuid'],
      name: json['name'],
    );
  }

  @override
  String toString() {
    return '{uuid: $uuid, name: $name}';
  }
}
