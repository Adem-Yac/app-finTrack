import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/cubit/dashboard/dashboard_state.dart';
import 'package:fintrack/data/repositories/finance_repository.dart';
import 'package:intl/intl.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repository) : super(const DashboardInitial());

  final FinanceRepository _repository;
  bool _hide = false;

  Future<void> load() async {
    emit(const DashboardLoading());
    try {
      final month = DateFormat('yyyy-MM').format(DateTime.now());
      final stats = await _repository.monthlyStats(month);
      final categories = await _repository.categoryStats(month);
      final transactions = await _repository.transactions(month: month);
      emit(
        DashboardLoaded(
          stats: stats,
          categories: categories,
          transactions: transactions.take(5).toList(),
          hideBalance: _hide,
        ),
      );
    } catch (error) {
      emit(DashboardFailure(error.toString()));
    }
  }

  void toggleBalance() {
    final current = state;
    if (current is! DashboardLoaded) {
      return;
    }
    _hide = !_hide;
    emit(
      DashboardLoaded(
        stats: current.stats,
        categories: current.categories,
        transactions: current.transactions,
        hideBalance: _hide,
      ),
    );
  }
}
