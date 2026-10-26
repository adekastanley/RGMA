import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/navigation/main_shell.dart';
import 'services/mock_data_service.dart';
import 'state/learning_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // NOTE FOR BACKEND INTEGRATION:
  // Swap `const MockRhemaApiService()` with `const RemoteRhemaApiService(authToken: '...')`
  // once the endpoints in `lib/services/api_service.dart` are connected.
  final learningController = LearningController(
    apiService: const MockRhemaApiService(),
  );

  runApp(RhemaGoApp(controller: learningController));
}

class RhemaGoApp extends StatelessWidget {
  final LearningController controller;

  const RhemaGoApp({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rhema Go',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: MainShell(controller: controller),
    );
  }
}
