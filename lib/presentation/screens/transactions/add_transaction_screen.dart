import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_scale.dart';
import 'package:fintrack/core/theme/app_text.dart';
import 'package:fintrack/core/utils/category_style.dart';
import 'package:fintrack/cubit/add_transaction/add_transaction_cubit.dart';
import 'package:fintrack/presentation/widgets/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scale = AppScale.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newMove, style: AppText.headlineSm(context)),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_rounded, size: scale.iconLg),
        ),
      ),
      body: BlocConsumer<AddTransactionCubit, AddTransactionState>(
        listener: (context, state) {
          if (state.saved) context.pop(true);
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          final cubit = context.read<AddTransactionCubit>();
          final cats = state.categories
              .where(
                (item) => state.type == 'income'
                    ? item.type != 'expense'
                    : item.type != 'income',
              )
              .toList();
          final date = state.date ?? DateTime.now();
          final locale = Localizations.localeOf(context).toString();
          return AppPage(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                scale.pagePadding,
                8,
                scale.pagePadding,
                28,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _typeChip(
                        context,
                        'expense',
                        l10n.expense,
                        state.type == 'expense',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _typeChip(
                        context,
                        'income',
                        l10n.income,
                        state.type == 'income',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(l10n.amount, style: AppText.labelMd(context)),
                const SizedBox(height: 8),
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: cubit.setAmount,
                  decoration: InputDecoration(hintText: '0', suffixText: 'DA'),
                ),
                const SizedBox(height: 16),
                Text(l10n.category, style: AppText.headlineSm(context)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final category in cats)
                      ChoiceChip(
                        selected: state.categoryId == category.id,
                        onSelected: (_) => cubit.setCategory(category.id),
                        avatar: Icon(
                          CategoryStyle.icon(category.slug),
                          size: 16,
                          color: state.categoryId == category.id
                              ? AppColors.onPrimary
                              : AppColors.primary,
                        ),
                        label: Text(category.name),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event_outlined),
                  title: Text(l10n.today),
                  subtitle: Text(DateFormat.yMMMd(locale).format(date)),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 1)),
                    );
                    if (picked != null) {
                      cubit.setDate(picked);
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  onChanged: cubit.setNote,
                  maxLines: 2,
                  decoration: InputDecoration(labelText: l10n.noteOptional),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: state.saving ? null : cubit.save,
                  child: Text(state.saving ? l10n.preparing : l10n.save),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _typeChip(
    BuildContext context,
    String type,
    String label,
    bool selected,
  ) {
    return GestureDetector(
      onTap: () => context.read<AddTransactionCubit>().setType(type),
      child: Container(
        height: AppScale.of(context).buttonHeight + 8,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? (type == 'expense'
                    ? AppColors.expenseSoft
                    : AppColors.incomeSoft)
              : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: AppText.labelLg(context, color: AppColors.onSurface),
        ),
      ),
    );
  }
}
