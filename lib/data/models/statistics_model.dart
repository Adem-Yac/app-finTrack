class MonthlyStats {
  const MonthlyStats({
    required this.month,
    required this.income,
    required this.expenses,
    required this.balance,
    required this.expensesDeltaPercent,
    required this.weeklyExpenses,
    required this.balanceEvolution,
  });

  final String month;
  final double income;
  final double expenses;
  final double balance;
  final double expensesDeltaPercent;
  final List<double> weeklyExpenses;
  final List<BalancePoint> balanceEvolution;

  factory MonthlyStats.fromJson(Map<String, dynamic> json) {
    return MonthlyStats(
      month: json['month'] as String,
      income: (json['income'] as num).toDouble(),
      expenses: (json['expenses'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      expensesDeltaPercent: (json['expenses_delta_percent'] as num).toDouble(),
      weeklyExpenses: (json['weekly_expenses'] as List<dynamic>? ?? [])
          .map((item) => (item as num).toDouble())
          .toList(),
      balanceEvolution: (json['balance_evolution'] as List<dynamic>? ?? [])
          .map((item) => BalancePoint.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BalancePoint {
  const BalancePoint({
    required this.month,
    required this.income,
    required this.expenses,
  });

  final String month;
  final double income;
  final double expenses;

  factory BalancePoint.fromJson(Map<String, dynamic> json) {
    return BalancePoint(
      month: json['month'] as String,
      income: (json['income'] as num).toDouble(),
      expenses: (json['expenses'] as num).toDouble(),
    );
  }
}

class CategoryStat {
  const CategoryStat({
    required this.name,
    required this.amount,
    required this.percent,
    this.slug,
    this.color,
  });

  final String name;
  final String? slug;
  final String? color;
  final double amount;
  final double percent;

  factory CategoryStat.fromJson(Map<String, dynamic> json) {
    return CategoryStat(
      name: json['name'] as String,
      slug: json['slug'] as String?,
      color: json['color'] as String?,
      amount: (json['amount'] as num).toDouble(),
      percent: (json['percent'] as num).toDouble(),
    );
  }
}
