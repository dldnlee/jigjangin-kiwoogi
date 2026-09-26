import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:office_worker/application/game_controller.dart';
import 'package:office_worker/data/save_repository.dart';
import 'package:office_worker/domain/game.dart';
import 'package:office_worker/main.dart';
import 'package:office_worker/ui/office_scene.dart';
import 'package:office_worker/ui/office_moments.dart';

Future<void> waitForOfficeArt(WidgetTester tester) async {
  for (var i = 0; i < 30 && find.text('사무실 준비 중…').evaluate().isNotEmpty; i++) {
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 150));
    });
    await tester.pump();
  }
  expect(find.text('사무실 준비 중…'), findsNothing);
  expect(find.text('사무실 이미지를 불러오지 못했어요.'), findsNothing);
}

// Native font rasterization and image sampling vary by host renderer.
final goldenDirectory = Platform.isMacOS ? 'goldens/macos' : 'goldens';

void main() {
  testWidgets('pixel worker atlas has real alpha and preserves solid paper', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final bytes = await rootBundle.load('assets/sprites/office-worker-pixel-v2.png');
      final codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List());
      final image = (await codec.getNextFrame()).image;
      final data = (await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      ))!;
      var clear = 0, white = 0;
      for (var i = 0; i < data.lengthInBytes; i += 4) {
        if (data.getUint8(i + 3) == 0) {
          clear++;
        }
        if (data.getUint8(i + 3) >= 240 &&
            data.getUint8(i) > 210 &&
            data.getUint8(i + 1) > 210 &&
            data.getUint8(i + 2) > 200) {
          white++;
        }
      }
      expect(data.getUint8(3), 0);
      expect(clear, greaterThan(900000));
      expect(white, greaterThan(500));
      image.dispose();
      codec.dispose();
    });
  });

  testWidgets(
    'ambient animation freezes for reduced motion and app background',
    (tester) async {
      Widget scene(bool reduced) => MaterialApp(
        home: Scaffold(
          body: OfficeScene(
            level: 1,
            rank: 0,
            reducedMotion: reduced,
            fillSpace: true,
          ),
        ),
      );
      await tester.pumpWidget(scene(true));
      await waitForOfficeArt(tester);
      await tester.pump(const Duration(seconds: 30));
      expect(find.text('●  차근차근 업무 중'), findsOneWidget);
      await tester.pumpWidget(scene(false));
      for (var i = 0; i < 80; i++) {
        await tester.pump(const Duration(milliseconds: 150));
      }
      expect(find.text('●  차근차근 업무 중'), findsNothing);
      final captions = find.byWidgetPredicate(
        (w) => w is Text && (w.data?.startsWith('●  ') ?? false),
      );
      final before = (tester.widget<Text>(captions)).data;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump(const Duration(seconds: 30));
      expect((tester.widget<Text>(captions)).data, before);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('all mobile screens fit at 320 and 390 logical pixels', (
    tester,
  ) async {
    final font = FontLoader('NeoDunggeunmo')
      ..addFont(rootBundle.load('assets/fonts/neodgm.ttf'));
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
    for (final size in [const Size(320, 568), const Size(390, 844)]) {
      tester.view.physicalSize = size;
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
        expect(tester.takeException(), isNull, reason: '$page at $size');
        if (page == 'office') {
          expect(find.byType(Scrollable), findsNothing);
          final stage = find.byKey(const ValueKey('fixed-office-stage'));
          final before = tester.getRect(stage);
          await tester.drag(stage, const Offset(0, -140));
          await tester.pumpAndSettle();
          expect(tester.getRect(stage), before);
          await tester.tap(find.text('업무 업그레이드'));
          await tester.pumpAndSettle();
          expect(find.text('오늘의 작은 업그레이드'), findsOneWidget);
          await tester.tap(find.byTooltip('닫기'));
          await tester.pumpAndSettle();
          expect(tester.getRect(stage), before);
          expect(tester.takeException(), isNull);
        }
      }
    }
    router.go('/office');
    await tester.pumpAndSettle();
    await waitForOfficeArt(tester);
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const ValueKey('capture')),
      matchesGoldenFile('$goldenDirectory/mobile-office.png'),
    );
    for (final level in [6, 11, 16]) {
      c.state = c.state!.copy()..level = level;
      c.notifyListeners();
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(const ValueKey('capture')),
        matchesGoldenFile('$goldenDirectory/office-level-$level.png'),
      );
    }
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'custom desk pixels stay fixed across character frames and moods',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 450);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      List<int>? baseline;
      for (final mood in OfficeMoment.values) {
        for (var frame = 0; frame < 4; frame++) {
          await tester.pumpWidget(
            MaterialApp(
              home: RepaintBoundary(
                key: const ValueKey('fixed-desk'),
                child: OfficeScene(
                  level: 3,
                  rank: 0,
                  reducedMotion: true,
                  fillSpace: true,
                  officeStyle: const {
                    'desk': 'desk-walnut',
                    'pet': 'pet-silver',
                    'plant': 'plant-small',
                  },
                  previewMoment: mood,
                  previewFrame: frame,
                ),
              ),
            ),
          );
          await waitForOfficeArt(tester);
          await tester.pump();
          final boundary = tester.renderObject<RenderRepaintBoundary>(
            find.byKey(const ValueKey('fixed-desk')),
          );
          final pixels = await tester.runAsync(() async {
            final image = await boundary.toImage();
            final bytes = (await image.toByteData(
              format: ui.ImageByteFormat.rawRgba,
            ))!;
            final result = <int>[];
            // Monitor and desk leg: independent of hands, papers and coffee effects.
            for (final region in [
              const Rect.fromLTWH(240, 292, 14, 40),
              const Rect.fromLTWH(274, 370, 8, 30),
            ]) {
              for (var y = region.top.toInt(); y < region.bottom; y++) {
                for (var x = region.left.toInt(); x < region.right; x++) {
                  result.add(bytes.getUint32((y * image.width + x) * 4));
                }
              }
            }
            image.dispose();
            return result;
          });
          baseline ??= pixels;
          expect(
            pixels,
            baseline,
            reason: '${mood.name} frame $frame moved furniture',
          );
        }
      }
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('appearance channels change only character pixels', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 450);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final font = FontLoader('NeoDunggeunmo')
      ..addFont(rootBundle.load('assets/fonts/neodgm.ttf'));
    await font.load();
    Future<List<int>> capture(Map<String, String> style) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'NeoDunggeunmo'),
          home: Scaffold(
            body: RepaintBoundary(
              key: const ValueKey('palette-capture'),
              child: OfficeScene(
                level: 1,
                rank: 0,
                reducedMotion: true,
                fillSpace: true,
                previewMoment: OfficeMoment.working,
                officeStyle: style,
              ),
            ),
          ),
        ),
      );
      await waitForOfficeArt(tester);
      await tester.pump();
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(const ValueKey('palette-capture')),
      );
      return (await tester.runAsync(() async {
        final image = await boundary.toImage();
        final bytes = (await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        ))!;
        final pixels = [
          for (var i = 0; i < bytes.lengthInBytes; i += 4) bytes.getUint32(i),
        ];
        image.dispose();
        return pixels;
      }))!;
    }

    final original = await capture({});
    final changedSets = <Set<int>>[];
    for (final selection in [
      {'hair': 'hair-silver'},
      {'shirt': 'shirt-coral'},
      {'skin': 'skin-deep'},
    ]) {
      final changed = await capture(selection);
      final indices = <int>{};
      for (var i = 0; i < original.length; i++) {
        if (original[i] != changed[i]) {
          indices.add(i);
          final x = i % 390, y = i ~/ 390;
          expect(
            x >= 70 && x < 304 && y >= 252 && y < 408,
            isTrue,
            reason: 'Palette changed background/furniture at $x,$y',
          );
        }
      }
      expect(
        indices.length,
        greaterThan(50),
        reason: '$selection had no visible effect',
      );
      for (final prior in changedSets) {
        expect(
          indices.intersection(prior),
          isEmpty,
          reason: 'Appearance channels must remain independent',
        );
      }
      changedSets.add(indices);
    }
    await capture({
      'hair': 'hair-silver',
      'shirt': 'shirt-coral',
      'skin': 'skin-deep',
    });
    if (Platform.isMacOS) {
      await expectLater(
        find.byKey(const ValueKey('palette-capture')),
        matchesGoldenFile('$goldenDirectory/character-customized.png'),
      );
    }
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('six office scenes render with the real sprite atlas', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 450);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final font = FontLoader('NeoDunggeunmo')
      ..addFont(rootBundle.load('assets/fonts/neodgm.ttf'));
    await font.load();
    for (final moment in OfficeMoment.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'NeoDunggeunmo'),
          home: Scaffold(
            body: RepaintBoundary(
              key: const ValueKey('scene-capture'),
              child: OfficeScene(
                level: 3,
                rank: 0,
                reducedMotion: true,
                fillSpace: true,
                previewMoment: moment,
                previewFrame: 2,
              ),
            ),
          ),
        ),
      );
      await waitForOfficeArt(tester);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('scene-capture')),
        matchesGoldenFile('$goldenDirectory/scene-${moment.name}.png'),
      );
    }
    for (final progress in [.21, .79]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'NeoDunggeunmo'),
          home: Scaffold(
            body: RepaintBoundary(
              key: const ValueKey('walk-capture'),
              child: OfficeScene(
                level: 3,
                rank: 0,
                reducedMotion: true,
                fillSpace: true,
                previewMoment: OfficeMoment.feedback,
                previewProgress: progress,
              ),
            ),
          ),
        ),
      );
      await waitForOfficeArt(tester);
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(const ValueKey('walk-capture')),
        matchesGoldenFile(
          '$goldenDirectory/boss-${progress < .5 ? "arrival" : "departure"}.png',
        ),
      );
    }
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('customized room themes render with stable sprite proportions', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 450);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final font = FontLoader('NeoDunggeunmo')
      ..addFont(rootBundle.load('assets/fonts/neodgm.ttf'));
    await font.load();
    for (final room in ['starter', 'open', 'manager', 'executive']) {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'NeoDunggeunmo'),
          home: Scaffold(
            body: RepaintBoundary(
              key: const ValueKey('decorated-scene'),
              child: OfficeScene(
                level: 16,
                rank: 0,
                reducedMotion: true,
                fillSpace: true,
                previewMoment: OfficeMoment.feedback,
                previewFrame: 2,
                officeStyle: {
                  'room': 'room-$room',
                  'desk': 'desk-walnut',
                  'plant': 'plant-small',
                  'pet': 'pet-silver',
                },
              ),
            ),
          ),
        ),
      );
      await waitForOfficeArt(tester);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      if (Platform.isMacOS) {
        await expectLater(
          find.byKey(const ValueKey('decorated-scene')),
          matchesGoldenFile('$goldenDirectory/decorated-$room.png'),
        );
      }
    }
    await tester.pumpWidget(const SizedBox());
  });
}
