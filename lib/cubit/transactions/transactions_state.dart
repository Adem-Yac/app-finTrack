import 'package:equatable/equatable.dart';
import 'package:fintrack/data/models/transaction_model.dart';

sealed class TransactionsState extends Equatable {
  const TransactionsState();
  @override
  List<Object?> get props => [];
}

final class TransactionsInitial extends TransactionsState {
  const TransactionsInitial();
}

final class TransactionsLoading extends TransactionsState {
  const TransactionsLoading();
}

final class TransactionsLoaded extends TransactionsState {
  const TransactionsLoaded({
    required this.items,
    required this.filter,
    required this.month,
    this.search = '',
  });

  final List<TransactionModel> items;
  final String filter;
  final DateTime month;
  final String search;

  @override
  List<Object?> get props => [items, filter, month, search];
}

final class TransactionsFailure extends TransactionsState {
  const TransactionsFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
