import 'package:fintrack/data/local/local_cache.dart';
import 'package:fintrack/data/models/budget_model.dart';
import 'package:fintrack/data/models/category_model.dart';
import 'package:fintrack/data/models/goal_model.dart';
import 'package:fintrack/data/models/notification_model.dart';
import 'package:fintrack/data/models/statistics_model.dart';
import 'package:fintrack/data/models/transaction_model.dart';
import 'package:fintrack/data/services/api_client.dart';

class FinanceRepository {
  FinanceRepository(this._api, this._cache);

  final ApiClient _api;
  final LocalCache _cache;

  Future<List<CategoryModel>> categories() async {
    final response = await _api.get<Map<String, dynamic>>('/categories');
    final items = (response.data!['data'] as List<dynamic>)
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
    await _cache.putJson('categories', {'items': response.data!['data']});
    return items;
  }

  Future<List<TransactionModel>> transactions({
    String? type,
    String? month,
    String? search,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      '/transactions',
      query: {
        'type': ?type,
        'month': ?month,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    final data = response.data!['data'] as List<dynamic>;
    await _cache.putJson('transactions', {'items': data});
    return data
        .map((item) => TransactionModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<TransactionModel> transaction(int id) async {
    final response = await _api.get<Map<String, dynamic>>('/transactions/$id');
    return TransactionModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  Future<TransactionModel> createTransaction(
    Map<String, dynamic> payload,
  ) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/transactions',
      data: payload,
    );
    return TransactionModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  Future<void> deleteTransaction(int id) => _api.delete('/transactions/$id');

  Future<MonthlyStats> monthlyStats(String month) async {
    final response = await _api.get<Map<String, dynamic>>(
      '/statistics/monthly',
      query: {'month': month},
    );
    return MonthlyStats.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  Future<List<CategoryStat>> categoryStats(String month) async {
    final response = await _api.get<Map<String, dynamic>>(
      '/statistics/categories',
      query: {'month': month},
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return (data['categories'] as List<dynamic>)
        .map((item) => CategoryStat.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<BudgetModel?> budget(int year, int month) async {
    final response = await _api.get<Map<String, dynamic>>(
      '/budgets',
      query: {'year': year, 'month': month},
    );
    final data = response.data!['data'];
    if (data == null) {
      return null;
    }
    return BudgetModel.fromJson(data as Map<String, dynamic>);
  }

  Future<BudgetModel> saveBudget(Map<String, dynamic> payload) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/budgets',
      data: payload,
    );
    return BudgetModel.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  Future<List<GoalModel>> goals() async {
    final response = await _api.get<Map<String, dynamic>>('/goals');
    return (response.data!['data'] as List<dynamic>)
        .map((item) => GoalModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<GoalModel> goal(int id) async {
    final response = await _api.get<Map<String, dynamic>>('/goals/$id');
    return GoalModel.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  Future<GoalModel> createGoal(Map<String, dynamic> payload) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/goals',
      data: payload,
    );
    return GoalModel.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  Future<GoalModel> deposit(int id, double amount, {String? note}) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/goals/$id/deposit',
      data: {'amount': amount, 'note': note},
    );
    return GoalModel.fromJson(
      (response.data!['data'] as Map<String, dynamic>)['goal']
          as Map<String, dynamic>,
    );
  }

  Future<NotificationInbox> notifications() async {
    final response = await _api.get<Map<String, dynamic>>('/notifications');
    return NotificationInbox.fromJson(response.data!);
  }

  Future<NotificationInbox> markNotificationRead(int id) async {
    await _api.post('/notifications/$id/read');
    return notifications();
  }

  Future<NotificationInbox> markAllNotificationsRead() async {
    final response = await _api.post<Map<String, dynamic>>(
      '/notifications/read-all',
    );
    return NotificationInbox.fromJson(response.data!);
  }
}
