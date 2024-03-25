import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/services/notification_service.dart';
import 'core/services/sync_service.dart';
import 'core/services/ai_service.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/tasks/presentation/providers/tasks_provider.dart';
import 'features/projects/presentation/providers/projects_provider.dart';
import 'features/team/presentation/providers/team_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize services
  await NotificationService.initialize();
  await SyncService.initialize();
  await AIService.initialize();
  
  runApp(
    const ProviderScope(
      child: TaskManagerApp(),
    ),
  );
}

class TaskManagerApp extends ConsumerWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
