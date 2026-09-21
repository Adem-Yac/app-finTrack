import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/cubit/shared/simple_state.dart';
import 'package:fintrack/data/repositories/finance_repository.dart';
import 'package:intl/intl.dart';

class StatisticsCubit extends Cubit<SimpleLoadState<StatsBundle>> {
  StatisticsCubit(this._repository) : super(const SimpleLoading());

  final FinanceRepository _repository;

  Future<void> load() async {
    emit(const SimpleLoading());
    try {
      final month = DateFormat('yyyy-MM').format(DateTime.now());
      final monthly = await _repository.monthlyStats(month);
      final categories = await _repository.categoryStats(month);
      emit(SimpleLoaded(StatsBundle(monthly: monthly, categories: categories)));
    } catch (error) {
      emit(SimpleFailure(error.toString()));
    }
  }
}
