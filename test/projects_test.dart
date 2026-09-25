import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
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
  GameState fresh() =>
      GameState(lastMs: 1000, seed: 42)..cash = BigInt.from(10000);
  GameState command(
    GameState s,
    String kind, {
    String key = 'presentation',
    int choice = 0,
    String? id,
  }) => engine
      .command(
        s,
        kind,
        key: key,
        choice: choice,
        id: id ?? '$kind-${s.revision}',
        expectedRevision: s.revision,
      )
      .state;

  test(
    'old backups migrate without losing existing random streams or money',
    () {
      final old = fresh().toJson()
        ..remove('activeProject')
        ..remove('completedProjects');
      (old['random'] as Map).remove('projects');
      final payload = canonical(old);
      final migrated = decodeSave(
        jsonEncode({
          'payload': payload,
          'checksum': sha256.convert(utf8.encode(payload)).toString(),
        }),
        engine,
      );
      expect(migrated.cash, fresh().cash);
      expect(migrated.activeProject, isNull);
      expect(migrated.completedProjects, isEmpty);
      for (final stream in ['events', 'offers', 'promotion']) {
        expect(migrated.random[stream], fresh().random[stream]);
      }
      expect(migrated.random['projects'], fresh().random['projects']);
    },
  );

  test(
    'start is atomic, charges once, and rejects locked or concurrent projects',
    () {
      final s = fresh();
      expect(() => command(s, 'startProject', key: 'team'), throwsStateError);
      expect(() => command(s, 'startProject', choice: 9), throwsStateError);
      expect(
        () => command(GameState(lastMs: 1000), 'startProject'),
        throwsStateError,
      );
      final started = command(s, 'startProject', id: 'start');
      expect(started.cash, BigInt.from(9000));
      expect(s.activeProject, isNull);
      expect(
        command(started, 'startProject', id: 'start').toJson(),
        started.toJson(),
      );
      expect(
        () => command(started, 'startProject', key: 'report'),
        throwsStateError,
      );
      expect(started.random['events'], s.random['events']);
    },
  );

  test(
    'completion grants exact rewards once and unlocks the next assignment',
    () {
      final started = command(fresh(), 'startProject');
      expect(() => command(started, 'claimProject'), throwsStateError);
      final ready = engine.advance(started, 180);
      final claimed = command(ready, 'claimProject', id: 'claim');
      expect(claimed.cash - ready.cash, BigInt.from(6000));
      expect(claimed.earned - ready.earned, BigInt.from(6000));
      expect(claimed.performance - ready.performance, 20);
      expect(claimed.reputation, 1);
      expect(claimed.skills['expertise'], 1);
      expect(claimed.activeProject, isNull);
      expect(claimed.completedProjects, ['presentation']);
      expect(
        command(claimed, 'claimProject', id: 'claim').toJson(),
        claimed.toJson(),
      );
      expect(() => command(claimed, 'claimProject'), throwsStateError);
      expect(() => command(claimed, 'startProject'), throwsStateError);
      expect(
        command(
          claimed,
          'startProject',
          key: 'report',
        ).activeProject!.projectId,
        'report',
      );
    },
  );

  test('risky outcomes are persistent and unsuccessful projects still unlock progression', () {
    for (final roll in [0, 9999]) {
      final s = fresh()
        ..activeProject = ProjectRun('presentation', 'rush', 0, roll);
      final ready = engine.advance(decodeSave(encodeSave(s), engine), 90);
      final claimed = command(ready, 'claimProject');
      expect(claimed.cash - ready.cash, BigInt.from(roll == 0 ? 8000 : 0));
      expect(claimed.completedProjects, ['presentation']);
      expect(claimed.skills['work'], roll == 0 ? 1 : 0);
      expect(claimed.journal.first['text'], contains(roll == 0 ? '성공' : '아쉬운'));
    }
  });

  test(
    'offline settlement and small ticks agree, rollback cannot finish early',
    () {
      final started = command(fresh(), 'startProject');
      var split = started;
      for (var t = 2000; t <= 181000; t += 1000) {
        split = engine.settle(split, t);
      }
      expect(split.toJson(), engine.settle(started, 181000).toJson());
      final away = engine.settle(started, 86401000, away: true);
      expect(away.seconds, 28800);
      expect(away.activeProject!.succeeded, started.activeProject!.succeeded);
      expect(command(away, 'claimProject').completedProjects, ['presentation']);
      final back = engine.settle(started, 0);
      expect(() => command(back, 'claimProject'), throwsStateError);
    },
  );

  test(
    'save validation rejects invalid project state and caps skill rewards',
    () {
      for (final run in [
        const ProjectRun('bad', 'solo', 0, 0),
        const ProjectRun('presentation', 'bad', 0, 0),
        const ProjectRun('presentation', 'solo', 5, 0),
        const ProjectRun('presentation', 'solo', 0, 10000),
      ]) {
        expect(
          () => engine.validate(fresh()..activeProject = run),
          throwsFormatException,
        );
      }
      expect(
        () => engine.validate(fresh()..completedProjects = ['team']),
        throwsFormatException,
      );
      expect(
        () => engine.validate(
          fresh()..completedProjects = ['presentation', 'presentation'],
        ),
        throwsFormatException,
      );
      final s = fresh()..skills['expertise'] = 100;
      final ready = engine.advance(command(s, 'startProject'), 180);
      expect(command(ready, 'claimProject').skills['expertise'], 100);
    },
  );

  test('SQLite reload and backup round trip preserve active and completed projects', () async {
    final repo = SaveRepository(SaveDatabase(NativeDatabase.memory()), engine);
    try {
      final started = await repo.commit(command(fresh(), 'startProject'), 0);
      final loaded = (await repo.load()).state!;
      expect(loaded.toJson(), started.toJson());
      final ready = engine.advance(loaded, 180);
      final done = await repo.commit(
        command(ready, 'claimProject'),
        loaded.revision,
      );
      expect((await repo.load()).state!.completedProjects, ['presentation']);
      expect(decodeSave(encodeSave(done), engine).toJson(), done.toJson());
      await expectLater(repo.commit(ready, loaded.revision), throwsStateError);
    } finally {
      await repo.database.close();
    }
  });

  test(
    'every authored option has the advertised cost, duration and reward',
    () {
      for (var index = 0; index < officeProjects.length; index++) {
        final project = officeProjects[index];
        for (var choice = 0; choice < project.approaches.length; choice++) {
          final option = project.approaches[choice];
          final before = fresh()
            ..completedProjects = officeProjects
                .take(index)
                .map((p) => p.id)
                .toList();
          final started = command(
            before,
            'startProject',
            key: project.id,
            choice: choice,
          );
          expect(before.cash - started.cash, BigInt.from(option.cost));
          expect(started.activeProject!.finishesAt, option.seconds);
          final ready = engine.advance(started, option.seconds);
          final won = ready.activeProject!.succeeded;
          final claimed = command(ready, 'claimProject', key: project.id);
          expect(
            claimed.cash - ready.cash,
            BigInt.from(won ? option.reward : 0),
          );
          expect(claimed.skills[option.skill], won ? 1 : 0);
        }
      }
    },
  );

  test('all authored approaches can complete the full project chain', () {
    for (final firstChoice in [0, 1, 2]) {
      var s = fresh();
      for (final project in officeProjects) {
        s = command(
          s,
          'startProject',
          key: project.id,
          choice: project.id == 'presentation' ? firstChoice : 0,
        );
        s = engine.advance(s, s.activeProject!.approach.seconds);
        s = command(s, 'claimProject', key: project.id);
        engine.validate(s);
      }
      expect(s.completedProjects, ['presentation', 'report', 'team']);
    }
  });
}
