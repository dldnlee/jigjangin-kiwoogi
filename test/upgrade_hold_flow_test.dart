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
  for (final training in [false, true]) {
    testWidgets(
      'hold ${training ? "training" : "upgrade"} respects cost/cap and saves',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(390, 844);
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
        final item = training
            ? engine.content.skills.first
            : engine.content.upgrades.first;
        final id = item['id'] as String;
        final base = training ? 1000 : item['base'] as int;
        c.state = GameState(lastMs: 1000)..reducedMotion = true;
        if (training) {
          c.state!.upgrades['speed'] = 1;
          c.state!.skills[id] = 98;
          c.state!.cash = BigInt.from(10).pow(18);
        } else {
          c.state!.cash =
              upgradeCost(base, 0) +
              upgradeCost(base, 1) +
              upgradeCost(base, 2);
        }
        router.go(training ? '/skills' : '/office');
        await tester.pumpWidget(
          ProviderScope(
            overrides: [gameProvider.overrideWith((ref) => c)],
            child: const OfficeWorkerApp(),
          ),
        );
        await tester.pumpAndSettle();
        if (!training) {
          await tester.tap(find.text('업무 업그레이드'));
          await tester.pumpAndSettle();
        }
        final button = find.byKey(
          ValueKey('${training ? "train" : "upgrade"}-$id'),
        );
        await tester.ensureVisible(button);
        final gesture = await tester.startGesture(tester.getCenter(button));
        await tester.pump(const Duration(milliseconds: 600));
        for (var i = 0; i < 15; i++) {
          await tester.pump(const Duration(milliseconds: 180));
        }
        await gesture.up();
        await tester.pumpAndSettle();
        if (training) {
          expect(c.state!.skills[id], 100);
        } else {
          expect(c.state!.upgrades[id], 3);
          expect(c.state!.cash, BigInt.zero);
        }
        final saved = (await repo.load()).state!;
        expect(saved.upgrades, c.state!.upgrades);
        expect(saved.skills, c.state!.skills);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
}
