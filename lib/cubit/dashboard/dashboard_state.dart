import 'package:equatable/equatable.dart';
import 'package:fintrack/data/models/statistics_model.dart';
import 'package:fintrack/data/models/transaction_model.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardLoaded extends DashboardState {
  const DashboardLoaded({
    required this.stats,
    required this.transactions,
    this.categories = const [],
    this.hideBalance = false,
  });

  final MonthlyStats stats;
  final List<TransactionModel> transactions;
  final List<CategoryStat> categories;
  final bool hideBalance;

  @override
  List<Object?> get props => [
    stats.month,
    stats.balance,
    transactions,
    categories,
    hideBalance,
  ];
}

final class DashboardFailure extends DashboardState {
  const DashboardFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
