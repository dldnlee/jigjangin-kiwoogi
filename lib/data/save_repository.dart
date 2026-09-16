import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../domain/game.dart';

String canonical(dynamic value) {
  if (value is List) return '[${value.map(canonical).join(',')}]';
  if (value is Map) {
    final keys = value.keys.cast<String>().toList()..sort();
    return '{${keys.map((k) => '${jsonEncode(k)}:${canonical(value[k])}').join(',')}}';
  }
  return jsonEncode(value);
}

String encodeSave(GameState state) {
  final payload = canonical(state.toJson());
  return jsonEncode({
    'payload': payload,
    'checksum': sha256.convert(utf8.encode(payload)).toString(),
  });
}

GameState decodeSave(String text, GameEngine engine) {
  if (text.length > 5 * 1024 * 1024) {
    throw const FormatException('백업 파일이 너무 커요.');
  }
  final envelope = jsonDecode(text) as Json;
  final payload = envelope['payload'] as String;
  if (sha256.convert(utf8.encode(payload)).toString() != envelope['checksum']) {
    throw const FormatException('저장 파일이 손상됐어요.');
  }
  final state = GameState.fromJson(jsonDecode(payload) as Json);
  engine.validate(state);
  return state;
}

/// One SQLite row atomically holds both snapshots and the compare-and-swap revision.
/// No generated table model is needed for this intentionally small save store.
class SaveDatabase extends GeneratedDatabase {
  SaveDatabase([QueryExecutor? executor])
    : super(
        executor ??
            driftDatabase(
              name: 'office_worker_pixel_v1',
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.dart.js'),
              ),
            ),
      );
  @override
  int get schemaVersion => 1;
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables => const [];
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (_) async {
      await customStatement(
        'CREATE TABLE game_save (id INTEGER PRIMARY KEY CHECK (id=1), revision INTEGER NOT NULL, current TEXT NOT NULL, previous TEXT NOT NULL)',
      );
    },
  );
}

class SaveRepository {
  SaveRepository(this.database, this.engine);
  final SaveDatabase database;
  final GameEngine engine;
  String? _valid;

  Future<({GameState? state, int revision, bool recovered})> load() async {
    final row = await database
        .customSelect('SELECT * FROM game_save WHERE id=1')
        .getSingleOrNull();
    if (row == null) return (state: null, revision: 0, recovered: false);
    try {
      final raw = row.read<String>('current');
      final state = decodeSave(raw, engine);
      _valid = raw;
      return (
        state: state,
        revision: row.read<int>('revision'),
        recovered: false,
      );
    } catch (_) {
      final raw = row.read<String>('previous');
      final state = decodeSave(raw, engine);
      _valid = raw;
      return (
        state: state,
        revision: row.read<int>('revision'),
        recovered: true,
      );
    }
  }

  Future<GameState> commit(GameState state, int expectedRevision) async {
    final next = state.copy()..revision = expectedRevision + 1;
    engine.validate(next);
    final encoded = encodeSave(next);
    await database.transaction(() async {
      final row = await database
          .customSelect('SELECT * FROM game_save WHERE id=1')
          .getSingleOrNull();
      if ((row?.read<int>('revision') ?? 0) != expectedRevision) {
        throw StateError('다른 실행에서 저장이 바뀌었어요. 앱을 다시 열어 주세요.');
      }
      await database.customStatement(
        'INSERT OR REPLACE INTO game_save(id, revision, current, previous) VALUES (1, ?, ?, ?)',
        [next.revision, encoded, _valid ?? encoded],
      );
    });
    _valid = encoded;
    return next;
  }

  Future<String> rawExport() async {
    final row = await database
        .customSelect('SELECT * FROM game_save WHERE id=1')
        .getSingleOrNull();
    return jsonEncode(row?.data ?? {});
  }

  Future<void> resetCorrupted() async {
    await database.customStatement('DELETE FROM game_save WHERE id=1');
    _valid = null;
  }
}
