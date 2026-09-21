import 'dart:async';

import 'package:fintrack/cubit/add_transaction/add_transaction_cubit.dart';
import 'package:fintrack/cubit/algeria/algeria_cubit.dart';
import 'package:fintrack/cubit/auth/auth_cubit.dart';
import 'package:fintrack/cubit/auth/auth_state.dart';
import 'package:fintrack/cubit/budgets/budgets_cubit.dart';
import 'package:fintrack/cubit/currency/currency_cubit.dart';
import 'package:fintrack/cubit/dashboard/dashboard_cubit.dart';
import 'package:fintrack/cubit/statistics/statistics_cubit.dart';
import 'package:fintrack/cubit/transactions/transactions_cubit.dart';
import 'package:fintrack/data/repositories/finance_repository.dart';
import 'package:fintrack/data/repositories/market_repository.dart';
import 'package:fintrack/presentation/screens/algeria/algeria_market_screen.dart';
import 'package:fintrack/presentation/screens/auth/sign_in_screen.dart';
import 'package:fintrack/presentation/screens/auth/sign_up_screen.dart';
import 'package:fintrack/presentation/screens/budgets/budgets_screen.dart';
import 'package:fintrack/presentation/screens/currency/currency_screen.dart';
import 'package:fintrack/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:fintrack/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:fintrack/presentation/screens/profile/profile_screen.dart';
import 'package:fintrack/presentation/screens/shell/main_shell.dart';
import 'package:fintrack/presentation/screens/splash/splash_screen.dart';
import 'package:fintrack/presentation/screens/statistics/statistics_screen.dart';
import 'package:fintrack/presentation/screens/transactions/add_transaction_screen.dart';
import 'package:fintrack/presentation/screens/transactions/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter createRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final auth = authCubit.state;
      final location = state.matchedLocation;
      const public = {
        '/splash',
        '/onboarding',
        '/login',
        '/register',
        '/forgot-password',
      };

      if (auth is AuthInitial) {
        return location == '/splash' ? null : '/splash';
      }

      if (auth is AuthLoading) {
        return location == '/splash' || location == '/onboarding'
            ? null
            : '/splash';
      }

      if (auth is AuthAuthenticated) {
        if (location == '/splash' ||
            location == '/login' ||
            location == '/register' ||
            location == '/onboarding' ||
            location == '/forgot-password') {
          return '/dashboard';
        }
        return null;
      }

      if (auth is AuthUnauthenticated) {
        if (!auth.onboardingSeen &&
            (location == '/splash' || location == '/onboarding')) {
          return null;
        }
        if (location == '/splash' || location == '/onboarding') {
          return '/login';
        }
        if (public.contains(location)) {
          return null;
        }
        return '/login';
      }

      if (auth is AuthFailure) {
        if (public.contains(location)) {
          return null;
        }
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              AddTransactionCubit(context.read<FinanceRepository>())..load(),
          child: const AddTransactionScreen(),
        ),
      ),
      GoRoute(
        path: '/transactions/:id',
        builder: (context, state) =>
            TransactionDetailScreen(id: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/budgets/:id',
        builder: (context, state) =>
            BudgetDetailScreen(id: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/goals/:id',
        builder: (context, state) =>
            GoalDetailScreen(id: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/currency',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              CurrencyCubit(context.read<MarketRepository>())..load(),
          child: const CurrencyScreen(),
        ),
      ),
      GoRoute(
        path: '/algeria',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              AlgeriaCubit(context.read<MarketRepository>())..load(),
          child: const AlgeriaMarketScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      DashboardCubit(context.read<FinanceRepository>())..load(),
                  child: const DashboardScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      TransactionsCubit(context.read<FinanceRepository>())
                        ..load(),
                  child: const TransactionsScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/budgets',
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      BudgetsCubit(context.read<FinanceRepository>())..load(),
                  child: const BudgetsScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/statistics',
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      StatisticsCubit(context.read<FinanceRepository>())
                        ..load(),
                  child: const StatisticsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
