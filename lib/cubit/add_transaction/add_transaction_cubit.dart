import 'package:equatable/equatable.dart';
import 'package:fintrack/data/models/category_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/data/repositories/finance_repository.dart';

class AddTransactionState extends Equatable {
  const AddTransactionState({
    this.categories = const [],
    this.type = 'expense',
    this.amount = '0',
    this.categoryId,
    this.date,
    this.paymentMethod = 'cash',
    this.note = '',
    this.saving = false,
    this.error,
    this.saved = false,
  });

  final List<CategoryModel> categories;
  final String type;
  final String amount;
  final int? categoryId;
  final DateTime? date;
  final String paymentMethod;
  final String note;
  final bool saving;
  final String? error;
  final bool saved;

  double get value {
    final normalized = amount.replaceAll(',', '.').replaceAll(' ', '');
    return double.tryParse(normalized) ?? 0;
  }

  AddTransactionState copyWith({
    List<CategoryModel>? categories,
    String? type,
    String? amount,
    int? categoryId,
    DateTime? date,
    String? paymentMethod,
    String? note,
    bool? saving,
    String? error,
    bool? saved,
    bool clearError = false,
  }) {
    return AddTransactionState(
      categories: categories ?? this.categories,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      note: note ?? this.note,
      saving: saving ?? this.saving,
      error: clearError ? null : error ?? this.error,
      saved: saved ?? this.saved,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    type,
    amount,
    categoryId,
    date,
    paymentMethod,
    note,
    saving,
    error,
    saved,
  ];
}

class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit(this._repository)
    : super(AddTransactionState(date: DateTime.now()));

  final FinanceRepository _repository;

  Future<void> load() async {
    final categories = await _repository.categories();
    final filtered = categories.where((item) => item.type != 'income').toList();
    emit(
      state.copyWith(
        categories: categories,
        categoryId: filtered.isNotEmpty
            ? filtered.first.id
            : categories.first.id,
      ),
    );
  }

  void setType(String type) {
    final match = state.categories.where(
      (item) =>
          type == 'income' ? item.type != 'expense' : item.type != 'income',
    );
    emit(
      state.copyWith(
        type: type,
        categoryId: match.isNotEmpty ? match.first.id : state.categoryId,
      ),
    );
  }

  void setAmount(String amount) {
    final cleaned = amount.replaceAll(RegExp(r'[^0-9.,]'), '');
    emit(state.copyWith(amount: cleaned.isEmpty ? '0' : cleaned));
  }

  void setCategory(int id) => emit(state.copyWith(categoryId: id));
  void setMethod(String method) => emit(state.copyWith(paymentMethod: method));
  void setNote(String note) => emit(state.copyWith(note: note));
  void setDate(DateTime date) => emit(state.copyWith(date: date));

  Future<void> save() async {
    if (state.value <= 0 || state.categoryId == null) {
      emit(state.copyWith(error: 'Montant et catégorie requis.'));
      return;
    }
    emit(state.copyWith(saving: true, clearError: true));
    try {
      await _repository.createTransaction({
        'type': state.type,
        'amount': state.value,
        'category_id': state.categoryId,
        'occurred_on': (state.date ?? DateTime.now())
            .toIso8601String()
            .substring(0, 10),
        'note': state.note,
        'payment_method': state.paymentMethod,
        'currency': 'DZD',
      });
      emit(state.copyWith(saving: false, saved: true));
    } catch (error) {
      emit(state.copyWith(saving: false, error: error.toString()));
    }
  }
}
