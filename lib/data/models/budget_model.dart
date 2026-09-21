import 'package:fintrack/data/models/category_model.dart';

class BudgetCategoryModel {
  const BudgetCategoryModel({
    required this.id,
    required this.allocatedAmount,
    required this.spent,
    required this.remaining,
    required this.percent,
    this.category,
  });

  final int id;
  final double allocatedAmount;
  final double spent;
  final double remaining;
  final double percent;
  final CategoryModel? category;

  factory BudgetCategoryModel.fromJson(Map<String, dynamic> json) {
    return BudgetCategoryModel(
      id: json['id'] as int,
      allocatedAmount: (json['allocated_amount'] as num).toDouble(),
      spent: (json['spent'] as num).toDouble(),
      remaining: (json['remaining'] as num).toDouble(),
      percent: (json['percent'] as num).toDouble(),
      category: json['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }
}

class BudgetModel {
  const BudgetModel({
    required this.id,
    required this.year,
    required this.month,
    required this.totalAmount,
    required this.spent,
    required this.remaining,
    required this.percent,
    required this.daysLeft,
    required this.categories,
  });

  final int id;
  final int year;
  final int month;
  final double totalAmount;
  final double spent;
  final double remaining;
  final double percent;
  final int daysLeft;
  final List<BudgetCategoryModel> categories;

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as int,
      year: json['year'] as int,
      month: json['month'] as int,
      totalAmount: (json['total_amount'] as num).toDouble(),
      spent: (json['spent'] as num).toDouble(),
      remaining: (json['remaining'] as num).toDouble(),
      percent: (json['percent'] as num).toDouble(),
      daysLeft: (json['days_left'] as num?)?.toInt() ?? 0,
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                BudgetCategoryModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
