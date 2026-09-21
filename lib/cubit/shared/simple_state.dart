import 'package:equatable/equatable.dart';
import 'package:fintrack/data/models/algeria_model.dart';
import 'package:fintrack/data/models/budget_model.dart';
import 'package:fintrack/data/models/category_model.dart';
import 'package:fintrack/data/models/currency_model.dart';
import 'package:fintrack/data/models/goal_model.dart';
import 'package:fintrack/data/models/statistics_model.dart';

sealed class SimpleLoadState<T> extends Equatable {
  const SimpleLoadState();
  @override
  List<Object?> get props => [];
}

final class SimpleLoading<T> extends SimpleLoadState<T> {
  const SimpleLoading();
}

final class SimpleLoaded<T> extends SimpleLoadState<T> {
  const SimpleLoaded(this.data);
  final T data;
  @override
  List<Object?> get props => [data];
}

final class SimpleFailure<T> extends SimpleLoadState<T> {
  const SimpleFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class StatsBundle {
  const StatsBundle({required this.monthly, required this.categories});

  final MonthlyStats monthly;
  final List<CategoryStat> categories;
}

class BudgetBundle {
  const BudgetBundle({
    this.budget,
    this.goals = const [],
    this.categories = const [],
  });

  final BudgetModel? budget;
  final List<GoalModel> goals;
  final List<CategoryModel> categories;
}

class CurrencyBundle {
  const CurrencyBundle({
    required this.rates,
    this.conversion,
    this.amount = 100,
    this.from = 'EUR',
    this.to = 'USD',
  });

  final List<CurrencyRateModel> rates;
  final ConversionResult? conversion;
  final double amount;
  final String from;
  final String to;
}

class AlgeriaBundle {
  const AlgeriaBundle({
    required this.rates,
    required this.history,
    this.currency = 'EUR',
    this.range = '30d',
  });

  final AlgeriaRates rates;
  final AlgeriaHistory history;
  final String currency;
  final String range;
}
