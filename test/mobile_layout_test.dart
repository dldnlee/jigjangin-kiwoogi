import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:office_worker/application/game_controller.dart';
import 'package:office_worker/data/save_repository.dart';
import 'package:office_worker/domain/game.dart';
import 'package:office_worker/main.dart';

void main() {
  testWidgets('all mobile screens fit at 320 and 390 logical pixels', (
    tester,
  ) async {
    final font=FontLoader('NeoDunggeunmo')..addFont(rootBundle.load('assets/fonts/neodgm.ttf'));
    await font.load();
    final engine = GameEngine(
      GameContent(
        jsonDecode(File('assets/data/content.json').readAsStringSync()) as Json,
      ),
    );
    final repo = SaveRepository(SaveDatabase(NativeDatabase.memory()), engine);
    final c = GameController.withDependencies(engine, repo);
    c.state = GameState(lastMs: 1000)..reducedMotion = true;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final width in [320.0, 390.0]) {
      tester.view.physicalSize = Size(width, 844);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [gameProvider.overrideWith((ref) => c)],
          child: const RepaintBoundary(
            key: ValueKey('capture'),
            child: OfficeWorkerApp(),
          ),
        ),
      );
      for (final page in [
        'office',
        'career',
        'skills',
        'equipment',
        'journal',
      ]) {
        router.go('/$page');
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$page at $width');
      }
    }
    router.go('/office');
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 600));
    });
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const ValueKey('capture')),
      matchesGoldenFile('goldens/mobile-office.png'),
    );
    for (final level in [6, 11, 16]) {
      c.state = c.state!.copy()..level = level;
      c.notifyListeners();
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(const ValueKey('capture')),
        matchesGoldenFile('goldens/office-level-$level.png'),
      );
    }
    await tester.pumpWidget(const SizedBox());
  });
}
