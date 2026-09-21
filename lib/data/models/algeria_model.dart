class QuoteRate {
  const QuoteRate({
    required this.rate,
    this.buy,
    this.sell,
    this.updatedAt,
    this.source,
  });

  final double rate;
  final double? buy;
  final double? sell;
  final String? updatedAt;
  final String? source;

  factory QuoteRate.fromJson(Map<String, dynamic> json) {
    return QuoteRate(
      rate: (json['rate'] as num).toDouble(),
      buy: (json['buy'] as num?)?.toDouble(),
      sell: (json['sell'] as num?)?.toDouble(),
      updatedAt: json['updated_at'] as String?,
      source: json['source'] as String?,
    );
  }
}

class AlgeriaPair {
  const AlgeriaPair({
    required this.base,
    required this.quote,
    required this.official,
    required this.parallel,
    required this.difference,
    required this.premiumPercent,
  });

  final String base;
  final String quote;
  final QuoteRate official;
  final QuoteRate parallel;
  final double difference;
  final double premiumPercent;

  factory AlgeriaPair.fromJson(Map<String, dynamic> json) {
    return AlgeriaPair(
      base: json['base'] as String,
      quote: json['quote'] as String,
      official: QuoteRate.fromJson(json['official'] as Map<String, dynamic>),
      parallel: QuoteRate.fromJson(json['parallel'] as Map<String, dynamic>),
      difference: (json['difference'] as num).toDouble(),
      premiumPercent: (json['premium_percent'] as num).toDouble(),
    );
  }
}

class AlgeriaRates {
  const AlgeriaRates({
    required this.provider,
    required this.pairs,
    this.note,
    this.updatedAt,
  });

  final String provider;
  final String? note;
  final String? updatedAt;
  final List<AlgeriaPair> pairs;

  AlgeriaPair pair(String base) =>
      pairs.firstWhere((item) => item.base == base, orElse: () => pairs.first);

  factory AlgeriaRates.fromJson(Map<String, dynamic> json) {
    return AlgeriaRates(
      provider: json['provider'] as String? ?? 'demo',
      note: json['note'] as String?,
      updatedAt: json['updated_at'] as String?,
      pairs: (json['pairs'] as List<dynamic>? ?? [])
          .map((item) => AlgeriaPair.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HistoryPoint {
  const HistoryPoint({required this.date, required this.rate});

  final DateTime date;
  final double rate;

  factory HistoryPoint.fromJson(Map<String, dynamic> json) {
    return HistoryPoint(
      date: DateTime.parse(json['date'] as String),
      rate: (json['rate'] as num).toDouble(),
    );
  }
}

class AlgeriaHistory {
  const AlgeriaHistory({
    required this.pair,
    required this.range,
    required this.official,
    required this.parallel,
  });

  final String pair;
  final String range;
  final List<HistoryPoint> official;
  final List<HistoryPoint> parallel;

  factory AlgeriaHistory.fromJson(Map<String, dynamic> json) {
    return AlgeriaHistory(
      pair: json['pair'] as String,
      range: json['range'] as String,
      official: (json['official'] as List<dynamic>? ?? [])
          .map((item) => HistoryPoint.fromJson(item as Map<String, dynamic>))
          .toList(),
      parallel: (json['parallel'] as List<dynamic>? ?? [])
          .map((item) => HistoryPoint.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
