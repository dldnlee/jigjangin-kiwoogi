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
import 'package:office_worker/ui/office_scene.dart';
import 'package:office_worker/ui/pixel_widgets.dart';

void main() {
  for (final width in [320.0, 390.0]) {
    testWidgets('decoration previews, locks, applies and reloads at $width', (
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
      final c = GameController.withDependencies(
        engine,
        repo,
        clock: () => 1000,
      );
      c.state = GameState(lastMs: 1000)
        ..level = 4
        ..reducedMotion = true;
      router.go(width == 320 ? '/office' : '/equipment');
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
      await tester.ensureVisible(find.text('사무실 꾸미기'));
      await tester.tap(find.text('사무실 꾸미기'));
      await tester.pumpAndSettle();
      expect(find.text('나만의 사무실'), findsOneWidget);
      final executive = find.text('노을빛 스카이라인');
      await tester.ensureVisible(executive);
      await tester.tap(executive);
      await tester.pumpAndSettle();
      expect(c.state!.officeStyle, isEmpty);
      expect(
        tester
            .widget<PixelButton>(find.byKey(const ValueKey('apply-decoration')))
            .onPressed,
        isNull,
      );
      expect(
        tester
            .widget<OfficeScene>(
              find.byKey(const ValueKey('decoration-preview')),
            )
            .officeStyle['room'],
        'room-executive',
      );
      // Changing tabs discards the unapplied room preview.
      await tester.ensureVisible(find.text('책상'));
      await tester.tap(find.text('책상'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('짙은 월넛 책상'));
      await tester.tap(find.text('짙은 월넛 책상'));
      await tester.pumpAndSettle();
      expect(c.state!.officeStyle, isEmpty);
      final apply = find.byKey(const ValueKey('apply-decoration'));
      await tester.ensureVisible(apply);
      await tester.tap(apply);
      await tester.pumpAndSettle();
      expect(c.state!.officeStyle, {'desk': 'desk-walnut'});
      expect((await repo.load()).state!.officeStyle, {'desk': 'desk-walnut'});
      expect(tester.widget<PixelButton>(apply).onPressed, isNull);
      for (final choice in [
        ['머리색', '실버 그레이', 'hair', 'hair-silver'],
        ['상의', '따뜻한 코랄', 'shirt', 'shirt-coral'],
        ['피부색', '깊은 피부색', 'skin', 'skin-deep'],
      ]) {
        await tester.ensureVisible(find.text(choice[0]));
        await tester.tap(find.text(choice[0]));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text(choice[1]));
        await tester.tap(find.text(choice[1]));
        await tester.pumpAndSettle();
        expect(c.state!.officeStyle[choice[2]], isNull);
        expect(
          tester
              .widget<OfficeScene>(
                find.byKey(const ValueKey('decoration-preview')),
              )
              .officeStyle[choice[2]],
          choice[3],
        );
        await tester.ensureVisible(apply);
        await tester.tap(apply);
        await tester.pumpAndSettle();
        expect((await repo.load()).state!.officeStyle[choice[2]], choice[3]);
      }
      await tester.ensureVisible(find.byTooltip('닫기'));
      await tester.tap(find.byTooltip('닫기'));
      await tester.pumpAndSettle();
      router.go('/office');
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<OfficeScene>(find.byKey(const ValueKey('office-scene')))
            .officeStyle['desk'],
        'desk-walnut',
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
