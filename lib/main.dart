import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:instakarm/app_shell/app.dart';
import 'package:instakarm/core/data/models/daily_task_log.dart';
import 'package:instakarm/core/data/models/user_profile.dart';
import 'package:instakarm/features/onboarding/data/repositories/hive_user_profile_repository.dart';

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(DailyTaskLogAdapter());

  // Initialize Repositories
  await HiveUserProfileRepository().init();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
