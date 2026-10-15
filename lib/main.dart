import 'package:flutter/material.dart';

import 'screens/main_navigation.dart';
import 'services/api_client.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ExpenseTrackerApp(useBackend: true));
}

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({super.key, this.useBackend = false});

  final bool useBackend;

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState(
      apiClient: widget.useBackend ? ApiClient() : null,
    );
    if (widget.useBackend) {
      _appState.loadFromApi();
    }
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: _appState,
      child: AnimatedBuilder(
        animation: _appState,
        builder: (context, _) {
          return MaterialApp(
            title: 'Lumen Finance',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: _appState.themeMode,
            home: const MainNavigation(),
          );
        },
      ),
    );
  }
}
