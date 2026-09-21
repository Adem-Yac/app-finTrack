class CurrencyRateModel {
  const CurrencyRateModel({
    required this.base,
    required this.quote,
    required this.rate,
    this.date,
  });

  final String base;
  final String quote;
  final double rate;
  final String? date;

  factory CurrencyRateModel.fromJson(Map<String, dynamic> json) {
    return CurrencyRateModel(
      base: (json['base'] as String? ?? '').toUpperCase(),
      quote: (json['quote'] as String? ?? '').toUpperCase(),
      rate: (json['rate'] as num).toDouble(),
      date: json['date'] as String?,
    );
  }
}

class ConversionResult {
  const ConversionResult({
    required this.from,
    required this.to,
    required this.amount,
    required this.rate,
    required this.result,
    this.date,
    this.provider,
  });

  final String from;
  final String to;
  final double amount;
  final double rate;
  final double result;
  final String? date;
  final String? provider;

  factory ConversionResult.fromJson(Map<String, dynamic> json) {
    return ConversionResult(
      from: json['from'] as String,
      to: json['to'] as String,
      amount: (json['amount'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
      result: (json['result'] as num).toDouble(),
      date: json['date'] as String?,
      provider: json['provider'] as String?,
    );
  }
}
