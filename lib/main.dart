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
      statusBarColor: Color(0xff293e63),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xff111e34),
      systemNavigationBarIconBrightness: Brightness.light,
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
      scaffoldBackgroundColor: const Color(0xff111e34),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff293e63))
          .copyWith(
            primary: const Color(0xff293e63),
            secondary: const Color(0xffffd35a),
            surface: const Color(0xfffafbff),
            onSurface: const Color(0xff202c40),
            error: const Color(0xffc64b47),
          ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: 16,
          height: 1.4,
          color: Color(0xff202c40),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xfffafbff),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xff8592a6)),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xff293e63),
        behavior: SnackBarBehavior.floating,
      ),
    ),
  );
}
