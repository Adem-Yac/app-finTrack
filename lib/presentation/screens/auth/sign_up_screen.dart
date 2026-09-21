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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool obscure = true;
  bool accepted = true;
  bool submitting = false;

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    email.dispose();
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
                    title: l10n.imNew,
                    onBack: () => context.go('/login'),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.registerHeadline,
                    style: AppText.headlineXl(context),
                  ),
                  const SizedBox(height: 6),
                  Text(l10n.registerHint, style: AppText.bodyMd(context)),
                  const SizedBox(height: 24),
                  Text(
                    l10n.yourName,
                    style: AppText.labelMd(context, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 8),
                  SoftField(
                    controller: name,
                    hint: l10n.nameHint,
                    prefix: Icon(
                      Icons.person_outline,
                      size: scale.iconMd,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.phone,
                    style: AppText.labelMd(context, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 8),
                  SoftField(
                    controller: phone,
                    hint: '05 50 12 34 56',
                    keyboardType: TextInputType.phone,
                    prefix: Icon(
                      Icons.phone_outlined,
                      size: scale.iconMd,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.email,
                    style: AppText.labelMd(context, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 8),
                  SoftField(
                    controller: email,
                    hint: l10n.identifierHint,
                    keyboardType: TextInputType.emailAddress,
                    prefix: Icon(
                      Icons.mail_outline,
                      size: scale.iconMd,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.passwordCode,
                    style: AppText.labelMd(context, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 8),
                  SoftField(
                    controller: password,
                    hint: l10n.password,
                    obscure: obscure,
                    prefix: Icon(
                      Icons.lock_outline,
                      size: scale.iconMd,
                      color: AppColors.secondary,
                    ),
                    suffix: TextButton(
                      onPressed: () => setState(() => obscure = !obscure),
                      child: Text(obscure ? l10n.show : l10n.hide),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(l10n.dinar, style: AppText.bodySm(context)),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: accepted,
                        onChanged: (value) =>
                            setState(() => accepted = value ?? false),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            l10n.terms,
                            style: AppText.bodySm(
                              context,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ForestButton(
                    label: submitting ? l10n.preparing : l10n.createAccount,
                    onPressed: !accepted || submitting ? null : _submit,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: submitting ? null : _google,
                    child: Text(l10n.continueWithGoogle),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(l10n.loginDirect),
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
    final l10n = AppLocalizations.of(context)!;
    final trimmedName = name.text.trim();
    final trimmedPhone = phone.text.trim();
    final trimmedEmail = email.text.trim();
    if (trimmedName.isEmpty || password.text.length < 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.requiredLabel)));
      return;
    }
    if (trimmedPhone.isEmpty && trimmedEmail.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.identifier)));
      return;
    }
    setState(() => submitting = true);
    await context.read<AuthCubit>().register(
      name: trimmedName,
      email: trimmedEmail.isEmpty ? null : trimmedEmail,
      phone: trimmedPhone.isEmpty ? null : trimmedPhone,
      password: password.text,
    );
    if (mounted) {
      setState(() => submitting = false);
    }
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final email = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scale = AppScale.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(l10n.forgotPassword, style: AppText.headlineSm(context)),
      ),
      body: AppPage(
        child: Padding(
          padding: EdgeInsets.all(scale.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.email,
                style: AppText.labelMd(context, color: AppColors.onSurface),
              ),
              const SizedBox(height: 8),
              SoftField(controller: email, hint: l10n.email),
              const SizedBox(height: 20),
              ForestButton(
                label: l10n.sendLink,
                onPressed: () async {
                  await context.read<AuthCubit>().forgotPassword(
                    email.text.trim(),
                  );
                  if (context.mounted) context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
