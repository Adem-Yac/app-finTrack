import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/cubit/shared/simple_state.dart';
import 'package:fintrack/data/repositories/finance_repository.dart';

class BudgetsCubit extends Cubit<SimpleLoadState<BudgetBundle>> {
  BudgetsCubit(this._repository) : super(const SimpleLoading());

  final FinanceRepository _repository;

  Future<void> load() async {
    emit(const SimpleLoading());
    try {
      final now = DateTime.now();
      final budget = await _repository.budget(now.year, now.month);
      final goals = await _repository.goals();
      final categories = await _repository.categories();
      emit(
        SimpleLoaded(
          BudgetBundle(budget: budget, goals: goals, categories: categories),
        ),
      );
    } catch (error) {
      emit(SimpleFailure(error.toString()));
    }
  }

  Future<void> deposit(int goalId, double amount) async {
    await _repository.deposit(goalId, amount);
    await load();
  }

  Future<void> createGoal(Map<String, dynamic> payload) async {
    await _repository.createGoal(payload);
    await load();
  }

  Future<void> saveBudget(Map<String, dynamic> payload) async {
    await _repository.saveBudget(payload);
    await load();
  }
}
