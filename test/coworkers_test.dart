import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:office_worker/data/save_repository.dart';
import 'package:office_worker/domain/game.dart';

void main() {
  final engine = GameEngine(
    GameContent(
      jsonDecode(File('assets/data/content.json').readAsStringSync()) as Json,
    ),
  );
  GameState fresh() =>
      GameState(lastMs: 1000, seed: 42)..cash = BigInt.from(20000);
  GameState command(
    GameState s,
    String kind, {
    String key = 'park',
    int choice = 0,
  }) => engine
      .command(
        s,
        kind,
        key: key,
        choice: choice,
        id: '$kind-$key-${s.revision}',
        expectedRevision: s.revision,
      )
      .state;

  test('saves without coworker fields load with no relationships', () {
    final old = fresh().toJson()
      ..remove('relationships')
      ..remove('lastChats')
      ..remove('chatMemories');
    final payload = canonical(old);
    final migrated = decodeSave(
      jsonEncode({
        'payload': payload,
        'checksum': sha256.convert(utf8.encode(payload)).toString(),
      }),
      engine,
    );
    expect(migrated.relationships, isEmpty);
    expect(migrated.helpers, isEmpty);
    expect(migrated.cash, fresh().cash);
  });

  test('chat remembers the topic, favours preferences and has a cooldown', () {
    var s = command(fresh(), 'chat', choice: 0); // park favours advice
    expect(s.friendship('park'), 5);
    expect(s.chatMemories['park'], 'advice');
    expect(s.journal.first['text'], '박 선배와 보고서 조언 구하기');
    expect(() => command(s, 'chat', choice: 1), throwsStateError);
    s = command(s, 'chat', key: 'lee', choice: 1);
    expect(s.friendship('lee'), 3);
    expect(s.journal.first['text'], startsWith('이 인턴과'));
    s = engine.advance(s, coworkerChatCooldown);
    s = command(s, 'coffee');
    expect(s.friendship('park'), 13);
    expect(s.cash, BigInt.from(20000 - coworkerCoffeeCost) + s.earned);
    expect(() => command(s, 'chat', key: 'nobody'), throwsFormatException);
  });

  test(
    'perks are captured at project start and persist through saves',
    () async {
      var s = fresh()..relationships = {'park': 30, 'kim': 30, 'lee': 30};
      final approach = projectById('presentation').approaches[2]; // rush
      s = command(s, 'startProject', key: 'presentation', choice: 2);
      final run = s.activeProject!;
      expect(run.helpers, ['park', 'kim', 'lee']);
      expect(run.seconds, approach.seconds * 85 ~/ 100);
      expect(run.successChance, approach.successChance + 1000);
      expect(run.reward, approach.reward * 110 ~/ 100);

      // Losing friendship later does not rewrite the running project.
      s.relationships = {};
      final repo = SaveRepository(
        SaveDatabase(NativeDatabase.memory()),
        engine,
      );
      await repo.commit(s, 0);
      final loaded = (await repo.load()).state!;
      expect(loaded.activeProject!.helpers, run.helpers);
      expect(loaded.activeProject!.finishesAt, run.finishesAt);
      await repo.database.close();
    },
  );

  test('collaborative projects raise every relationship once', () {
    var s = command(fresh(), 'startProject', key: 'presentation', choice: 1);
    s = engine.advance(s, s.activeProject!.seconds);
    s = command(s, 'claimProject', key: 'presentation');
    for (final c in coworkers) {
      expect(s.friendship(c.id), 8);
    }
  });

  test('invalid coworker saves are rejected', () {
    expect(
      () => engine.validate(fresh()..relationships = {'park': 101}),
      throwsFormatException,
    );
    expect(
      () => engine.validate(fresh()..chatMemories = {'kim': 'gossip'}),
      throwsFormatException,
    );
    expect(
      () => engine.validate(fresh()..lastChats = {'lee': 99}),
      throwsFormatException,
    );
  });

  test('josa picks the particle from the final syllable', () {
    expect(josa('박 선배', '와', '과'), '박 선배와');
    expect(josa('이 인턴', '와', '과'), '이 인턴과');
    expect(josa('김 대리', '는', '은'), '김 대리는');
  });
}
