import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../data/save_repository.dart';
import '../domain/game.dart';

final gameProvider = ChangeNotifierProvider<GameController>(
  (ref) => GameController()..boot(),
);

class GameController extends ChangeNotifier with WidgetsBindingObserver {
  GameController.withDependencies(
    GameEngine engine,
    SaveRepository repository, {
    int Function()? clock,
  }) : this(engine: engine, repository: repository, clock: clock);
  GameController({this._engine, this._repository, int Function()? clock})
    : clock = clock ?? (() => DateTime.now().millisecondsSinceEpoch);
  GameEngine? _engine;
  SaveRepository? _repository;
  GameEngine get engine => _engine!;
  SaveRepository get repository => _repository!;
  final int Function() clock;
  GameState? state, _committed;
  int _revision = 0, _lastSave = 0, _commandIndex = 0;
  bool busy = false, background = false;
  String? error, recoveryNotice;
  Timer? _timer;

  Future<void> boot() async {
    busy = true;
    error = null;
    notifyListeners();
    try {
      _engine ??= GameEngine(
        GameContent(
          jsonDecode(await rootBundle.loadString('assets/data/content.json'))
              as Json,
        ),
      );
      _repository ??= SaveRepository(SaveDatabase(), engine);
      final loaded = await repository.load();
      _revision = loaded.revision;
      final initial =
          loaded.state ??
          GameState(
            lastMs: clock(),
            seed: Random.secure().nextInt(0x7ffffffe) + 1,
          );
      state = await repository.commit(
        engine.settle(initial, clock(), away: loaded.state != null),
        _revision,
      );
      _revision = state!.revision;
      _committed = state!.copy();
      _lastSave = clock();
      if (loaded.recovered) recoveryNotice = '이전 정상 저장에서 복구했어요.';
      WidgetsBinding.instance.addObserver(this);
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 250), (_) => tick());
    } catch (e) {
      error = '저장을 불러오지 못했어요. ${_message(e)}';
    }
    busy = false;
    notifyListeners();
  }

  void tick() {
    if (busy || background || error != null || state == null) return;
    state = engine.settle(state!, clock());
    notifyListeners();
    if (clock() - _lastSave >= 5000) unawaited(save());
  }

  Future<void> _commit(GameState next) async {
    try {
      state = await repository.commit(next, _revision);
      _revision = state!.revision;
      _committed = state!.copy();
      _lastSave = clock();
      error = null;
    } catch (e) {
      state = _committed?.copy();
      error = '저장하지 못했어요. ${_message(e)}';
      rethrow;
    }
  }

  Future<String?> act(
    String kind, {
    String key = '',
    int choice = 0,
    bool value = false,
  }) async {
    if (busy || state == null) return null;
    busy = true;
    notifyListeners();
    try {
      final settled = engine.settle(state!, clock());
      final result = engine.command(
        settled,
        kind,
        key: key,
        choice: choice,
        value: value,
        id: '${clock()}-${_commandIndex++}',
        expectedRevision: settled.revision,
      );
      await _commit(result.state);
      if (state!.sound) unawaited(SystemSound.play(SystemSoundType.click));
      return result.message;
    } catch (e) {
      return _message(e);
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> save({bool away = false}) async {
    if (busy || state == null) return;
    busy = true;
    try {
      await _commit(engine.settle(state!, clock(), away: away));
    } catch (_) {
      /* Retain visible recovery error. */
    }
    busy = false;
    notifyListeners();
  }

  Future<String> export() async =>
      state == null ? repository.rawExport() : encodeSave(state!);
  GameState previewImport(String text) => decodeSave(text, engine);
  Future<void> importSave(String text) async {
    if (busy) return;
    final candidate = previewImport(text);
    busy = true;
    try {
      candidate.lastMs = clock();
      candidate.remainderMs = 0;
      candidate.offline = null;
      await _commit(candidate);
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> reset() async {
    if (busy) return;
    if (state == null) {
      await repository.resetCorrupted();
      await boot();
      return;
    }
    busy = true;
    try {
      await _commit(
        GameState(
          lastMs: clock(),
          seed: Random.secure().nextInt(0x7ffffffe) + 1,
        ),
      );
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  String _message(Object e) => e.toString().replaceFirst(
    RegExp(r'^(Bad state: |FormatException: )'),
    '',
  );
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      background = false;
      unawaited(save(away: true));
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive) {
      background = true;
      unawaited(save());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_repository?.database.close());
    super.dispose();
  }
}
