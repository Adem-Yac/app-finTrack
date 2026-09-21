import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/cubit/currency/currency_cubit.dart';
import 'package:fintrack/cubit/shared/simple_state.dart';
import 'package:fintrack/presentation/widgets/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final amount = TextEditingController(text: '100');
  String from = 'EUR';
  String to = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.rates)),
      body: BlocBuilder<CurrencyCubit, SimpleLoadState<CurrencyBundle>>(
        builder: (context, state) {
          if (state is SimpleLoading<CurrencyBundle>) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SimpleFailure<CurrencyBundle>) {
            return Center(child: Text(state.message));
          }
          final data = (state as SimpleLoaded<CurrencyBundle>).data;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                AppLocalizations.of(context)!.dinar,
                style: const TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 12),
              FinCard(
                child: Column(
                  children: [
                    TextField(
                      controller: amount,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Montant'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _dropdown(
                            'De',
                            from,
                            (value) => setState(() => from = value),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              final tmp = from;
                              from = to;
                              to = tmp;
                            });
                          },
                          icon: const Icon(Icons.swap_horiz),
                        ),
                        Expanded(
                          child: _dropdown(
                            'Vers',
                            to,
                            (value) => setState(() => to = value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => context.read<CurrencyCubit>().convert(
                        from: from,
                        to: to,
                        amount:
                            double.tryParse(amount.text.replaceAll(',', '.')) ??
                            100,
                      ),
                      child: const Text('Convertir'),
                    ),
                    if (data.conversion != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        '${data.conversion!.amount.toStringAsFixed(0)} ${data.conversion!.from} ≈ ${data.conversion!.result.toStringAsFixed(2)} ${data.conversion!.to}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Taux ${data.conversion!.rate}  •  ${data.conversion!.date ?? ''}',
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FinCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.rates,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    for (final rate in data.rates)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('${rate.base} → ${rate.quote}'),
                            ),
                            Text(
                              rate.rate.toStringAsFixed(4),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.push('/algeria'),
                child: Text(AppLocalizations.of(context)!.algeriaMarket),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _dropdown(String label, String value, ValueChanged<String> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: const [
        DropdownMenuItem(value: 'EUR', child: Text('EUR')),
        DropdownMenuItem(value: 'USD', child: Text('USD')),
        DropdownMenuItem(value: 'GBP', child: Text('GBP')),
        DropdownMenuItem(value: 'CHF', child: Text('CHF')),
        DropdownMenuItem(value: 'JPY', child: Text('JPY')),
      ],
      onChanged: (item) {
        if (item != null) {
          onChanged(item);
        }
      },
    );
  }
}
