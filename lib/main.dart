// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'presentation/navigation/app_router.dart';
import 'presentation/providers/auth_provider.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: CotopaxiAirlinesApp()));
}

class CotopaxiAirlinesApp extends ConsumerStatefulWidget {
  const CotopaxiAirlinesApp({super.key});

  @override
  ConsumerState<CotopaxiAirlinesApp> createState() => _CotopaxiAirlinesAppState();
}

class _CotopaxiAirlinesAppState extends ConsumerState<CotopaxiAirlinesApp> {
  @override
  void initState() {
    super.initState();
    // Check if there's a saved token on startup
    Future.microtask(() => ref.read(authProvider.notifier).checkAuth());
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Cotopaxi Airlines',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }
}