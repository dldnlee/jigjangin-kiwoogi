import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:office_worker/application/game_controller.dart';
import 'package:office_worker/data/save_repository.dart';
import 'package:office_worker/domain/game.dart';
import 'package:office_worker/main.dart';

void main() {
  for (final width in [320.0, 390.0]) {
    testWidgets('coworker chat, memory, cooldown and coffee at $width', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, width == 320 ? 568 : 844);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final engine = GameEngine(
        GameContent(
          jsonDecode(File('assets/data/content.json').readAsStringSync())
              as Json,
        ),
      );
      final repo = SaveRepository(
        SaveDatabase(NativeDatabase.memory()),
        engine,
      );
      var now = 1000;
      final c = GameController.withDependencies(engine, repo, clock: () => now);
      c.state = GameState(lastMs: now)
        ..cash = BigInt.from(10000)
        ..reducedMotion = true;
      router.go(width == 320 ? '/office' : '/career');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [gameProvider.overrideWith((ref) => c)],
          child: const OfficeWorkerApp(),
        ),
      );
      await tester.pumpAndSettle();
      if (width == 320) {
        await tester.tap(find.text('업무 업그레이드'));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('동료와 가까워지기'));
      await tester.pumpAndSettle();
      expect(find.text('박 선배'), findsOneWidget);
      expect(find.text('친밀도 0/100 · 어색한 사이'), findsNWidgets(3));

      final chat = find.byKey(const ValueKey('chat-park-0'));
      await tester.ensureVisible(chat);
      await tester.tap(chat);
      await tester.pumpAndSettle();
      expect(c.state!.friendship('park'), 5);
      expect(find.text('친밀도 5/100 · 어색한 사이'), findsOneWidget);
      expect(find.text('"지난번 보고서, 결론부터 쓴 거 봤다."'), findsOneWidget);
      expect(find.textContaining('뒤에 다시 대화'), findsOneWidget);

      final coffee = find.byKey(const ValueKey('coffee-lee'));
      await tester.ensureVisible(coffee);
      await tester.tap(coffee);
      await tester.pumpAndSettle();
      expect(c.state!.friendship('lee'), 8);
      expect(c.state!.cash < BigInt.from(10000), isTrue);
      expect(tester.takeException(), isNull);

      final reloaded = (await repo.load()).state!;
      expect(reloaded.chatMemories, {'park': 'advice'});
      expect(reloaded.relationships, {'park': 5, 'lee': 8});
      await tester.pumpWidget(const SizedBox());
    });
  }
}
