import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_scale.dart';
import 'package:fintrack/core/theme/app_text.dart';
import 'package:fintrack/cubit/locale/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key, this.compact = false});

  final bool compact;

  static const options = [
    (Locale('ar'), 'العربية'),
    (Locale('fr'), 'Français'),
    (Locale('en'), 'English'),
  ];

  @override
  Widget build(BuildContext context) {
    final current = context.watch<LocaleCubit>().state;
    final scale = AppScale.of(context);
    if (compact) {
      return Row(
        children: [
          for (final option in options)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _chip(context, option, current, scale.buttonHeight - 8),
              ),
            ),
        ],
      );
    }
    return Column(
      children: [
        for (final option in options)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _chip(context, option, current, scale.buttonHeight),
          ),
      ],
    );
  }

  Widget _chip(
    BuildContext context,
    (Locale, String) option,
    Locale current,
    double height,
  ) {
    final selected = current.languageCode == option.$1.languageCode;
    return Material(
      color: selected ? AppColors.primary : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.read<LocaleCubit>().setLocale(option.$1),
        child: SizedBox(
          height: height,
          child: Center(
            child: Text(
              option.$2,
              style: AppText.labelMd(
                context,
                color: selected ? AppColors.onPrimary : AppColors.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
