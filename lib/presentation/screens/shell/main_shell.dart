import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_scale.dart';
import 'package:fintrack/core/theme/app_text.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scale = AppScale.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Material(
        color: AppColors.white,
        elevation: 0,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.outlineVariant)),
          ),
          child: SafeArea(
            child: SizedBox(
              height: scale.navHeight,
              child: Row(
                children: [
                  _item(
                    context,
                    0,
                    Icons.home_outlined,
                    Icons.home_rounded,
                    l10n.home,
                  ),
                  _item(
                    context,
                    1,
                    Icons.receipt_long_outlined,
                    Icons.receipt_long_rounded,
                    l10n.history,
                  ),
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        onTap: () => context.push('/add'),
                        child: Container(
                          width: scale.isTablet ? 56 : 50,
                          height: scale.isTablet ? 56 : 50,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: AppColors.floatShadow,
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: scale.fabIcon,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _item(
                    context,
                    2,
                    Icons.pie_chart_outline_rounded,
                    Icons.pie_chart_rounded,
                    l10n.budgets,
                  ),
                  _item(
                    context,
                    3,
                    Icons.bar_chart_rounded,
                    Icons.bar_chart_rounded,
                    l10n.stats,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    int index,
    IconData idle,
    IconData active,
    String label,
  ) {
    final scale = AppScale.of(context);
    final selected = navigationShell.currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => navigationShell.goBranch(index, initialLocation: selected),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? active : idle,
              size: scale.navIcon,
              color: selected ? AppColors.primary : AppColors.muted,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.labelSm(
                context,
                color: selected ? AppColors.primary : AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
