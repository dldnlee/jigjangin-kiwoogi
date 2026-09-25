import 'dart:convert';
import 'dart:math' as math;

import 'office_style.dart';
export 'office_style.dart';
import 'coworkers.dart';
import 'projects.dart';
export 'coworkers.dart';
export 'projects.dart';

typedef Json = Map<String, dynamic>;

class GameContent {
  GameContent(Json json)
    : ranks = (json['ranks'] as List).cast<Json>(),
      companies = (json['companies'] as List).cast<Json>(),
      upgrades = (json['upgrades'] as List).cast<Json>(),
      skills = (json['skills'] as List).cast<Json>(),
      equipment = (json['equipment'] as List).cast<Json>(),
      events = (json['events'] as List).cast<Json>(),
      slots = Map<String, String>.from(json['slots']);

  final List<Json> ranks, companies, upgrades, skills, equipment, events;
  final Map<String, String> slots;
  Json item(String id) => equipment.firstWhere((v) => v['id'] == id);
  Json company(String id) => companies.firstWhere((v) => v['id'] == id);
  Json event(String id) => events.firstWhere((v) => v['id'] == id);
}

class GameState {
  GameState({required this.lastMs, this.seed = 1}) {
    random = {
      'promotion': seed,
      'offers': nextRandom(seed),
      'events': nextRandom(nextRandom(seed)),
      'projects': nextRandom(nextRandom(nextRandom(seed))),
    };
  }
  int lastMs, seed;
  int revision = 0, seconds = 0, remainderMs = 0;
  BigInt cash = BigInt.zero, earned = BigInt.zero;
  int level = 1, xp = 0, xpRemainder = 0, rank = 0;
  String companyId = 'paper_sprout';
  int negotiated = 0, performance = 0, reputation = 0;
  Map<String, int> upgrades = {'speed': 0, 'efficiency': 0, 'focus': 0};
  Map<String, int> skills = {'work': 0, 'expertise': 0, 'talk': 0};
  List<String> inventory = [];
  Map<String, String> equipped = {};
  int failures = 0, nextAttempt = 0;
  late Map<String, int> random;
  List<Json> offers = [], journal = [];
  Json? pending, offline;
  Map<String, int> cooldowns = {};
  List<String> receipts = [];
  bool reducedMotion = false, sound = false;

  Map<String, String> officeStyle = {};

  ProjectRun? activeProject;
  List<String> completedProjects = [];

  /// Coworker id → friendship 0–100, last chat time, and last topic id.
  Map<String, int> relationships = {}, lastChats = {};
  Map<String, String> chatMemories = {};

  int friendship(String id) => relationships[id] ?? 0;
  List<String> get helpers => [
    for (final c in coworkers)
      if (friendship(c.id) >= coworkerPerkAt) c.id,
  ];

  bool get unlocked => upgrades.values.any((v) => v > 0);
  int get age => 22 + seconds ~/ 43200;
  int get xpNeeded => 100 * level * level;

  Json toJson() => {
    'version': 1,
    'config': 'flutter-pixel-slice-1',
    'lastMs': lastMs,
    'seed': seed,
    'revision': revision,
    'seconds': seconds,
    'remainderMs': remainderMs,
    'cash': cash.toString(),
    'earned': earned.toString(),
    'level': level,
    'xp': xp,
    'xpRemainder': xpRemainder,
    'rank': rank,
    'companyId': companyId,
    'negotiated': negotiated,
    'performance': performance,
    'reputation': reputation,
    'upgrades': upgrades,
    'skills': skills,
    'inventory': inventory,
    'equipped': equipped,
    'failures': failures,
    'nextAttempt': nextAttempt,
    'random': random,
    'offers': offers,
    'journal': journal,
    'pending': pending,
    'offline': offline,
    'cooldowns': cooldowns,
    'receipts': receipts,
    'reducedMotion': reducedMotion,
    'sound': sound,
    'activeProject': activeProject?.toJson(),
    'completedProjects': completedProjects,
    'relationships': relationships,
    'lastChats': lastChats,
    'chatMemories': chatMemories,
    'officeStyle': officeStyle,
  };

