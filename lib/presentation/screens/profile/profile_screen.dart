import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_scale.dart';
import 'package:fintrack/core/theme/app_text.dart';
import 'package:fintrack/cubit/auth/auth_cubit.dart';
import 'package:fintrack/cubit/auth/auth_state.dart';
import 'package:fintrack/cubit/notifications/notifications_cubit.dart';
import 'package:fintrack/cubit/shared/simple_state.dart';
import 'package:fintrack/data/models/notification_model.dart';
import 'package:fintrack/presentation/widgets/language_picker.dart';
import 'package:fintrack/presentation/widgets/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scale = AppScale.of(context);
    final auth = context.watch<AuthCubit>().state;
    final user = auth is AuthAuthenticated ? auth.user : null;
    final initials = (user?.firstName.isNotEmpty ?? false)
        ? user!.firstName.characters.first.toUpperCase()
        : 'F';

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/dashboard'),
          icon: Icon(Icons.arrow_back_rounded, size: scale.iconLg),
        ),
        title: Text(l10n.me, style: AppText.headlineSm(context)),
      ),
      body: AppPage(
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
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    initials,
                    style: AppText.headlineLg(context, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? '',
                        style: AppText.headlineMd(context),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? user?.phone ?? '',
                        style: AppText.bodyMd(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(l10n.language, style: AppText.headlineSm(context)),
            const SizedBox(height: 10),
            const LanguagePicker(compact: true),
            const SizedBox(height: 24),
            Text(l10n.dinar, style: AppText.headlineSm(context)),
            const SizedBox(height: 8),
            _ProfileLink(
              icon: Icons.flag_outlined,
              label: l10n.algeriaMarket,
              onTap: () => context.push('/algeria'),
            ),
            _ProfileLink(
              icon: Icons.currency_exchange_rounded,
              label: l10n.rates,
              onTap: () => context.push('/currency'),
            ),
            _ProfileLink(
              icon: Icons.notifications_none_rounded,
              label: l10n.notifications,
              onTap: () => context.push('/notifications'),
            ),
            const SizedBox(height: 28),
            OutlinedButton(
              onPressed: () => context.read<AuthCubit>().logout(),
              child: Text(l10n.logout),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileLink extends StatelessWidget {
  const _ProfileLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: AppScale.of(context).iconMd,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppText.labelLg(context))),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.muted,
              size: AppScale.of(context).iconLg,
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => const ProfileScreen();
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scale = AppScale.of(context);
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(l10n.notifications, style: AppText.headlineSm(context)),
        actions: [
          TextButton(
            onPressed: () => context.read<NotificationsCubit>().markAllRead(),
            child: Text(l10n.markAllRead),
          ),
        ],
      ),
      body: AppPage(
        child: RefreshIndicator(
          onRefresh: () => context.read<NotificationsCubit>().load(),
          child:
              BlocBuilder<
                NotificationsCubit,
                SimpleLoadState<NotificationInbox>
              >(
                builder: (context, state) {
                  if (state is SimpleLoading<NotificationInbox>) {
                    return ListView(
                      children: [
                        const SizedBox(height: 120),
                        LoadingHint(label: l10n.preparing),
                      ],
                    );
                  }
                  if (state is SimpleFailure<NotificationInbox>) {
                    return ListView(
                      children: [
                        EmptyHint(
                          icon: Icons.wifi_off_rounded,
                          title: l10n.retry,
                          body: state.message,
                          actionLabel: l10n.retry,
                          onAction: () =>
                              context.read<NotificationsCubit>().load(),
                        ),
                      ],
                    );
                  }
                  final inbox = (state as SimpleLoaded<NotificationInbox>).data;
                  if (inbox.items.isEmpty) {
                    return ListView(
                      children: [
                        EmptyHint(
                          icon: Icons.notifications_none_rounded,
                          title: l10n.noNotifications,
                          body: l10n.noNotificationsBody,
                        ),
                      ],
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      scale.pagePadding,
                      8,
                      scale.pagePadding,
                      28,
                    ),
                    itemCount: inbox.items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = inbox.items[index];
                      return InkWell(
                        onTap: item.isUnread
                            ? () => context.read<NotificationsCubit>().markRead(
                                item.id,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(16),
                        child: FinCard(
                          color: item.isUnread
                              ? AppColors.incomeSoft
                              : AppColors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                _iconFor(item.type),
                                color: AppColors.primary,
                                size: scale.iconLg,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: AppText.labelLg(context),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.body,
                                      style: AppText.bodyMd(context),
                                    ),
                                    if (item.createdAt != null) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        DateFormat.yMMMd(locale)
                                            .add_Hm()
                                            .format(item.createdAt!.toLocal()),
                                        style: AppText.labelSm(context),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (item.isUnread)
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(
                                    top: 6,
                                    left: 8,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: AppColors.logo,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
        ),
      ),
    );
  }

  IconData _iconFor(String type) {
    return switch (type) {
      'warning' => Icons.warning_amber_rounded,
      'success' => Icons.verified_rounded,
      _ => Icons.info_outline_rounded,
    };
  }
}
