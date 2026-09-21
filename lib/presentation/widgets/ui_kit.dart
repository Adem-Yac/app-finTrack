import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_scale.dart';
import 'package:fintrack/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class AppPage extends StatelessWidget {
  const AppPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scale = AppScale.of(context);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: scale.contentMax),
        child: child,
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size, this.circle = false});

  final double? size;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final dim = size ?? AppScale.of(context).logo;
    return Container(
      width: dim,
      height: dim,
      decoration: BoxDecoration(
        color: circle ? AppColors.logo : AppColors.primary,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(dim * 0.28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: dim * 0.45,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.all(dim * 0.2),
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
    );
  }
}

class FinIcon extends StatelessWidget {
  const FinIcon(
    this.icon, {
    super.key,
    this.box,
    this.size,
    this.color = AppColors.primary,
    this.background = const Color(0xFFE8F0EA),
  });

  final IconData icon;
  final double? box;
  final double? size;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final scale = AppScale.of(context);
    final dim = box ?? scale.categoryBox;
    return Container(
      width: dim,
      height: dim,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: size ?? scale.iconMd, color: color),
    );
  }
}

class FinCard extends StatelessWidget {
  const FinCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.elevated = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: elevated ? AppColors.floatShadow : AppColors.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

class BudgetBar extends StatelessWidget {
  const BudgetBar({super.key, required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    final color = percent >= 90 ? AppColors.errorSoft : AppColors.primary;
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: LinearProgressIndicator(
        minHeight: 8,
        value: (percent / 100).clamp(0, 1),
        backgroundColor: AppColors.outlineVariant,
        color: color,
      ),
    );
  }
}

class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: i == index ? AppColors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: i == index ? AppColors.cardShadow : null,
                  ),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: AppText.labelMd(
                      context,
                      color: i == index ? AppColors.primary : AppColors.muted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, this.income = false});

  final String label;
  final bool income;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: income ? AppColors.incomeSoft : AppColors.expenseSoft,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: AppText.labelSm(
          context,
          color: income ? AppColors.income : AppColors.errorSoft,
        ),
      ),
    );
  }
}

class EmptyHint extends StatelessWidget {
  const EmptyHint({
    super.key,
    required this.icon,
    required this.title,
    this.body,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
      child: Column(
        children: [
          Icon(icon, size: 36, color: AppColors.secondary),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppText.headlineSm(context),
          ),
          if (body != null) ...[
            const SizedBox(height: 6),
            Text(
              body!,
              textAlign: TextAlign.center,
              style: AppText.bodyMd(context),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 14),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

Future<T?> showFinSheet<T>({
  required BuildContext context,
  required Widget child,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          10,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: child,
      );
    },
  );
}

class LoadingHint extends StatelessWidget {
  const LoadingHint({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          ),
          const SizedBox(height: 12),
          Text(label, style: AppText.bodyMd(context)),
        ],
      ),
    );
  }
}