  factory GameState.fromJson(Json j) {
    if (j['version'] != 1 || j['config'] != 'flutter-pixel-slice-1') {
      throw const FormatException('지원하지 않는 저장 버전이에요.');
    }
    final s = GameState(lastMs: j['lastMs'] as int, seed: j['seed'] as int);
    s.revision = j['revision'];
    s.seconds = j['seconds'];
    s.remainderMs = j['remainderMs'];
    s.cash = BigInt.parse(j['cash'] as String);
    s.earned = BigInt.parse(j['earned'] as String);
    s.level = j['level'];
    s.xp = j['xp'];
    s.xpRemainder = j['xpRemainder'];
    s.rank = j['rank'];
    s.companyId = j['companyId'];
    s.negotiated = j['negotiated'];
    s.performance = j['performance'];
    s.reputation = j['reputation'];
    s.upgrades = Map<String, int>.from(j['upgrades']);
    s.skills = Map<String, int>.from(j['skills']);
    s.inventory = List<String>.from(j['inventory']);
    s.equipped = Map<String, String>.from(j['equipped']);
    s.failures = j['failures'];
    s.nextAttempt = j['nextAttempt'];
    s.random = Map<String, int>.from(j['random']);
    s.offers = (j['offers'] as List)
        .map((v) => Map<String, dynamic>.from(v))
        .toList();
    s.journal = (j['journal'] as List)
        .map((v) => Map<String, dynamic>.from(v))
        .toList();
    s.pending = j['pending'] == null
        ? null
        : Map<String, dynamic>.from(j['pending']);
    s.offline = j['offline'] == null
        ? null
        : Map<String, dynamic>.from(j['offline']);
    s.cooldowns = Map<String, int>.from(j['cooldowns']);
    s.receipts = List<String>.from(j['receipts']);
    s.reducedMotion = j['reducedMotion'];
    s.sound = j['sound'];
    s.random.putIfAbsent(
      'projects',
      () => nextRandom(nextRandom(nextRandom(s.seed))),
    );
    s.activeProject = j['activeProject'] == null
        ? null
        : ProjectRun.fromJson(Map<String, dynamic>.from(j['activeProject']));
    s.completedProjects = List<String>.from(j['completedProjects'] ?? const []);
    s.relationships = Map<String, int>.from(j['relationships'] ?? const {});
    s.lastChats = Map<String, int>.from(j['lastChats'] ?? const {});
    s.chatMemories = Map<String, String>.from(j['chatMemories'] ?? const {});
    s.officeStyle = Map<String, String>.from(j['officeStyle'] ?? const {});
    return s;
  }
  GameState copy() =>
      GameState.fromJson(jsonDecode(jsonEncode(toJson())) as Json);
}

int nextRandom(int seed) {
  var x = seed & 0xffffffff;
  x = (x ^ (x << 13)) & 0xffffffff;
  x = (x ^ (x >>> 17)) & 0xffffffff;
  return (x ^ (x << 5)) & 0xffffffff;
}

BigInt upgradeCost(int base, int level, [int growth = 115]) {
  final denominator = BigInt.from(100).pow(level);
  return (BigInt.from(base) * BigInt.from(growth).pow(level) +
          denominator -
          BigInt.one) ~/
      denominator;
}

class Requirement {
  const Requirement(this.label, this.current, this.target);
  final String label;
  final int current, target;
  bool get met => current >= target;
  double get progress => target == 0 ? 1 : (current / target).clamp(0, 1);
}

class GameEngine {
  GameEngine(this.content);
  final GameContent content;
  static final maxMoney = BigInt.from(10).pow(30);

  int skill(GameState s, String id) =>
      (s.skills[id]! +
              s.equipped.values.fold<int>(
                0,
                (total, item) =>
                    total +
                    ((content.item(item)['flat'] as Map)[id] as int? ?? 0),
              ))
          .clamp(0, 150);

