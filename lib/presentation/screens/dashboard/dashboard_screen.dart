import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_scale.dart';
import 'package:fintrack/core/theme/app_text.dart';
import 'package:fintrack/core/utils/category_style.dart';
import 'package:fintrack/core/utils/money_format.dart';
import 'package:fintrack/cubit/auth/auth_cubit.dart';
import 'package:fintrack/cubit/auth/auth_state.dart';
import 'package:fintrack/cubit/dashboard/dashboard_cubit.dart';
import 'package:fintrack/cubit/dashboard/dashboard_state.dart';
import 'package:fintrack/presentation/widgets/fin_header.dart';
import 'package:fintrack/presentation/widgets/transaction_tile.dart';
import 'package:fintrack/presentation/widgets/ui_kit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scale = AppScale.of(context);
    final auth = context.watch<AuthCubit>().state;
    final name = auth is AuthAuthenticated ? auth.user.firstName : '';

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading || state is DashboardInitial) {
              return LoadingHint(label: l10n.preparing);
            }
            if (state is DashboardFailure) {
              return EmptyHint(
                icon: Icons.refresh_rounded,
                title: l10n.retry,
                body: state.message,
                actionLabel: l10n.retry,
                onAction: () => context.read<DashboardCubit>().load(),
              );
            }
            final data = state as DashboardLoaded;
            final maxWeek = data.stats.weeklyExpenses.fold<double>(
              1,
              (a, b) => a > b ? a : b,
            );
            return RefreshIndicator(
              onRefresh: () => context.read<DashboardCubit>().load(),
              child: AppPage(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 20),
                  children: [
                    FinHeader(
                      subtitle: name.isEmpty ? l10n.wealth : l10n.hello(name),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: scale.pagePadding,
                      ),
                      child: FinCard(
                        color: AppColors.primary,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: AppColors.onPrimary,
                                  size: scale.iconMd,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.availableBalance,
                                    style: AppText.labelMd(
                                      context,
                                      color: AppColors.onPrimary,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => context
                                      .read<DashboardCubit>()
                                      .toggleBalance(),
                                  icon: Icon(
                                    data.hideBalance
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppColors.onPrimary,
                                    size: scale.iconMd,
                                  ),
                                ),
                              ],
                            ),
                            data.hideBalance
                                ? Text(
                                    '••••••',
                                    style: AppText.headlineXl(
                                      context,
                                      color: AppColors.onPrimary,
                                      tabular: true,
                                    ),
                                  )
                                : MoneyText(
                                    data.stats.balance,
                                    hero: true,
                                    color: AppColors.onPrimary,
                                  ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _miniStat(
                                    context,
                                    l10n.moneyIn,
                                    data.stats.income,
                                    true,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _miniStat(
                                    context,
                                    l10n.moneyOut,
                                    -data.stats.expenses,
                                    true,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: TextButton(
                                onPressed: () => context.push('/algeria'),
                                child: Text(
                                  l10n.algeriaMarket,
                                  style: AppText.labelMd(
                                    context,
                                    color: AppColors.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: scale.pagePadding,
                      ),
                      child: FinCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    l10n.moneyOut,
                                    style: AppText.headlineSm(context),
                                  ),
                                ),
                                MoneyText(
                                  data.stats.expenses,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 140,
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
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          final i = value.toInt();
                                          if (i < 0 ||
                                              i >=
                                                  data
                                                      .stats
                                                      .weeklyExpenses
                                                      .length) {
                                            return const SizedBox.shrink();
                                          }
                                          return Text(
                                            MoneyFormat.compact(
                                              data.stats.weeklyExpenses[i],
                                            ),
                                            style: AppText.labelSm(context),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) => Text(
                                          'S${value.toInt() + 1}',
                                          style: AppText.labelSm(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                  barGroups: [
                                    for (
                                      var i = 0;
                                      i < data.stats.weeklyExpenses.length;
                                      i++
                                    )
                                      BarChartGroupData(
                                        x: i,
                                        barRods: [
                                          BarChartRodData(
                                            toY: data.stats.weeklyExpenses[i],
                                            width: scale.isTablet ? 22 : 18,
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(6),
                                                ),
                                            color:
                                                i ==
                                                    data
                                                            .stats
                                                            .weeklyExpenses
                                                            .length -
                                                        2
                                                ? AppColors.primary
                                                : AppColors.tertiary,
                                          ),
                                        ],
                                      ),
                                  ],
                                  maxY: maxWeek * 1.25,
                                ),
                              ),
                            ),
                            if (data.categories.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              for (final category in data.categories.take(4))
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        CategoryStyle.icon(category.slug),
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          category.name,
                                          style: AppText.labelMd(context),
                                        ),
                                      ),
                                      MoneyText(category.amount),
                                    ],
                                  ),
                                ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        scale.pagePadding,
                        18,
                        scale.pagePadding,
                        8,
                      ),
                      child: Row(
                        children: [
                          Text(
                            l10n.lastMoves,
                            style: AppText.headlineSm(context),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => context.go('/transactions'),
                            child: Text(l10n.seeAll),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: scale.pagePadding,
                      ),
                      child: FinCard(
                        padding: data.transactions.isEmpty
                            ? const EdgeInsets.all(8)
                            : EdgeInsets.zero,
                        child: data.transactions.isEmpty
                            ? EmptyHint(
                                icon: Icons.receipt_long_outlined,
                                title: l10n.noMoves,
                                body: l10n.noMovesBody,
                                actionLabel: l10n.add,
                                onAction: () => context.push('/add'),
                              )
                            : Column(
                                children: [
                                  for (final item in data.transactions)
                                    TransactionTile(
                                      transaction: item,
                                      onTap: () => context.push(
                                        '/transactions/${item.id}',
                                      ),
                                    ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget _miniStat(
    BuildContext context,
    String label,
    double value,
    bool income,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppText.labelSm(context, color: AppColors.onPrimary),
          ),
          const SizedBox(height: 4),
          MoneyText(
            value,
            withSign: true,
            color: income
                ? AppColors.secondaryContainer
                : const Color(0xFFFFDAD6),
          ),
        ],
      ),
    );
  }
}
