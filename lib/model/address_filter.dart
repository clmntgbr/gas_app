class AddressFilter {
  String? name;
  String? code;

  AddressFilter({
    required this.name,
    required this.code,
  });

  factory AddressFilter.fromJson(dynamic json) {
    return AddressFilter(
      name: json['name'],
      code: json['code'],
    );
  }

  @override
  String toString() {
    return '{name: $name, code: $code}';
  }
}
