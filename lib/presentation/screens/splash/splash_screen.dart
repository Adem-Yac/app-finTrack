import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_scale.dart';
import 'package:fintrack/core/theme/app_text.dart';
import 'package:fintrack/cubit/auth/auth_cubit.dart';
import 'package:fintrack/cubit/auth/auth_state.dart';
import 'package:fintrack/presentation/widgets/language_picker.dart';
import 'package:fintrack/presentation/widgets/stitch.dart';
import 'package:fintrack/presentation/widgets/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scale = AppScale.of(context);
    final showActions = context.watch<AuthCubit>().state is AuthUnauthenticated;
    final logo = scale.isTablet ? 120.0 : 96.0;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: AppPage(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              scale.pagePadding,
              16,
              scale.pagePadding,
              20,
            ),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: SoftPill(label: l10n.algeriaBadge, dot: true),
                ),
                const Spacer(flex: 2),
                BrandMark(size: logo, circle: false),
                const SizedBox(height: 20),
                Text(l10n.appName, style: AppText.headlineXl(context)),
                const SizedBox(height: 8),
                Text(
                  l10n.tagline,
                  textAlign: TextAlign.center,
                  style: AppText.bodyMd(context),
                ),
                const SizedBox(height: 24),
                const LanguagePicker(compact: true),
                const Spacer(flex: 3),
                if (!showActions)
                  LoadingHint(label: l10n.preparing)
                else ...[
                  ForestButton(
                    label: l10n.connect,
                    onPressed: () async {
                      await context.read<AuthCubit>().completeOnboarding();
                      if (context.mounted) context.go('/login');
                    },
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () async {
                      await context.read<AuthCubit>().completeOnboarding();
                      if (context.mounted) context.go('/register');
                    },
                    child: Text(l10n.imNew),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  l10n.footerSecure,
                  textAlign: TextAlign.center,
                  style: AppText.bodySm(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
