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
import 'package:office_worker/ui/pixel_widgets.dart';

void main() {
  testWidgets('progress fill has visible height and tracks completion', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(child: SizedBox(width: 200, child: PixelMeter(.5))),
      ),
    );
    final fill = find
        .descendant(
          of: find.byType(PixelMeter),
          matching: find.byType(ColoredBox),
        )
        .last;
    expect(tester.getSize(fill).height, greaterThan(0));
    expect(tester.getSize(fill).width, closeTo(97, 1));
    await tester.pumpWidget(const SizedBox());
  });
  for (final width in [320.0, 390.0]) {
    testWidgets('project start, reload, collection and journal at $width', (
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
        await tester.tap(find.text('프로젝트로 성과 쌓기'));
      } else {
        await tester.tap(find.byTooltip('프로젝트'));
      }
      await tester.pumpAndSettle();
      expect(find.text('금요일 발표'), findsOneWidget);
      expect(find.text('금요일 발표 완료 후 열려요.'), findsOneWidget);
      final start = find.byKey(const ValueKey('start-presentation-0'));
      await tester.ensureVisible(start);
      await tester.tap(start);
      await tester.pumpAndSettle();
      expect(c.state!.activeProject?.projectId, 'presentation');
      expect(find.text('준비 중이에요'), findsOneWidget);
      expect(tester.takeException(), isNull);
      // A real repository reload preserves the choice and deadline.
      final loaded = await repo.load();
      expect(loaded.state!.activeProject!.approachId, 'solo');
      c.state = loaded.state;
      now += 180000;
      await c.save(away: true);
      await tester.pumpAndSettle();
      await tester.tap(find.text('계속하기'));
      await tester.pumpAndSettle();
      final claim = find.text('결과 확인 · 보상 받기');
      await tester.ensureVisible(claim);
      await tester.tap(claim);
      await tester.pumpAndSettle();
      expect(c.state!.completedProjects, ['presentation']);
      expect(c.state!.skills['expertise'], 1);
      expect(find.text('완료 · 결과는 일지에 남겼어요.'), findsOneWidget);
      expect(find.byKey(const ValueKey('start-report-0')), findsOneWidget);
      expect(c.state!.journal.first['text'], contains('성공'));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
