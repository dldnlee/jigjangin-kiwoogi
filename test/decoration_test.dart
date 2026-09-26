import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:office_worker/domain/game.dart';
import 'package:office_worker/data/save_repository.dart';

void main() {
  final engine = GameEngine(
    GameContent(
      jsonDecode(File('assets/data/content.json').readAsStringSync()) as Json,
    ),
  );
  GameState apply(GameState s, String decoration, {String? id}) => engine
      .command(
        s,
        'decorate',
        key: decoration,
        id: id ?? 'style-${s.revision}',
        expectedRevision: s.revision,
      )
      .state;
  test('old saves default to original scene and preserve coworker state', () {
    final old = GameState(lastMs: 1000)..relationships['park'] = 40;
    final json = old.toJson()..remove('officeStyle');
    final migrated = GameState.fromJson(json);
    engine.validate(migrated);
    expect(migrated.officeStyle, isEmpty);
    expect(officeChoice(migrated.officeStyle, 'room'), 'room-auto');
    expect(migrated.friendship('park'), 40);
    expect(officeChoice(migrated.officeStyle, 'hair'), 'hair-black');
    expect(officeChoice(migrated.officeStyle, 'shirt'), 'shirt-white');
    expect(officeChoice(migrated.officeStyle, 'skin'), 'skin-warm');
  });
  test('every appearance option is free from level one', () {
    var s = GameState(lastMs: 1000);
    for (final option in officeDecorations.where(
      (d) => ['hair', 'shirt', 'skin'].contains(d.slot),
    )) {
      s = apply(s, option.id);
      expect(s.officeStyle[option.slot], option.id);
      engine.validate(s);
    }
    expect(s.cash, GameState(lastMs: 1000).cash);
  });
  test('milestones gate equipping, promotions unlock rooms early', () {
    final fresh = GameState(lastMs: 1000);
    expect(() => apply(fresh, 'desk-walnut'), throwsStateError);
    expect(() => apply(fresh, 'pet-silver'), throwsStateError);
    expect(() => apply(fresh, 'room-executive'), throwsStateError);
    final promoted = fresh.copy()..rank = 3;
    expect(
      apply(promoted, 'room-executive').officeStyle['room'],
      'room-executive',
    );
    expect(fresh.officeStyle, isEmpty);
  });
  test(
    'all options can equip at milestone without money or gameplay effects',
    () {
      var s = GameState(lastMs: 1000)..level = 16;
      final initial = s.copy();
      for (final item in officeDecorations) {
        s = apply(s, item.id);
        expect(s.officeStyle[item.slot], item.id);
        engine.validate(s);
      }
      expect(s.cash, initial.cash);
      expect(engine.rate(s), engine.rate(initial));
      expect(s.random, initial.random);
      expect(s.skills, initial.skills);
      expect(s.performance, initial.performance);
    },
  );
  test('selections are reversible and command replay cannot overwrite newer choice', () {
    var s = GameState(lastMs: 1000)..level = 4;
    s = apply(s, 'desk-walnut', id: 'first');
    s = apply(s, 'desk-oak', id: 'second');
    expect(
      apply(s, 'desk-walnut', id: 'first').officeStyle['desk'],
      'desk-oak',
    );
    expect(
      () => engine.command(
        s,
        'decorate',
        key: 'pet-none',
        id: 'stale',
        expectedRevision: 0,
      ),
      throwsStateError,
    );
  });
  test('invalid, mismatched, or locked saved selections are rejected', () {
    for (final style in [
      {'desk': 'unknown'},
      {'pet': 'desk-oak'},
      {'room': 'room-executive'},
      {'bad': 'pet-orange'},
    ]) {
      expect(
        () => engine.validate(GameState(lastMs: 1000)..officeStyle = style),
        throwsFormatException,
      );
    }
  });
  test(
    'SQLite reload and backup preserve room and character selections',
    () async {
      final repo = SaveRepository(
        SaveDatabase(NativeDatabase.memory()),
        engine,
      );
      try {
        var s = GameState(lastMs: 1000)..level = 16;
        for (final id in [
          'room-starter',
          'desk-walnut',
          'plant-small',
          'pet-silver',
          'hair-silver',
          'shirt-coral',
          'skin-deep',
        ]) {
          s = apply(s, id);
        }
        final saved = await repo.commit(s, 0);
        expect((await repo.load()).state!.officeStyle, s.officeStyle);
        expect(
          decodeSave(encodeSave(saved), engine).officeStyle,
          s.officeStyle,
        );
      } finally {
        await repo.database.close();
      }
    },
  );
}
