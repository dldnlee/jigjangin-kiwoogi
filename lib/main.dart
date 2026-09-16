import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'ui/game_screen.dart';

final router = GoRouter(
  initialLocation: '/office',
  routes: [
    for (final route in ['office', 'career', 'skills', 'equipment', 'journal'])
      GoRoute(
        path: '/$route',
        builder: (context, state) => GameScreen(page: route),
      ),
  ],
);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xfff2eedb),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const ProviderScope(child: OfficeWorkerApp()));
}

class OfficeWorkerApp extends StatelessWidget {
  const OfficeWorkerApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    title: '직장인 키우기',
    routerConfig: router,
    locale: const Locale('ko'),
    supportedLocales: const [Locale('ko')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'NeoDunggeunmo',
      scaffoldBackgroundColor: const Color(0xfff7f0dc),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff48684a)),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: 16,
          height: 1.4,
          color: Color(0xff38463a),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xff384c3b),
        behavior: SnackBarBehavior.floating,
      ),
    ),
  );
}
