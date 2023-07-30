class GasPrice {
  int gasPriceId;
  int gasPriceDatetimestamp;
  int gasPriceValue;
  int gasTypeId;
  String gasTypeLabel;
  String currency;
  String gasPriceDifference;
  bool isLowPrice;

  GasPrice({
    required this.gasPriceId,
    required this.gasPriceDatetimestamp,
    required this.gasPriceValue,
    required this.gasTypeId,
    required this.gasTypeLabel,
    required this.currency,
    required this.gasPriceDifference,
    required this.isLowPrice,
  });

  factory GasPrice.fromJson(dynamic json) {
    return GasPrice(
      gasPriceId: json['gasPriceId'],
      gasPriceDatetimestamp: json['gasPriceDatetimestamp'],
      gasPriceValue: json['gasPriceValue'],
      gasTypeId: json['gasTypeId'],
      gasTypeLabel: json['gasTypeLabel'],
      currency: json['currency'],
      gasPriceDifference: json['gasPriceDifference'] ?? 'N/A',
      isLowPrice: json['isLowPrice'] ?? false,
    );
  }

  @override
  String toString() {
    return '{gasPriceId: $gasPriceId, isLowPrice: $isLowPrice}';
  }
}
