import 'dart:async';

import 'package:fintrack/core/router/app_router.dart';
import 'package:fintrack/core/theme/app_theme.dart';
import 'package:fintrack/cubit/auth/auth_cubit.dart';
import 'package:fintrack/cubit/auth/auth_state.dart';
import 'package:fintrack/cubit/locale/locale_cubit.dart';
import 'package:fintrack/cubit/notifications/notifications_cubit.dart';
import 'package:fintrack/data/local/local_cache.dart';
import 'package:fintrack/data/local/token_storage.dart';
import 'package:fintrack/data/repositories/auth_repository.dart';
import 'package:fintrack/data/repositories/finance_repository.dart';
import 'package:fintrack/data/repositories/market_repository.dart';
import 'package:fintrack/data/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class FinTrackApp extends StatefulWidget {
  const FinTrackApp({super.key});

  @override
  State<FinTrackApp> createState() => _FinTrackAppState();
}

class _FinTrackAppState extends State<FinTrackApp> {
  late final AuthCubit _authCubit;
  late final LocaleCubit _localeCubit;
  late final NotificationsCubit _notificationsCubit;
  late final GoRouter _router;
  late final AuthRepository _authRepository;
  late final FinanceRepository _financeRepository;
  late final MarketRepository _marketRepository;
  StreamSubscription<AuthState>? _authSub;

  @override
  void initState() {
    super.initState();
    final tokens = TokenStorage();
    final api = ApiClient(tokens);
    final cache = LocalCache();
    _authRepository = AuthRepository(api, tokens);
    _financeRepository = FinanceRepository(api, cache);
    _marketRepository = MarketRepository(api, cache);
    _localeCubit = LocaleCubit()..load();
    _authCubit = AuthCubit(_authRepository)..bootstrap();
    _notificationsCubit = NotificationsCubit(_financeRepository);
    api.onUnauthorized = _authCubit.expireSession;
    _router = createRouter(_authCubit);
    _authSub = _authCubit.stream.listen((state) {
      if (state is AuthAuthenticated) {
        _notificationsCubit.load();
      } else {
        _notificationsCubit.clear();
      }
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authRepository),
        RepositoryProvider.value(value: _financeRepository),
        RepositoryProvider.value(value: _marketRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _authCubit),
          BlocProvider.value(value: _localeCubit),
          BlocProvider.value(value: _notificationsCubit),
        ],
        child: BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp.router(
              title: 'FinTrack',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(locale),
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (context, child) {
                final mq = MediaQuery.of(context);
                return MediaQuery(
                  data: mq.copyWith(
                    textScaler: mq.textScaler.clamp(
                      minScaleFactor: 0.95,
                      maxScaleFactor: 1.2,
                    ),
                  ),
                  child: child ?? const SizedBox.shrink(),
                );
              },
              routerConfig: _router,
            );
          },
        ),
      ),
    );
  }
}
