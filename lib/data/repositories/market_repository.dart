import 'package:fintrack/data/local/local_cache.dart';
import 'package:fintrack/data/models/algeria_model.dart';
import 'package:fintrack/data/models/currency_model.dart';
import 'package:fintrack/data/services/api_client.dart';

class MarketRepository {
  MarketRepository(this._api, this._cache);

  final ApiClient _api;
  final LocalCache _cache;

  Future<List<CurrencyRateModel>> currencies({String base = 'EUR'}) async {
    final response = await _api.get<Map<String, dynamic>>(
      '/currencies',
      query: {'base': base, 'quotes': 'USD,GBP,CHF,JPY'},
    );
    final rates = (response.data!['data']['rates'] as List<dynamic>? ?? [])
        .map((item) => CurrencyRateModel.fromJson(item as Map<String, dynamic>))
        .toList();
    await _cache.putJson('currencies', {
      'items': response.data!['data']['rates'],
    });
    return rates;
  }

  Future<ConversionResult> convert({
    required String from,
    required String to,
    required double amount,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      '/currencies/convert',
      query: {'from': from, 'to': to, 'amount': amount},
    );
    return ConversionResult.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  Future<List<HistoryPoint>> currencyHistory({
    required String from,
    required String to,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      '/currencies/history',
      query: {'from': from, 'to': to},
    );
    final points = (response.data!['data']['points'] as List<dynamic>? ?? [])
        .map((item) => HistoryPoint.fromJson(item as Map<String, dynamic>))
        .toList();
    return points;
  }

  Future<AlgeriaRates> algeriaRates() async {
    final response = await _api.get<Map<String, dynamic>>('/algeria/rates');
    final data = response.data!['data'] as Map<String, dynamic>;
    await _cache.putJson('algeria_rates', data);
    return AlgeriaRates.fromJson(data);
  }

  Future<AlgeriaHistory> algeriaHistory({
    String currency = 'EUR',
    String range = '30d',
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      '/algeria/history',
      query: {'currency': currency, 'range': range},
    );
    return AlgeriaHistory.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }
}
