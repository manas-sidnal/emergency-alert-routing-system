import 'package:flutter/material.dart';
import 'state/system_state.dart';
import 'theme/app_theme.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const EmergencyAlertApp());
}

/// Root application widget.
///
/// Provides [SystemState] via [SystemStateProvider] to the entire widget tree.
class EmergencyAlertApp extends StatefulWidget {
  const EmergencyAlertApp({super.key});

  @override
  State<EmergencyAlertApp> createState() => _EmergencyAlertAppState();
}

class _EmergencyAlertAppState extends State<EmergencyAlertApp> {
  // Single instance of SystemState shared across the app.
  final SystemState _systemState = SystemState();

  @override
  void dispose() {
    _systemState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SystemStateProvider(
      state: _systemState,
      child: MaterialApp(
        title: 'Emergency Alert Routing System',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const HomeScreen(),
      ),
    );
  }
}