  BigInt rate(GameState s) {
    var r = BigInt.from(content.ranks[s.rank]['rate'] as int);
    r =
        r *
        BigInt.from(
          (content.company(s.companyId)['salary'] as int) + s.negotiated,
        ) ~/
        BigInt.from(10000);
    r =
        r *
        BigInt.from(
          10000 + 500 * s.upgrades['speed']! + 500 * s.upgrades['efficiency']!,
        ) ~/
        BigInt.from(10000);
    r = r * BigInt.from(10000 + 100 * skill(s, 'work')) ~/ BigInt.from(10000);
    final gear = s.equipped.values.fold<int>(
      0,
      (a, id) => a + (content.item(id)['income'] as int),
    );
    return r * BigInt.from(10000 + math.min(3000, gear)) ~/ BigInt.from(10000);
  }

  int xpRate(GameState s) =>
      1000 + 100 * s.upgrades['focus']! + 20 * skill(s, 'expertise');
  List<Requirement> requirements(GameState s) {
    if (s.rank == content.ranks.length - 1) return [];
    final t = content.ranks[s.rank + 1];
    return [
      Requirement('레벨', s.level, t['level']),
      Requirement('성과', s.performance, t['performance']),
      Requirement('업무력', skill(s, 'work'), t['work']),
      Requirement('전문성', skill(s, 'expertise'), t['expertise']),
      Requirement('평판', s.reputation, t['reputation']),
    ];
  }

  int chance(GameState s) => s.failures >= 3
      ? 10000
      : math.min(
          10000,
          7000 -
              (content.company(s.companyId)['difficulty'] as int) +
              1000 * s.failures,
        );
  bool canPromote(GameState s) =>
      s.rank < content.ranks.length - 1 &&
      s.seconds >= s.nextAttempt &&
      requirements(s).every((v) => v.met);
  void _credit(GameState s, BigInt value) {
    s.cash = (s.cash + value).clamp(BigInt.zero, maxMoney);
    s.earned = (s.earned + value).clamp(BigInt.zero, maxMoney);
  }

  int _draw(GameState s, String stream, int max) {
    final limit = 4294967296 - 4294967296 % max;
    int n;
    do {
      n = nextRandom(s.random[stream]!);
      s.random[stream] = n;
    } while (n >= limit);
    return n % max;
  }

  void _log(GameState s, String message) {
    s.journal.insert(0, {'seconds': s.seconds, 'text': message});
    if (s.journal.length > 500) s.journal.removeLast();
  }

  void _befriend(GameState s, String id, int amount) {
    final before = s.friendship(id);
    s.relationships[id] = (before + amount).clamp(0, 100);
    if (before < coworkerPerkAt && s.relationships[id]! >= coworkerPerkAt) {
      final c = coworkerById(id);
      _log(s, '${josa(c.name, '와', '과')} 친해졌어요! 프로젝트 도움: ${c.perk}');
    }
  }

  int chatReady(GameState s, String id) =>
      s.lastChats.containsKey(id) ? s.lastChats[id]! + coworkerChatCooldown : 0;

  void _event(GameState s) {
    if (s.pending != null) return;
    final eligible =
        content.events
            .where((v) => (s.cooldowns[v['id']] ?? 0) <= s.seconds)
            .toList()
          ..sort((a, b) => (a['id'] as String).compareTo(b['id'] as String));
    if (eligible.isEmpty) return;
    final categories = [
      false,
      true,
    ].where((p) => eligible.any((e) => e['positive'] == p)).toList();
    final category = categories[_draw(s, 'events', categories.length)];
    final pool = eligible.where((v) => v['positive'] == category).toList();
    final event = pool[_draw(s, 'events', pool.length)];
    s.pending = {
      'id': 'event-${s.seconds}',
      'eventId': event['id'],
      'rate': rate(s).toString(),
    };
    s.cooldowns[event['id']] = s.seconds + 1800;
  }

