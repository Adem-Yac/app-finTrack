import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_scale.dart';
import 'package:fintrack/core/theme/app_text.dart';
import 'package:fintrack/core/utils/category_style.dart';
import 'package:fintrack/core/utils/money_format.dart';
import 'package:fintrack/cubit/budgets/budgets_cubit.dart';
import 'package:fintrack/cubit/shared/simple_state.dart';
import 'package:fintrack/data/models/budget_model.dart';
import 'package:fintrack/data/models/category_model.dart';
import 'package:fintrack/data/models/goal_model.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:fintrack/presentation/widgets/fin_header.dart';
import 'package:fintrack/presentation/widgets/stitch.dart';
import 'package:fintrack/presentation/widgets/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scale = AppScale.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: BlocBuilder<BudgetsCubit, SimpleLoadState<BudgetBundle>>(
          builder: (context, state) {
            if (state is SimpleLoading<BudgetBundle>) {
              return LoadingHint(label: l10n.preparing);
            }
            if (state is SimpleFailure<BudgetBundle>) {
              return EmptyHint(
                icon: Icons.refresh_rounded,
                title: l10n.retry,
                body: state.message,
                actionLabel: l10n.retry,
                onAction: () => context.read<BudgetsCubit>().load(),
              );
            }
            final data = (state as SimpleLoaded<BudgetBundle>).data;
            return AppPage(
              child: ListView(
                padding: EdgeInsets.only(bottom: 24),
                children: [
                  FinHeader(subtitle: l10n.budgets),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: scale.pagePadding,
                    ),
                    child: SegmentedTabs(
                      labels: [l10n.monthlyBudgets, l10n.savingsGoals],
                      index: tab,
                      onChanged: (value) => setState(() => tab = value),
                    ),
                  ),
                  if (tab == 0)
                    ..._budgets(context, data.budget)
                  else
                    ..._goals(context, data.goals),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      scale.pagePadding,
                      16,
                      scale.pagePadding,
                      0,
                    ),
                    child: OutlinedButton.icon(
                      onPressed: () => tab == 0
                          ? _createBudget(context, data)
                          : _createGoal(context),
                      icon: const Icon(Icons.add_rounded),
                      label: Text(
                        tab == 0 ? l10n.createBudget : l10n.createGoal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _budgets(BuildContext context, BudgetModel? budget) {
    final l10n = AppLocalizations.of(context)!;
    final scale = AppScale.of(context);
    final locale = Localizations.localeOf(context).toString();
    if (budget == null) {
      return [
        EmptyHint(
          icon: Icons.account_balance_wallet_outlined,
          title: l10n.noBudget,
          body: l10n.noBudgetBody,
          actionLabel: l10n.createBudget,
          onAction: () => _createBudget(
            context,
            (context.read<BudgetsCubit>().state as SimpleLoaded<BudgetBundle>)
                .data,
          ),
        ),
      ];
    }
    return [
      Padding(
        padding: EdgeInsets.fromLTRB(
          scale.pagePadding,
          16,
          scale.pagePadding,
          0,
        ),
        child: GestureDetector(
          onTap: () => context.push('/budgets/${budget.id}'),
          child: FinCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMM(
                    locale,
                  ).format(DateTime(budget.year, budget.month)),
                  style: AppText.headlineMd(context),
                ),
                const SizedBox(height: 4),
                Text(l10n.budgetOverview, style: AppText.bodySm(context)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _kpi(
                      context,
                      l10n.allocated,
                      MoneyFormat.da(budget.totalAmount),
                    ),
                    _kpi(
                      context,
                      l10n.spent,
                      MoneyFormat.da(budget.spent),
                      color: AppColors.errorSoft,
                    ),
                    _kpi(
                      context,
                      l10n.remaining,
                      MoneyFormat.da(budget.remaining),
                      color: AppColors.income,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                BudgetBar(percent: budget.percent),
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(
          scale.pagePadding,
          20,
          scale.pagePadding,
          0,
        ),
        child: Text(l10n.byCategory, style: AppText.headlineSm(context)),
      ),
      for (final item in budget.categories)
        Padding(
          padding: EdgeInsets.fromLTRB(
            scale.pagePadding,
            10,
            scale.pagePadding,
            0,
          ),
          child: FinCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FinIcon(CategoryStyle.icon(item.category?.slug)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.category?.name ?? '',
                        style: AppText.labelLg(context),
                      ),
                    ),
                    Text('${item.percent}%', style: AppText.labelMd(context)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${MoneyFormat.da(item.spent)}  ·  ${MoneyFormat.da(item.allocatedAmount)}',
                  style: AppText.bodySm(context),
                ),
                const SizedBox(height: 8),
                BudgetBar(percent: item.percent),
              ],
            ),
          ),
        ),
    ];
  }

  List<Widget> _goals(BuildContext context, List<GoalModel> goals) {
    final l10n = AppLocalizations.of(context)!;
    final scale = AppScale.of(context);
    if (goals.isEmpty) {
      return [
        EmptyHint(
          icon: Icons.flag_outlined,
          title: l10n.savingsGoals,
          body: l10n.noBudgetBody,
          actionLabel: l10n.createGoal,
          onAction: () => _createGoal(context),
        ),
      ];
    }
    return [
      for (final goal in goals)
        Padding(
          padding: EdgeInsets.fromLTRB(
            scale.pagePadding,
            12,
            scale.pagePadding,
            0,
          ),
          child: GestureDetector(
            onTap: () => context.push('/goals/${goal.id}'),
            child: FinCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        goal.emoji ?? '🎯',
                        style: const TextStyle(fontSize: 26),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          goal.title,
                          style: AppText.headlineSm(context),
                        ),
                      ),
                      Text('${goal.percent}%', style: AppText.labelMd(context)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${MoneyFormat.da(goal.currentAmount)}  ·  ${MoneyFormat.da(goal.targetAmount)}',
                    style: AppText.bodySm(context),
                  ),
                  const SizedBox(height: 8),
                  BudgetBar(percent: goal.percent),
                  const SizedBox(height: 10),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: () => _deposit(context, goal),
                      child: Text(l10n.addMoney),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    ];
  }

  Widget _kpi(
    BuildContext context,
    String label,
    String value, {
    Color? color,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.bodySm(context)),
          const SizedBox(height: 4),
          Text(value, style: AppText.labelLg(context, color: color)),
        ],
      ),
    );
  }

  Future<void> _deposit(BuildContext context, GoalModel goal) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: '5000');
    final amount = await showFinSheet<double>(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.deposit} · ${goal.title}',
            style: AppText.headlineSm(context),
          ),
          const SizedBox(height: 14),
          SoftField(
            controller: controller,
            keyboardType: TextInputType.number,
            hint: l10n.amount,
          ),
          const SizedBox(height: 16),
          ForestButton(
            label: l10n.deposit,
            onPressed: () => Navigator.pop(
              context,
              double.tryParse(controller.text.replaceAll(',', '.')),
            ),
          ),
        ],
      ),
    );
    if (amount != null && amount > 0 && context.mounted) {
      await context.read<BudgetsCubit>().deposit(goal.id, amount);
    }
  }

  Future<void> _createGoal(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    const emojis = ['🎯', '💻', '✈️', '🏠', '🚗', '📚'];
    var emoji = emojis.first;
    final title = TextEditingController();
    final target = TextEditingController(text: '100000');
    await showFinSheet<void>(
      context: context,
      child: StatefulBuilder(
        builder: (context, setSheet) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.newGoal, style: AppText.headlineSm(context)),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                children: [
                  for (final item in emojis)
                    GestureDetector(
                      onTap: () => setSheet(() => emoji = item),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: emoji == item
                              ? AppColors.incomeSoft
                              : AppColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(item, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              SoftField(controller: title, hint: l10n.goalTitle),
              const SizedBox(height: 12),
              SoftField(
                controller: target,
                hint: l10n.targetAmount,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ForestButton(
                label: l10n.create,
                onPressed: () async {
                  final name = title.text.trim();
                  final amount =
                      double.tryParse(target.text.replaceAll(',', '.')) ?? 0;
                  if (name.isEmpty || amount < 1) {
                    return;
                  }
                  await context.read<BudgetsCubit>().createGoal({
                    'title': name,
                    'target_amount': amount,
                    'emoji': emoji,
                  });
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _createBudget(BuildContext context, BudgetBundle data) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(
      text: data.budget?.totalAmount.toStringAsFixed(0) ?? '45000',
    );
    await showFinSheet<void>(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.newBudget, style: AppText.headlineSm(context)),
          const SizedBox(height: 6),
          Text(l10n.noBudgetBody, style: AppText.bodySm(context)),
          const SizedBox(height: 14),
          SoftField(
            controller: controller,
            hint: l10n.monthlyAmount,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          ForestButton(
            label: l10n.save,
            onPressed: () async {
              final total =
                  double.tryParse(controller.text.replaceAll(',', '.')) ?? 0;
              if (total < 1) {
                return;
              }
              final now = DateTime.now();
              final cats = data.categories
                  .where((item) => item.type != 'income')
                  .take(4)
                  .toList();
              final slice = cats.isEmpty ? total : (total / cats.length);
              await context.read<BudgetsCubit>().saveBudget({
                'year': now.year,
                'month': now.month,
                'total_amount': total,
                'categories': [
                  for (final CategoryModel category in cats)
                    {
                      'category_id': category.id,
                      'allocated_amount': slice.roundToDouble(),
                    },
                ],
              });
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

class BudgetDetailScreen extends StatelessWidget {
  const BudgetDetailScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.budgets, style: AppText.headlineSm(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(l10n.budgetOverview, style: AppText.bodyMd(context)),
      ),
    );
  }
}

class GoalDetailScreen extends StatelessWidget {
  const GoalDetailScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.savingsGoals, style: AppText.headlineSm(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(l10n.budgetOverview, style: AppText.bodyMd(context)),
      ),
    );
  }
}
