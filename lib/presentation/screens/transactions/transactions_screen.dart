import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_scale.dart';
import 'package:fintrack/core/theme/app_text.dart';
import 'package:fintrack/core/utils/money_format.dart';
import 'package:fintrack/cubit/transactions/transactions_cubit.dart';
import 'package:fintrack/cubit/transactions/transactions_state.dart';
import 'package:fintrack/data/models/transaction_model.dart';
import 'package:fintrack/data/repositories/finance_repository.dart';
import 'package:fintrack/presentation/widgets/fin_header.dart';
import 'package:fintrack/presentation/widgets/transaction_tile.dart';
import 'package:fintrack/presentation/widgets/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final scale = AppScale.of(context);
    return Scaffold(
      body: SafeArea(
        child: AppPage(
          child: BlocBuilder<TransactionsCubit, TransactionsState>(
            builder: (context, state) {
              final loaded = state is TransactionsLoaded ? state : null;
              return Column(
                children: [
                  FinHeader(subtitle: l10n.history),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: scale.pagePadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.historyTitle,
                          style: AppText.headlineLg(context),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: search,
                          onChanged: (value) => context
                              .read<TransactionsCubit>()
                              .load(search: value),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              size: scale.iconMd,
                            ),
                            hintText: l10n.searchMoves,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SegmentedTabs(
                          labels: [l10n.all, l10n.income, l10n.expense],
                          index: loaded?.filter == 'income'
                              ? 1
                              : loaded?.filter == 'expense'
                              ? 2
                              : 0,
                          onChanged: (index) {
                            context.read<TransactionsCubit>().load(
                              filter: ['all', 'income', 'expense'][index],
                            );
                          },
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => context
                                  .read<TransactionsCubit>()
                                  .shiftMonth(-1),
                              icon: Icon(
                                Icons.chevron_left_rounded,
                                size: scale.iconLg,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                loaded == null
                                    ? ''
                                    : DateFormat.yMMMM(
                                        locale,
                                      ).format(loaded.month),
                                textAlign: TextAlign.center,
                                style: AppText.headlineSm(context),
                              ),
                            ),
                            IconButton(
                              onPressed: () => context
                                  .read<TransactionsCubit>()
                                  .shiftMonth(1),
                              icon: Icon(
                                Icons.chevron_right_rounded,
                                size: scale.iconLg,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: switch (state) {
                      TransactionsLoading() || TransactionsInitial() => Center(
                        child: Text(
                          l10n.preparing,
                          style: AppText.bodyMd(context),
                        ),
                      ),
                      TransactionsFailure(:final message) => Center(
                        child: Text(message),
                      ),
                      TransactionsLoaded(:final items) => ListView(
                        padding: EdgeInsets.fromLTRB(
                          scale.pagePadding,
                          0,
                          scale.pagePadding,
                          16,
                        ),
                        children: [
                          ..._grouped(items, l10n).entries.expand(
                            (entry) => [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Text(
                                  entry.key,
                                  style: AppText.labelSm(context),
                                ),
                              ),
                              FinCard(
                                padding: EdgeInsets.zero,
                                child: Column(
                                  children: [
                                    for (final item in entry.value)
                                      TransactionTile(
                                        transaction: item,
                                        onTap: () => context.push(
                                          '/transactions/${item.id}',
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Map<String, List<TransactionModel>> _grouped(
    List<TransactionModel> items,
    AppLocalizations l10n,
  ) {
    final map = <String, List<TransactionModel>>{};
    final now = DateTime.now();
    for (final item in items) {
      final key = DateUtils.isSameDay(item.occurredOn, now)
          ? l10n.today
          : DateUtils.isSameDay(
              item.occurredOn,
              now.subtract(const Duration(days: 1)),
            )
          ? l10n.yesterday
          : DateFormat.MMMd(
              Localizations.localeOf(context).toString(),
            ).format(item.occurredOn);
      map.putIfAbsent(key, () => []).add(item);
    }
    return map;
  }
}

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scale = AppScale.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history, style: AppText.headlineSm(context)),
      ),
      body: AppPage(
        child: FutureBuilder(
          future: context.read<FinanceRepository>().transaction(id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text(l10n.preparing, style: AppText.bodyMd(context)),
              );
            }
            final item = snapshot.data!;
            return ListView(
              padding: EdgeInsets.all(scale.pagePadding),
              children: [
                FinCard(
                  child: Column(
                    children: [
                      FinIcon(
                        item.isIncome
                            ? Icons.south_west_rounded
                            : Icons.north_east_rounded,
                      ),
                      const SizedBox(height: 12),
                      MoneyText(
                        item.isIncome ? item.amount : -item.amount,
                        hero: true,
                        withSign: true,
                        color: item.isIncome
                            ? AppColors.income
                            : AppColors.errorSoft,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.note ?? item.category?.name ?? '—',
                        style: AppText.headlineSm(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                FinCard(
                  child: Text(item.note ?? '—', style: AppText.bodyMd(context)),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.errorSoft,
                  ),
                  onPressed: () async {
                    await context.read<FinanceRepository>().deleteTransaction(
                      id,
                    );
                    if (context.mounted) context.pop();
                  },
                  child: Text(l10n.delete),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
