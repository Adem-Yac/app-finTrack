class GoalDepositModel {
  const GoalDepositModel({
    required this.id,
    required this.amount,
    required this.depositedOn,
    this.note,
  });

  final int id;
  final double amount;
  final DateTime depositedOn;
  final String? note;

  factory GoalDepositModel.fromJson(Map<String, dynamic> json) {
    return GoalDepositModel(
      id: json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
      depositedOn: DateTime.parse(json['deposited_on'] as String),
      note: json['note'] as String?,
    );
  }
}

class GoalModel {
  const GoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.remaining,
    required this.percent,
    this.emoji,
    this.deadline,
    this.deposits = const [],
  });

  final int id;
  final String title;
  final String? emoji;
  final double targetAmount;
  final double currentAmount;
  final double remaining;
  final double percent;
  final DateTime? deadline;
  final List<GoalDepositModel> deposits;

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as int,
      title: json['title'] as String,
      emoji: json['emoji'] as String?,
      targetAmount: (json['target_amount'] as num).toDouble(),
      currentAmount: (json['current_amount'] as num).toDouble(),
      remaining: (json['remaining'] as num).toDouble(),
      percent: (json['percent'] as num).toDouble(),
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      deposits: (json['deposits'] as List<dynamic>? ?? [])
          .map(
            (item) => GoalDepositModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