  GameState advance(GameState original, int duration) {
    if (duration < 0 || duration > 28800) {
      throw ArgumentError('Invalid elapsed duration');
    }
    final s = original.copy();
    final end = s.seconds + duration;
    while (s.seconds < end) {
      final minute = (s.seconds ~/ 60 + 1) * 60;
      final offer = (s.seconds ~/ 600 + 1) * 600;
      final event = s.seconds < 120
          ? 120
          : 120 + ((s.seconds - 120) ~/ 300 + 1) * 300;
      final boundary = [end, minute, offer, event].reduce(math.min);
      final dt = boundary - s.seconds;
      _credit(s, rate(s) * BigInt.from(dt));
      final milliXp = xpRate(s) * dt + s.xpRemainder;
      s.xp += milliXp ~/ 1000;
      s.xpRemainder = milliXp % 1000;
      while (s.level < 100 && s.xp >= s.xpNeeded) {
        s.xp -= s.xpNeeded;
        s.level++;
      }
      s.xp = math.min(1000000000000, s.xp);
      s.seconds = boundary;
      if (boundary == minute) {
        s.performance = math.min(
          1000,
          s.performance + 6 + skill(s, 'work') ~/ 10,
        );
      }
      s.offers.removeWhere((o) => o['expires'] <= s.seconds);
      if (boundary == offer && s.rank >= 1) {
        final pool = content.companies
            .where((c) => c['id'] != s.companyId)
            .toList();
        s.offers = [];
        while (pool.isNotEmpty) {
          final c = pool.removeAt(_draw(s, 'offers', pool.length));
          s.offers.add({
            'id': '$boundary-${c['id']}',
            'company': c['id'],
            'expires': boundary + 1800,
          });
        }
      }
      if (boundary == event) _event(s);
    }
    return s;
  }

  GameState settle(GameState original, int now, {bool away = false}) {
    final elapsed = math.max(0, now - original.lastMs);
    final credited = math.min(elapsed, 28800000) + original.remainderMs;
    final s = advance(original, credited ~/ 1000);
    s.remainderMs = credited % 1000;
    s.lastMs = math.max(now, original.lastMs);
    if (away && elapsed >= 60000) {
      s.offline = {
        'seconds': credited ~/ 1000 + (s.offline?['seconds'] as int? ?? 0),
        'cash':
            (s.cash -
                    original.cash +
                    BigInt.parse(s.offline?['cash'] as String? ?? '0'))
                .toString(),
        'capped':
            elapsed > 28800000 || (s.offline?['capped'] as bool? ?? false),
      };
    }
    return s;
  }

