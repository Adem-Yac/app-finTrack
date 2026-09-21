import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_scale.dart';
import 'package:fintrack/core/theme/app_text.dart';
import 'package:fintrack/core/utils/category_style.dart';
import 'package:fintrack/core/utils/money_format.dart';
import 'package:fintrack/data/models/transaction_model.dart';
import 'package:fintrack/presentation/widgets/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.onTap});

  final TransactionModel transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scale = AppScale.of(context);
    final slug = transaction.category?.slug;
    final positive = transaction.isIncome;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: scale.tileHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              FinIcon(
                CategoryStyle.icon(slug),
                background: CategoryStyle.tint(slug),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.note ?? transaction.category?.name ?? '—',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.labelLg(context),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat(
                        'dd MMM',
                        Localizations.localeOf(context).toString(),
                      ).format(transaction.occurredOn),
                      style: AppText.bodySm(context),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MoneyText(
                    positive ? transaction.amount : -transaction.amount,
                    withSign: true,
                    color: positive ? AppColors.income : AppColors.errorSoft,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
