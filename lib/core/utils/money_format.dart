import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoneyFormat {
  static NumberFormat _number(BuildContext? context) {
    final locale = context == null
        ? 'fr'
        : Localizations.localeOf(context).toString();
    return NumberFormat.decimalPattern(locale);
  }

  static String number(num value, [BuildContext? context]) {
    return _number(context).format(value.round());
  }

  static String da(num value, {bool withSign = false, BuildContext? context}) {
    final formatted = _number(context).format(value.abs().round());
    if (!withSign) {
      return '$formatted DA';
    }
    final sign = value > 0 ? '+' : (value < 0 ? '-' : '');
    return '$sign $formatted DA';
  }

  static String compact(num value, [BuildContext? context]) {
    if (value.abs() >= 1000) {
      final k = value / 1000;
      final text = k == k.roundToDouble()
          ? k.toStringAsFixed(0)
          : k.toStringAsFixed(1);
      return '${text.replaceAll('.', ',')}k';
    }
    return _number(context).format(value.round());
  }
}

class MoneyText extends StatelessWidget {
  const MoneyText(
    this.value, {
    super.key,
    this.hero = false,
    this.withSign = false,
    this.color,
    this.align = TextAlign.start,
  });

  final num value;
  final bool hero;
  final bool withSign;
  final Color? color;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final amount = MoneyFormat.number(value.abs(), context);
    final sign = withSign ? (value > 0 ? '+' : (value < 0 ? '-' : '')) : '';
    return Text.rich(
      TextSpan(
        children: [
          if (sign.isNotEmpty) TextSpan(text: '$sign '),
          TextSpan(text: amount),
          TextSpan(
            text: ' DA',
            style: AppText.labelMd(
              context,
              color: color ?? AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
      textAlign: align,
      style: AppText.amount(context, color: color, hero: hero),
    );
  }
}