  ({GameState state, String message}) command(
    GameState original,
    String kind, {
    String key = '',
    int choice = 0,
    bool value = false,
    required String id,
    required int expectedRevision,
  }) {
    if (original.receipts.contains(id)) {
      return (state: original, message: '이미 반영됐어요.');
    }
    if (original.revision != expectedRevision) {
      throw StateError('화면이 갱신됐어요. 다시 시도해 주세요.');
    }
    final s = original.copy();
    String message;
    void pay(BigInt price) {
      if (s.cash < price) throw StateError('급여를 조금 더 모아 주세요.');
      s.cash -= price;
    }

    switch (kind) {
      case 'upgrade':
        final u = content.upgrades.firstWhere((v) => v['id'] == key);
        final level = s.upgrades[key]!;
        if (level >= 200) throw StateError('최대 레벨이에요.');
        pay(upgradeCost(u['base'], level));
        s.upgrades[key] = level + 1;
        message = '${u['name']} 레벨 ${level + 1}!';
      case 'train':
        if (!s.unlocked) throw StateError('먼저 업그레이드를 구매해 주세요.');
        final k = content.skills.firstWhere((v) => v['id'] == key);
        final level = s.skills[key]!;
        if (level >= 100) throw StateError('최대 레벨이에요.');
        pay(upgradeCost(1000, level, 118));
        s.skills[key] = level + 1;
        message = '${k['name']}이 성장했어요!';
      case 'gear':
        final g = content.item(key);
        if (!s.unlocked || s.rank < (g['rank'] as int)) {
          throw StateError('장비 조건을 먼저 달성해 주세요.');
        }
        if (!s.inventory.contains(key)) {
          pay(BigInt.from(g['price'] as int));
          s.inventory.add(key);
        }
        s.equipped[g['slot']] = key;
        message = '${g['name']} 장착 완료!';
      case 'unequip':
        if (!content.slots.containsKey(key)) throw StateError('알 수 없는 장비 슬롯');
        s.equipped.remove(key);
        message = '장착을 해제했어요.';
      case 'promote':
        if (!canPromote(s)) throw StateError('승진 조건과 대기 시간을 확인해 주세요.');
        s.nextAttempt = s.seconds + 120;
        if (_draw(s, 'promotion', 10000) < chance(s)) {
          s.rank++;
          s.performance = 0;
          s.reputation = math.min(1000, s.reputation + 5);
          s.failures = 0;
          message = '${content.ranks[s.rank]['name']} 승진을 축하해요!';
          _log(s, message);
        } else {
          s.failures++;
          message = '다음 기회에는 확률 +10%p! (${s.failures}/3)';
        }
      case 'offer':
        final o = s.offers.firstWhere((v) => v['id'] == key);
        final c = content.company(o['company']);
        if (o['expires'] <= s.seconds ||
            s.rank < 1 ||
            skill(s, 'expertise') < (c['expertise'] as int)) {
          throw StateError('제안의 기한과 전문성을 확인해 주세요.');
        }
        s.companyId = c['id'];
        s.negotiated = math.min(1000, 50 * skill(s, 'talk'));
        s.performance = 0;
        s.offers = [];
        message = '${c['name']}에서 새로운 시작!';
        _log(s, message);
      case 'event':
        if (s.pending == null || s.pending!['id'] != key) {
          throw StateError('이미 끝난 이야기예요.');
        }
        final e = content.event(s.pending!['eventId']);
        final choices = e['choices'] as List;
        if (choice < 0 || choice >= choices.length) throw StateError('잘못된 선택');
        final c = choices[choice] as Map;
        if (skill(s, 'talk') < (c['talk'] as int? ?? 0)) {
          throw StateError('말빨을 더 키워 주세요.');
        }
        for (final effect in (c['effects'] as Map).entries) {
          final amount = effect.value as int;
          switch (effect.key) {
            case 'cash':
              _credit(
                s,
                BigInt.from(amount).clamp(
                  BigInt.zero,
                  BigInt.parse(s.pending!['rate']) * BigInt.from(300),
                ),
              );
            case 'performance':
              s.performance = (s.performance + amount).clamp(0, 1000);
            case 'reputation':
              s.reputation = (s.reputation + amount).clamp(0, 1000);
            case 'stress':
              break;
          }
        }
        message = c['text'];
        _log(s, '${e['title']} · $message');
        s.pending = null;
      case 'startProject':
        if (s.activeProject != null) throw StateError('진행 중인 프로젝트를 먼저 마쳐 주세요.');
        final project = projectById(key);
        if (s.completedProjects.contains(key)) {
          throw StateError('이미 완료한 프로젝트예요.');
        }
        if (project.requires != null &&
            !s.completedProjects.contains(project.requires)) {
          throw StateError('앞선 프로젝트를 먼저 완료해 주세요.');
        }
        if (choice < 0 || choice >= project.approaches.length) {
          throw StateError('준비 방식을 확인해 주세요.');
        }
        final approach = project.approaches[choice];
        pay(BigInt.from(approach.cost));
        s.activeProject = ProjectRun(
          key,
          approach.id,
          s.seconds,
          _draw(s, 'projects', 10000),
          s.helpers,
        );
        message = '${project.title} · ${approach.name} 시작!';
        if (s.helpers.isNotEmpty) {
          message +=
              ' (${s.helpers.map((id) => coworkerById(id).name).join(', ')} 도움)';
        }
        _log(s, message);
      case 'claimProject':
        final run = s.activeProject;
        if (run == null || run.projectId != key) {
          throw StateError('이미 끝난 프로젝트예요.');
        }
        if (s.seconds < run.finishesAt) throw StateError('아직 준비 중이에요.');
        final approach = run.approach;
        if (run.succeeded) {
          _credit(s, BigInt.from(run.reward));
          s.performance = (s.performance + approach.performance).clamp(0, 1000);
          s.reputation = (s.reputation + approach.reputation).clamp(0, 1000);
          s.skills[approach.skill] = (s.skills[approach.skill]! + 1).clamp(
            0,
            100,
          );
          message = '${run.project.title} 성공! 보상 ${run.reward}원 · 능력 +1';
        } else {
          message =
              '${run.project.title} 아쉬운 마무리. 추가 보상은 없지만 다음 프로젝트에 도전할 수 있어요.';
        }
        s.completedProjects.add(run.projectId);
        s.activeProject = null;
        _log(s, message);
        // Collaborative approaches bring the whole team closer.
        if (approach.skill == 'talk') {
          for (final c in coworkers) {
            _befriend(s, c.id, run.succeeded ? 8 : 4);
          }
        }
        for (final id in run.helpers) {
          _befriend(s, id, 2);
        }
      case 'chat':
      case 'coffee':
        final c = coworkerById(key);
        if (s.seconds < chatReady(s, key)) {
          throw StateError(
            '${josa(c.name, '는', '은')} 지금 바빠요. 조금 뒤에 말을 걸어 주세요.',
          );
        }
        if (kind == 'coffee') {
          pay(BigInt.from(coworkerCoffeeCost));
          _befriend(s, key, 8);
          message = '${c.name}에게 커피를 건넸어요. 친밀도 +8';
          _log(s, '${josa(c.name, '와', '과')} 커피 한 잔');
        } else {
          if (choice < 0 || choice >= c.topics.length) {
            throw StateError('대화 주제를 확인해 주세요.');
          }
          final topic = c.topics[choice];
          final gain = topic.id == c.favorite ? 5 : 3;
          _befriend(s, key, gain);
          s.chatMemories[key] = topic.id;
          message = '${c.name} ${topic.reply} 친밀도 +$gain';
          _log(s, '${josa(c.name, '와', '과')} ${topic.label}');
        }
        s.lastChats[key] = s.seconds;
      case 'decorate':
        final decoration = decorationById(key);
        if (!decoration.unlocked(s.level, s.rank)) {
          throw StateError(decoration.requirement);
        }
        s.officeStyle[decoration.slot] = decoration.id;
        message = '${decoration.name} 적용 완료!';
      case 'dismissOffline':
        s.offline = null;
        message = '다시 만나 반가워요!';
      case 'motion':
        s.reducedMotion = value;
        message = '설정을 저장했어요.';
      case 'sound':
        s.sound = value;
        message = '설정을 저장했어요.';
      default:
        throw StateError('지원하지 않는 요청이에요.');
    }
    s.revision++;
    s.receipts.add(id);
    if (s.receipts.length > 1000) s.receipts.removeAt(0);
    validate(s);
    return (state: s, message: message);
  }

