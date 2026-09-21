import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/cubit/shared/simple_state.dart';
import 'package:fintrack/data/repositories/market_repository.dart';

class AlgeriaCubit extends Cubit<SimpleLoadState<AlgeriaBundle>> {
  AlgeriaCubit(this._repository) : super(const SimpleLoading());

  final MarketRepository _repository;
  String _currency = 'EUR';
  String _range = '30d';

  Future<void> load({String? currency, String? range}) async {
    _currency = currency ?? _currency;
    _range = range ?? _range;
    emit(const SimpleLoading());
    try {
      final rates = await _repository.algeriaRates();
      final history = await _repository.algeriaHistory(
        currency: _currency,
        range: _range,
      );
      emit(
        SimpleLoaded(
          AlgeriaBundle(
            rates: rates,
            history: history,
            currency: _currency,
            range: _range,
          ),
        ),
      );
    } catch (error) {
      emit(SimpleFailure(error.toString()));
    }
  }
}
