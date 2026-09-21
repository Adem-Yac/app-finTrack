import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_scale.dart';
import 'package:fintrack/core/theme/app_text.dart';
import 'package:fintrack/cubit/notifications/notifications_cubit.dart';
import 'package:fintrack/cubit/shared/simple_state.dart';
import 'package:fintrack/data/models/notification_model.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:fintrack/presentation/widgets/stitch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class FinHeader extends StatelessWidget {
  const FinHeader({super.key, this.subtitle});

  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final scale = AppScale.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(scale.pagePadding, 8, scale.pagePadding, 8),
      child: Row(
        children: [
          const BrandMark(size: 36, circle: false),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FinTrack', style: AppText.headlineSm(context)),
                Text(subtitle ?? l10n.wealth, style: AppText.labelSm(context)),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => context.push('/notifications'),
            icon:
                BlocBuilder<
                  NotificationsCubit,
                  SimpleLoadState<NotificationInbox>
                >(
                  builder: (context, state) {
                    final unread = state is SimpleLoaded<NotificationInbox>
                        ? state.data.unreadCount
                        : 0;
                    return Badge(
                      isLabelVisible: unread > 0,
                      backgroundColor: AppColors.errorSoft,
                      label: Text(unread > 9 ? '9+' : '$unread'),
                      child: Icon(
                        Icons.notifications_none_rounded,
                        size: scale.iconLg,
                        color: AppColors.onSurfaceVariant,
                      ),
                    );
                  },
                ),
          ),
          GestureDetector(
            onTap: () => context.push('/profile'),
            child: CircleAvatar(
              radius: scale.avatar,
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: scale.iconMd,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GreetingRow extends StatelessWidget {
  const GreetingRow({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scale = AppScale.of(context);
    final locale = Localizations.localeOf(context).toString();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: scale.pagePadding),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.hello(name), style: AppText.headlineLg(context)),
                const SizedBox(height: 4),
                Text(
                  DateFormat.yMMMMd(locale).format(DateTime.now()),
                  style: AppText.bodySm(context),
                ),
              ],
            ),
          ),
          SoftPill(
            label: l10n.verified,
            icon: Icons.verified_rounded,
            color: AppColors.income,
            background: AppColors.incomeSoft,
          ),
        ],
      ),
    );
  }
}
