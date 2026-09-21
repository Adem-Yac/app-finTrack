import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/cubit/transactions/transactions_state.dart';
import 'package:fintrack/data/repositories/finance_repository.dart';
import 'package:intl/intl.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit(this._repository) : super(const TransactionsInitial());

  final FinanceRepository _repository;
  String _filter = 'all';
  DateTime _month = DateTime.now();
  String _search = '';

  Future<void> load({String? filter, DateTime? month, String? search}) async {
    _filter = filter ?? _filter;
    _month = month ?? _month;
    _search = search ?? _search;
    emit(const TransactionsLoading());
    try {
      final items = await _repository.transactions(
        type: _filter == 'all' ? null : _filter,
        month: DateFormat('yyyy-MM').format(_month),
        search: _search,
      );
      emit(
        TransactionsLoaded(
          items: items,
          filter: _filter,
          month: _month,
          search: _search,
        ),
      );
    } catch (error) {
      emit(TransactionsFailure(error.toString()));
    }
  }

  Future<void> shiftMonth(int delta) {
    return load(month: DateTime(_month.year, _month.month + delta));
  }
}
