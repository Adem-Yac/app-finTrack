import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_scale.dart';
import 'package:fintrack/core/theme/app_text.dart';
import 'package:fintrack/cubit/auth/auth_cubit.dart';
import 'package:fintrack/cubit/auth/auth_state.dart';
import 'package:fintrack/presentation/widgets/stitch.dart';
import 'package:fintrack/presentation/widgets/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final identifier = TextEditingController();
  final password = TextEditingController();
  bool obscure = true;
  bool submitting = false;

  @override
  void dispose() {
    identifier.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scale = AppScale.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              setState(() => submitting = false);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is AuthAuthenticated) {
              setState(() => submitting = false);
            }
          },
          builder: (context, state) {
            return AppPage(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  scale.pagePadding,
                  8,
                  scale.pagePadding,
                  28,
                ),
                children: [
                  AuthHeaderBar(
                    title: l10n.connect,
                    onBack: () => context.go('/splash'),
                  ),
                  const SizedBox(height: 28),
                  Text(l10n.loginTitle, style: AppText.headlineXl(context)),
                  const SizedBox(height: 6),
                  Text(l10n.loginSubtitle, style: AppText.bodyMd(context)),
                  const SizedBox(height: 28),
                  Text(
                    l10n.identifier,
                    style: AppText.labelMd(context, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 8),
                  SoftField(
                    controller: identifier,
                    hint: l10n.identifierHint,
                    keyboardType: TextInputType.emailAddress,
                    prefix: Icon(
                      Icons.phone_outlined,
                      size: scale.iconMd,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.password,
                    style: AppText.labelMd(context, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 8),
                  SoftField(
                    controller: password,
                    obscure: obscure,
                    prefix: Icon(
                      Icons.lock_outline_rounded,
                      size: scale.iconMd,
                      color: AppColors.secondary,
                    ),
                    suffix: IconButton(
                      onPressed: () => setState(() => obscure = !obscure),
                      icon: Icon(
                        obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: scale.iconMd,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: Text(l10n.forgotPassword),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ForestButton(
                    label: submitting ? l10n.preparing : l10n.connect,
                    onPressed: submitting ? null : _submit,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: submitting ? null : _google,
                    child: Text(l10n.continueWithGoogle),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.go('/register'),
                    child: Text(l10n.noAccount),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _google() async {
    setState(() => submitting = true);
    await context.read<AuthCubit>().google();
    if (mounted) {
      setState(() => submitting = false);
    }
  }

  Future<void> _submit() async {
    final id = identifier.text.trim();
    final pass = password.text;
    if (id.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.identifier)),
      );
      return;
    }
    setState(() => submitting = true);
    await context.read<AuthCubit>().login(id, pass);
    if (mounted) {
      setState(() => submitting = false);
    }
  }
}
