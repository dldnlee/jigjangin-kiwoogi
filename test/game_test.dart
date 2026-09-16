import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:office_worker/domain/game.dart';
import 'package:office_worker/data/save_repository.dart';
import 'package:office_worker/ui/office_scene.dart';

void main() {
  final engine = GameEngine(
    GameContent(
      jsonDecode(File('assets/data/content.json').readAsStringSync()) as Json,
    ),
  );
  GameState fresh() => GameState(lastMs: 1000, seed: 42);
  test('initial income, exact BigInt salary, and level advancement', () {
    final initial = fresh();
    expect(engine.rate(initial), BigInt.from(100));
    final s = engine.advance(initial, 100);
    expect(s.cash, BigInt.from(10000));
    expect(s.level, 2);
    expect(initial.cash, BigInt.zero);
  });
  test('offline cap and clock rollback do not double credit', () {
    final s = engine.settle(fresh(), 86401000, away: true);
    expect(s.seconds, 28800);
    expect(s.cash, BigInt.from(2880000));
    expect(s.offline!['capped'], true);
    final back = engine.settle(s, 5000);
    expect(back.cash, s.cash);
    expect(engine.settle(back, 86401000).cash, s.cash);
  });
  test('fractional ticks equal a single settlement', () {
    var s = fresh();
    for (var t = 1250; t <= 101000; t += 250) {
      s = engine.settle(s, t);
    }
    expect(s.toJson(), engine.settle(fresh(), 101000).toJson());
  });
  test('seeded simulation is invariant to frame segmentation', () {
    var split = fresh();
    for (var i = 0; i < 3600; i++) {
      split = engine.advance(split, 1);
    }
    expect(split.toJson(), engine.advance(fresh(), 3600).toJson());
  });
  test('purchase is atomic and replay safe', () {
    final s = engine.advance(fresh(), 60);
    final result = engine
        .command(
          s,
          'upgrade',
          key: 'speed',
          id: 'purchase-1',
          expectedRevision: 0,
        )
        .state;
    expect(result.upgrades['speed'], 1);
    expect(engine.rate(result), BigInt.from(105));
    expect(
      engine
          .command(
            result,
            'upgrade',
            key: 'speed',
            id: 'purchase-1',
            expectedRevision: 0,
          )
          .state
          .cash,
      result.cash,
    );
    expect(
      () => engine.command(
        fresh(),
        'upgrade',
        key: 'speed',
        id: 'no-cash',
        expectedRevision: 0,
      ),
      throwsStateError,
    );
    expect(s.upgrades['speed'], 0);
  });
  test('save checksum rejects tampering', () {
    final s = fresh();
    expect(decodeSave(encodeSave(s), engine).toJson(), s.toJson());
    final envelope = jsonDecode(encodeSave(s)) as Json;
    envelope['payload'] = '{}';
    expect(
      () => decodeSave(jsonEncode(envelope), engine),
      throwsFormatException,
    );
  });
  test('room tiers progress with both levels and promotions', () {
    expect(roomForLevel(1, 0), 0);
    expect(roomForLevel(6, 0), 1);
    expect(roomForLevel(11, 0), 2);
    expect(roomForLevel(16, 0), 3);
    expect(roomForLevel(2, 4), 3);
  });
  test(
    'SQLite commits, rejects stale writes, and recovers prior snapshot',
    () async {
      final db = SaveDatabase(NativeDatabase.memory());
      final repo = SaveRepository(db, engine);
      try {
        expect((await repo.load()).state, isNull);
        final one = await repo.commit(fresh(), 0);
        await repo.commit(engine.advance(one, 60), 1);
        await expectLater(repo.commit(one, 1), throwsStateError);
        await db.customStatement(
          "UPDATE game_save SET current='broken' WHERE id=1",
        );
        final recovered = await repo.load();
        expect(recovered.recovered, true);
        expect(recovered.state!.cash, BigInt.zero);
        expect(recovered.revision, 2);
        final repaired = await repo.commit(recovered.state!, 2);
        expect(repaired.revision, 3);
        expect((await repo.load()).recovered, false);
      } finally {
        await db.close();
      }
    },
  );
}
