import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/cubit/shared/simple_state.dart';
import 'package:fintrack/data/repositories/market_repository.dart';

class CurrencyCubit extends Cubit<SimpleLoadState<CurrencyBundle>> {
  CurrencyCubit(this._repository) : super(const SimpleLoading());

  final MarketRepository _repository;
  String _from = 'EUR';
  String _to = 'USD';
  double _amount = 100;

  Future<void> load() async {
    emit(const SimpleLoading());
    try {
      final rates = await _repository.currencies(base: _from);
      final conversion = await _repository.convert(
        from: _from,
        to: _to,
        amount: _amount,
      );
      emit(
        SimpleLoaded(
          CurrencyBundle(
            rates: rates,
            conversion: conversion,
            amount: _amount,
            from: _from,
            to: _to,
          ),
        ),
      );
    } catch (error) {
      emit(SimpleFailure(error.toString()));
    }
  }

  Future<void> convert({String? from, String? to, double? amount}) {
    _from = from ?? _from;
    _to = to ?? _to;
    _amount = amount ?? _amount;
    return load();
  }
}
