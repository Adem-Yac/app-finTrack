import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_scale.dart';
import 'package:fintrack/core/theme/app_text.dart';
import 'package:fintrack/core/utils/money_format.dart';
import 'package:fintrack/cubit/shared/simple_state.dart';
import 'package:fintrack/cubit/statistics/statistics_cubit.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:fintrack/presentation/widgets/fin_header.dart';
import 'package:fintrack/presentation/widgets/ui_kit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scale = AppScale.of(context);
    return Scaffold(
      body: SafeArea(
        child: AppPage(
          child: BlocBuilder<StatisticsCubit, SimpleLoadState<StatsBundle>>(
            builder: (context, state) {
              if (state is SimpleLoading<StatsBundle>) {
                return Center(
                  child: Text(l10n.preparing, style: AppText.bodyMd(context)),
                );
              }
              if (state is SimpleFailure<StatsBundle>) {
                return Center(child: Text(state.message));
              }
              final data = (state as SimpleLoaded<StatsBundle>).data;
              return ListView(
                padding: EdgeInsets.only(bottom: 20),
                children: [
                  FinHeader(subtitle: l10n.stats),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: scale.pagePadding,
                    ),
                    child: Text(
                      l10n.reports,
                      style: AppText.headlineLg(context),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(scale.pagePadding),
                    child: FinCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.moneyOut, style: AppText.labelSm(context)),
                          MoneyText(data.monthly.expenses, hero: true),
                          const SizedBox(height: 8),
                          MoneyText(
                            data.monthly.balance,
                            color: AppColors.income,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: scale.pagePadding,
                    ),
                    child: FinCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final item in data.categories) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: AppText.labelMd(
                                      context,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ),
                                MoneyText(item.amount),
                              ],
                            ),
                            const SizedBox(height: 6),
                            BudgetBar(percent: item.percent),
                            const SizedBox(height: 12),
                          ],
                          if (data.monthly.balanceEvolution.isNotEmpty)
                            SizedBox(
                              height: 160,
                              child: BarChart(
                                BarChartData(
                                  gridData: const FlGridData(show: false),
                                  borderData: FlBorderData(show: false),
                                  titlesData: FlTitlesData(
                                    leftTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          final i = value.toInt();
                                          if (i < 0 ||
                                              i >=
                                                  data
                                                      .monthly
                                                      .balanceEvolution
                                                      .length) {
                                            return const SizedBox.shrink();
                                          }
                                          return Text(
                                            data
                                                .monthly
                                                .balanceEvolution[i]
                                                .month,
                                            style: AppText.labelSm(context),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  barGroups: [
                                    for (
                                      var i = 0;
                                      i < data.monthly.balanceEvolution.length;
                                      i++
                                    )
                                      BarChartGroupData(
                                        x: i,
                                        barsSpace: 4,
                                        barRods: [
                                          BarChartRodData(
                                            toY: data
                                                .monthly
                                                .balanceEvolution[i]
                                                .income,
                                            color: AppColors.primary,
                                            width: scale.isTablet ? 10 : 8,
                                          ),
                                          BarChartRodData(
                                            toY: data
                                                .monthly
                                                .balanceEvolution[i]
                                                .expenses,
                                            color: AppColors.errorSoft,
                                            width: scale.isTablet ? 10 : 8,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(scale.pagePadding),
                    child: Column(
                      children: [
                        FilledButton(
                          onPressed: () => context.push('/currency'),
                          child: Text(l10n.rates),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () => context.push('/algeria'),
                          child: Text(l10n.algeriaMarket),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
