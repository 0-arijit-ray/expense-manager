import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router.dart';
import 'core/settings.dart';
import 'core/theme.dart';
import 'data/providers.dart';
import 'features/loans/loans_providers.dart';

class ExpenseManagerApp extends ConsumerStatefulWidget {
  const ExpenseManagerApp({super.key});

  @override
  ConsumerState<ExpenseManagerApp> createState() => _ExpenseManagerAppState();
}

class _ExpenseManagerAppState extends ConsumerState<ExpenseManagerApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _runAutomation());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Catch up automated postings whenever the app is resumed.
    if (state == AppLifecycleState.resumed) _runAutomation();
  }

  Future<void> _runAutomation() async {
    final posted = await ref.read(recurringEngineProvider).run();
    if (posted > 0) {
      ref.invalidate(loanSummariesProvider);
      ref.invalidate(upcomingEmisProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(settingsProvider).themeMode;
    return MaterialApp.router(
      title: 'Ease Your Finance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
