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

/// Fails the next [failures] commits with [error], then saves normally.
class FlakyRepository extends SaveRepository {
  FlakyRepository(super.database, super.engine, this.error);
  Object Function(GameState state) error;
  int failures = 1;

  @override
  Future<GameState> commit(GameState state, int expectedRevision) async {
    if (failures > 0) {
      failures--;
      throw error(state);
    }
    return super.commit(state, expectedRevision);
  }
}

/// Mirrors the error observed on iOS: the statement parameters contain the
/// whole encoded save, which must never be shown to the player.
SqliteException storageFailure(GameState state) => SqliteException(
  extendedResultCode: 14,
  message: 'unable to open database file',
  operation: 'executing statement',
  causingStatement: 'INSERT OR REPLACE INTO game_save(id, revision, current, previous) VALUES (1, ?, ?, ?)',
  parametersToStatement: [7899, encodeSave(state) * 40, encodeSave(state)],
);

GameEngine loadEngine() => GameEngine(
  GameContent(
    jsonDecode(File('assets/data/content.json').readAsStringSync()) as Json,
  ),
);

void main() {
  for (final width in [320.0, 390.0]) {
    testWidgets('storage failure shows a bounded message and retry recovers '
        'at $width', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, 700);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final engine = loadEngine();
      final repo = FlakyRepository(
        SaveDatabase(NativeDatabase.memory()),
        engine,
        storageFailure,
      );
      final c = GameController.withDependencies(
        engine,
        repo,
        clock: () => 1000,
      );
      c.state = GameState(lastMs: 1000)..reducedMotion = true;
      // A running game always has a committed snapshot to fall back to.
      repo.failures = 0;
      await c.save();
      repo.failures = 1;
      router.go('/office');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [gameProvider.overrideWith((ref) => c)],
          child: const OfficeWorkerApp(),
        ),
      );
      await tester.pumpAndSettle();

      await c.save();
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('save-error')), findsOneWidget);
      expect(find.textContaining('기기 저장소에 접근하지 못했어요'), findsOneWidget);
      expect(c.error, isNot(contains('INSERT')));
      expect(c.error, isNot(contains('payload')));
      expect(c.error!.length, lessThan(80));
      expect(find.byKey(const ValueKey('fixed-office-stage')), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('다시 저장'));
      await tester.pumpAndSettle();

      expect(c.error, isNull);
      expect(find.byKey(const ValueKey('save-error')), findsNothing);
      expect((await repo.load()).state, isNotNull);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  test(
    'game-authored Korean messages are kept; technical ones are not',
    () async {
      final engine = loadEngine();
      Future<String?> errorFor(Object thrown) async {
        final c = GameController.withDependencies(
          engine,
          FlakyRepository(
            SaveDatabase(NativeDatabase.memory()),
            engine,
            (_) => thrown,
          ),
          clock: () => 1000,
        );
        c.state = GameState(lastMs: 1000);
        await c.save();
        await c.repository.database.close();
        return c.error;
      }

      expect(
        await errorFor(StateError('다른 실행에서 저장이 바뀌었어요. 앱을 다시 열어 주세요.')),
        '저장하지 못했어요. 다른 실행에서 저장이 바뀌었어요. 앱을 다시 열어 주세요.',
      );
      for (final technical in [
        const FormatException('Unexpected character', '{"payload":"secret"}'),
        StateError('Bad state: database is locked'),
        ArgumentError('Invalid elapsed duration'),
        StateError('가' * 200),
      ]) {
        expect(
          await errorFor(technical),
          '저장하지 못했어요. 기기 저장소에 접근하지 못했어요. 잠시 후 다시 시도해 주세요.',
        );
      }
    },
  );
}
