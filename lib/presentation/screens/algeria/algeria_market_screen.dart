import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/utils/money_format.dart';
import 'package:fintrack/cubit/algeria/algeria_cubit.dart';
import 'package:fintrack/cubit/shared/simple_state.dart';
import 'package:fintrack/presentation/widgets/ui_kit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/l10n/app_localizations.dart';

class AlgeriaMarketScreen extends StatelessWidget {
  const AlgeriaMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.algeriaMarket)),
      body: BlocBuilder<AlgeriaCubit, SimpleLoadState<AlgeriaBundle>>(
        builder: (context, state) {
          if (state is SimpleLoading<AlgeriaBundle>) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SimpleFailure<AlgeriaBundle>) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(state.message, textAlign: TextAlign.center),
              ),
            );
          }
          final data = (state as SimpleLoaded<AlgeriaBundle>).data;
          final pair = data.rates.pair(data.currency);
          final cubit = context.read<AlgeriaCubit>();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (data.rates.note != null) ...[
                FinCard(
                  color: const Color(0xFFFFFBEB),
                  child: Text(
                    data.rates.note!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SegmentedTabs(
                labels: const ['EUR', 'USD'],
                index: data.currency == 'USD' ? 1 : 0,
                onChanged: (index) =>
                    cubit.load(currency: index == 0 ? 'EUR' : 'USD'),
              ),
              const SizedBox(height: 16),
              Text(
                '${data.currency} / DZD',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _rateCard(
                      'Official',
                      pair.official.rate,
                      AppColors.surfaceLow,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _rateCard(
                      'Parallel',
                      pair.parallel.rate,
                      const Color(0xFFDCFCE7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _rateCard(
                      'Difference',
                      pair.difference,
                      const Color(0xFFFFF7ED),
                      prefix: '+',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _rateCard(
                      'Premium',
                      pair.premiumPercent,
                      const Color(0xFFEEF2FF),
                      suffix: '%',
                      prefix: '+',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SegmentedTabs(
                labels: const ['30 days', '90 days', '1 year'],
                index: data.range == '90d'
                    ? 1
                    : data.range == '1y'
                    ? 2
                    : 0,
                onChanged: (index) =>
                    cubit.load(range: ['30d', '90d', '1y'][index]),
              ),
              const SizedBox(height: 16),
              FinCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Historique officiel vs parallèle',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 220,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                for (
                                  var i = 0;
                                  i < data.history.official.length;
                                  i++
                                )
                                  FlSpot(
                                    i.toDouble(),
                                    data.history.official[i].rate,
                                  ),
                              ],
                              color: AppColors.muted,
                              dotData: const FlDotData(show: false),
                            ),
                            LineChartBarData(
                              spots: [
                                for (
                                  var i = 0;
                                  i < data.history.parallel.length;
                                  i++
                                )
                                  FlSpot(
                                    i.toDouble(),
                                    data.history.parallel[i].rate,
                                  ),
                              ],
                              color: AppColors.primary,
                              barWidth: 3,
                              dotData: const FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Vert = parallèle (Square)  •  Gris = officiel'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Source : ${data.rates.provider == 'exdz' ? 'EXDZ via Laravel' : 'taux indicatifs marché algérien'}',
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _rateCard(
    String label,
    double value,
    Color color, {
    String prefix = '',
    String suffix = ' DZD',
  }) {
    final text = suffix == '%'
        ? '$prefix${value.toStringAsFixed(1)}$suffix'
        : '$prefix${MoneyFormat.da(value).replaceAll(' DA', '')}$suffix';
    return FinCard(
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
