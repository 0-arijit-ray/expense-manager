import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/dashboard/dashboard_screen.dart';
import '../features/expenses/expenses_screen.dart';
import '../features/investments/investments_screen.dart';
import '../features/loans/loan_detail_screen.dart';
import '../features/loans/loans_screen.dart';
import '../features/networth/networth_screen.dart';
import '../features/recurring/recurring_screen.dart';
import '../features/settings/settings_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/dashboard',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _ScaffoldWithNav(shell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/dashboard',
            builder: (_, _) => const DashboardScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/expenses',
            builder: (_, _) => const ExpensesScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/loans',
            builder: (_, _) => const LoansScreen(),
            routes: [
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootKey,
                builder: (_, state) => LoanDetailScreen(
                  loanId: int.parse(state.pathParameters['id']!),
                ),
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/investments',
            builder: (_, _) => const InvestmentsScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/networth',
            builder: (_, _) => const NetWorthScreen(),
          ),
        ]),
      ],
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootKey,
      builder: (_, _) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/recurring',
      parentNavigatorKey: _rootKey,
      builder: (_, _) => const RecurringScreen(),
    ),
  ],
);

class _ScaffoldWithNav extends StatelessWidget {
  final StatefulNavigationShell shell;
  const _ScaffoldWithNav({required this.shell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(
          i,
          initialLocation: i == shell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: 'Expenses'),
          NavigationDestination(
              icon: Icon(Icons.account_balance_outlined),
              selectedIcon: Icon(Icons.account_balance),
              label: 'Loans'),
          NavigationDestination(
              icon: Icon(Icons.savings_outlined),
              selectedIcon: Icon(Icons.savings),
              label: 'Invest'),
          NavigationDestination(
              icon: Icon(Icons.pie_chart_outline),
              selectedIcon: Icon(Icons.pie_chart),
              label: 'Net worth'),
        ],
      ),
    );
  }
}