  void validate(GameState s) {
    void range(int v, int max) {
      if (v < 0 || v > max) throw const FormatException('저장 범위를 확인해 주세요.');
    }

    range(s.seconds, 1000000000000);
    range(s.lastMs, 9007199254740991);
    range(s.revision, 1000000000000);
    range(s.remainderMs, 999);
    range(s.xpRemainder, 999);
    range(s.level, 100);
    range(s.xp, 1000000000000);
    range(s.rank, content.ranks.length - 1);
    range(s.performance, 1000);
    range(s.reputation, 1000);
    range(s.failures, 3);
    range(s.nextAttempt, 1000000000000);
    range(s.negotiated, 1000);
    if (s.level < 1 ||
        s.cash < BigInt.zero ||
        s.cash > maxMoney ||
        s.earned < BigInt.zero ||
        s.earned > maxMoney) {
      throw const FormatException('올바르지 않은 저장 파일');
    }
    for (final entry in s.officeStyle.entries) {
      final decoration = decorationById(entry.value);
      if (decoration.slot != entry.key ||
          !decoration.unlocked(s.level, s.rank)) {
        throw const FormatException('사무실 꾸미기 저장 오류');
      }
    }
    content.company(s.companyId);
    for (final id in ['speed', 'efficiency', 'focus']) {
      range(s.upgrades[id]!, 200);
    }
    for (final id in ['work', 'expertise', 'talk']) {
      range(s.skills[id]!, 100);
    }
    if (s.inventory.length > 15 ||
        s.inventory.toSet().length != s.inventory.length ||
        s.offers.length > 3 ||
        s.journal.length > 500 ||
        s.receipts.length > 1000) {
      throw const FormatException('저장 목록 오류');
    }
    for (final item in s.inventory) {
      content.item(item);
    }
    for (final entry in s.equipped.entries) {
      if (!s.inventory.contains(entry.value) ||
          content.item(entry.value)['slot'] != entry.key) {
        throw const FormatException('장비 저장 오류');
      }
    }
    if (s.completedProjects.length > officeProjects.length ||
        s.completedProjects.toSet().length != s.completedProjects.length) {
      throw const FormatException('프로젝트 기록 오류');
    }
    for (final id in s.completedProjects) {
      final project = projectById(id);
      if (project.requires != null &&
          !s.completedProjects.contains(project.requires)) {
        throw const FormatException('프로젝트 순서 오류');
      }
    }
    final run = s.activeProject;
    if (run != null) {
      final project = run.project;
      approachById(project, run.approachId);
      range(run.startedAt, s.seconds);
      range(run.roll, 9999);
      if (run.helpers.toSet().length != run.helpers.length) {
        throw const FormatException('프로젝트 동료 오류');
      }
      run.helpers.forEach(coworkerById);
      if (s.completedProjects.contains(run.projectId) ||
          (project.requires != null &&
              !s.completedProjects.contains(project.requires))) {
        throw const FormatException('진행 중인 프로젝트 오류');
      }
    }
    for (final entry in s.relationships.entries) {
      coworkerById(entry.key);
      range(entry.value, 100);
    }
    for (final entry in s.lastChats.entries) {
      coworkerById(entry.key);
      range(entry.value, s.seconds);
    }
    for (final entry in s.chatMemories.entries) {
      if (!coworkerById(entry.key).topics.any((t) => t.id == entry.value)) {
        throw const FormatException('동료 대화 기록 오류');
      }
    }
    for (final stream in ['promotion', 'offers', 'events', 'projects']) {
      range(s.random[stream]!, 4294967295);
      if (s.random[stream] == 0) throw const FormatException('난수 저장 오류');
    }
    for (final o in s.offers) {
      content.company(o['company']);
      range(o['expires'], 1000000000000);
      if (o['id'] is! String) throw const FormatException('제안 오류');
    }
    for (final entry in s.cooldowns.entries) {
      content.event(entry.key);
      range(entry.value, 1000000000000);
    }
    if (s.pending != null) {
      content.event(s.pending!['eventId']);
      if (s.pending!['id'] is! String ||
          BigInt.parse(s.pending!['rate']) < BigInt.zero) {
        throw const FormatException('이벤트 오류');
      }
    }
    if (s.offline != null) {
      range(s.offline!['seconds'], 1000000000000);
      if (BigInt.parse(s.offline!['cash']) < BigInt.zero ||
          s.offline!['capped'] is! bool) {
        throw const FormatException('오프라인 저장 오류');
      }
    }
    for (final j in s.journal) {
      range(j['seconds'], 1000000000000);
      if (j['text'] is! String || (j['text'] as String).length > 500) {
        throw const FormatException('일지 오류');
      }
    }
  }
}

extension BigIntBounds on BigInt {
  BigInt clamp(BigInt lower, BigInt upper) => this < lower
      ? lower
      : this > upper
      ? upper
      : this;
}
