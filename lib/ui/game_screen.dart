import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/game_controller.dart';
import '../domain/game.dart';
import 'pixel_widgets.dart';
import 'office_scene.dart';
part 'screens.dart';
part 'office_home.dart';
part 'decoration_screen.dart';
part 'projects_screen.dart';
part 'coworkers_screen.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({required this.page, super.key});
  final String page;
  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  bool _awayShown = false;
  String _gearFilter = 'all';

  void _filter(String value) {
    setState(() => _gearFilter = value);
  }

  GameController get controller => ref.read(gameProvider);
  GameState get s => controller.state!;
  GameEngine get engine => controller.engine;
  GameContent get content => engine.content;
  Future<void> act(
    String kind, {
    String key = '',
    int choice = 0,
    bool value = false,
  }) async {
    final message = await controller.act(
      kind,
      key: key,
      choice: choice,
      value: value,
    );
    if (mounted && message != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(gameProvider);
    if (c.state == null) return _boot(c);
    if (s.offline != null && !_awayShown) {
      _awayShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _away();
      });
    }
    if (s.offline == null) _awayShown = false;
    return ColoredBox(
      color: const Color(0xffcbd2df),
      child: Center(
        child: SizedBox(
          width: 480,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: navy,
              surfaceTintColor: Colors.transparent,
              title: const Text(
                '직장인 키우기',
                style: TextStyle(fontSize: 22, color: paper),
              ),
              leading: const Padding(
                padding: EdgeInsets.all(16),
                child: PixelIcon('office', size: 24, color: paper),
              ),
              actions: [
                if (widget.page != 'office')
                  IconButton(
                    tooltip: '프로젝트',
                    onPressed: _projects,
                    icon: Badge(
                      isLabelVisible:
                          s.activeProject != null &&
                          s.seconds >= s.activeProject!.finishesAt,
                      child: const PixelIcon('journal', size: 22, color: paper),
                    ),
                  ),
                IconButton(
                  tooltip: '설정',
                  onPressed: _settings,
                  icon: const PixelIcon('settings', size: 22, color: paper),
                ),
                const SizedBox(width: 6),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: Container(height: 2, color: border),
              ),
            ),
            body: SafeArea(
              top: false,
              bottom: false,
              child: Column(
                children: [
                  if (c.error != null)
                    MaterialBanner(
                      content: Text(
                        c.error!,
                        style: const TextStyle(fontSize: 13),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => c.save(),
                          child: const Text('다시 저장'),
                        ),
                      ],
                    ),
                  if (c.recoveryNotice != null)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        c.recoveryNotice!,
                        style: const TextStyle(fontSize: 12, color: muted),
                      ),
                    ),
                  Expanded(
                    child: widget.page == 'office'
                        ? _office()
                        : SingleChildScrollView(
                            key: PageStorageKey(widget.page),
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                            child: switch (widget.page) {
                              'career' => _career(),
                              'skills' => _skills(),
                              'equipment' => _equipment(),
                              'journal' => _journal(),
                              _ => _journal(),
                            },
                          ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _navigation(),
          ),
        ),
      ),
    );
  }

  Widget _boot(GameController c) => Scaffold(
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PixelIcon('office', size: 56, color: navy),
              const SizedBox(height: 24),
              Text(
                c.error == null ? '출근 준비 중...' : '저장을 확인해 주세요',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),
              Text(c.error ?? '작은 책상에서 시작하는 큰 내일', textAlign: TextAlign.center),
              if (c.error != null) ...[
                const SizedBox(height: 20),
                PixelButton(label: '다시 시도', onPressed: () => c.boot()),
                TextButton(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: await c.export()),
                    );
                  },
                  child: const Text('원본 백업 복사'),
                ),
                TextButton(onPressed: _reset, child: const Text('진행 초기화')),
              ],
            ],
          ),
        ),
      ),
    ),
  );
  Widget _navigation() => Container(
    decoration: const BoxDecoration(
      color: Color(0xfff5f7fb),
      border: Border(top: BorderSide(color: border, width: 2)),
    ),
    child: SafeArea(
      top: false,
      child: Row(
        children: [
          for (final pair in [
            ('office', '업무'),
            ('career', '커리어'),
            ('skills', '능력'),
            ('equipment', '장비'),
            ('journal', '일지'),
          ])
            Expanded(
              child: Semantics(
                selected: widget.page == pair.$1,
                button: true,
                label: pair.$2,
                child: InkWell(
                  onTap: () => context.go('/${pair.$1}'),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 70),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: widget.page == pair.$1
                        ? const Color(0xffdce6f7)
                        : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PixelIcon(
                          pair.$1,
                          size: 24,
                          color: widget.page == pair.$1 ? navy : muted,
                        ),
                        const SizedBox(height: 7),
                        Text(
                          pair.$2,
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.page == pair.$1 ? navy : muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
  Widget _title(String small, String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          small,
          style: const TextStyle(
            fontSize: 11,
            color: muted,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 25, color: ink, height: 1.4),
        ),
        const SizedBox(height: 7),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: muted, height: 1.6),
        ),
      ],
    ),
  );
  Future<T?> _sheet<T>(Widget child) => showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: paper,
    shape: const Border(top: BorderSide(color: ink, width: 3)),
    constraints: const BoxConstraints(maxWidth: 480),
    builder: (sheetContext) => SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          22,
          22,
          22,
          22 + MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: child,
      ),
    ),
  );
  Future<void> _event() async {
    final pending = s.pending;
    if (pending == null) return;
    final event = content.event(pending['eventId']);
    final choices = event['choices'] as List;
    final selected = await _sheet<int>(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PixelIcon('chat', size: 36, color: navy),
          const SizedBox(height: 17),
          Text(event['title'], style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 16),
          Text(event['body'], style: const TextStyle(height: 1.7)),
          const SizedBox(height: 22),
          for (var i = 0; i < choices.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PixelButton(
                primary: false,
                label:
                    '${choices[i]['text']}\n${_effects(choices[i]['effects'])}${choices[i]['talk'] != null ? ' · 말빨 ${choices[i]['talk']} 필요' : ''}',
                onPressed:
                    engine.skill(s, 'talk') >= (choices[i]['talk'] as int? ?? 0)
                    ? () => Navigator.pop(context, i)
                    : null,
              ),
            ),
          const Text(
            '선택하는 동안에도 급여는 쌓여요.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: muted),
          ),
        ],
      ),
    );
    if (selected != null) {
      await act('event', key: pending['id'], choice: selected);
    }
  }

  String _effects(Map effects) => effects.entries
      .map(
        (e) => switch (e.key) {
          'cash' => '+${won(BigInt.from(e.value))}',
          'performance' => '성과 +${e.value}',
          'reputation' => '평판 +${e.value}',
          _ => '잠깐의 여유',
        },
      )
      .join(' · ');
  Future<void> _away() async {
    final receipt = s.offline;
    if (receipt == null) return;
    await _sheet<void>(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PixelIcon('coin', size: 40, color: navy),
          const SizedBox(height: 20),
          const Text('자리를 비운 동안', style: TextStyle(fontSize: 26)),
          const SizedBox(height: 15),
          Text('${durationLabel(receipt['seconds'])} 동안 모았어요.'),
          const SizedBox(height: 24),
          Text(
            '+${won(BigInt.parse(receipt['cash']))}',
            style: const TextStyle(fontSize: 34, color: navy),
          ),
          const SizedBox(height: 18),
          Text(
            '보상이 이미 반영됐어요.${receipt['capped'] ? '\n최대 8시간까지 인정돼요.' : ''}',
            style: const TextStyle(fontSize: 14, color: muted),
          ),
          const SizedBox(height: 22),
          PixelButton(label: '계속하기', onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
    if (mounted) await act('dismissOffline');
  }

  Future<void> _confirmOffer(Json offer, Json company) async {
    final ok = await _sheet<bool>(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${company['name']}로 이직할까요?',
            style: const TextStyle(fontSize: 23),
          ),
          const SizedBox(height: 18),
          const Text(
            '직급과 능력은 유지돼요.\n현재 성과는 0으로 돌아가요.',
            style: TextStyle(height: 1.8),
          ),
          const SizedBox(height: 20),
          PixelButton(
            label: '이직하기',
            onPressed: () => Navigator.pop(context, true),
          ),
          const SizedBox(height: 10),
          PixelButton(
            label: '현재 회사에 남기',
            primary: false,
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
    if (ok == true) await act('offer', key: offer['id']);
  }

  Future<void> _settings() async {
    await _sheet<void>(
      Consumer(
        builder: (context, ref, _) {
          final c = ref.watch(gameProvider);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('나의 플레이 설정', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 17),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('효과음'),
                subtitle: const Text(
                  '기기의 시스템 클릭음',
                  style: TextStyle(fontSize: 12),
                ),
                value: c.state!.sound,
                onChanged: c.busy ? null : (v) => act('sound', value: v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('움직임 줄이기'),
                value: c.state!.reducedMotion,
                onChanged: c.busy ? null : (v) => act('motion', value: v),
              ),
              const SizedBox(height: 12),
              PixelButton(
                label: '백업 코드 복사',
                primary: false,
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: await c.export()),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('백업 코드를 복사했어요. 안전한 곳에 보관해 주세요.'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              PixelButton(
                label: '백업 코드 가져오기',
                primary: false,
                onPressed: () {
                  Navigator.pop(context);
                  _import();
                },
              ),
              const SizedBox(height: 12),
              PixelButton(
                label: '지금 저장하기',
                onPressed: c.busy ? null : () => c.save(),
              ),
              const SizedBox(height: 15),
              const Text(
                '5초마다 자동 저장 · 선택 후 즉시 저장\n백업은 본인 기기에 안전하게 보관해 주세요.',
                style: TextStyle(fontSize: 12, color: muted, height: 1.8),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _reset();
                },
                child: const Text(
                  '새로 시작하기',
                  style: TextStyle(color: Color(0xffbd413e)),
                ),
              ),
              const Text(
                'Neo둥근모 · SIL Open Font License 1.1',
                style: TextStyle(fontSize: 10, color: muted),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _reset() async {
    final ok = await _sheet<bool>(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('처음부터 시작할까요?', style: TextStyle(fontSize: 23)),
          const SizedBox(height: 18),
          const Text(
            '현재 진행과 장비, 일지가 삭제돼요.\n필요하면 먼저 백업 코드를 복사해 주세요.',
            style: TextStyle(height: 1.7),
          ),
          const SizedBox(height: 20),
          PixelButton(
            label: '진행 삭제 후 새로 시작',
            onPressed: () => Navigator.pop(context, true),
          ),
          const SizedBox(height: 10),
          PixelButton(
            label: '취소',
            primary: false,
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
    if (ok == true) await controller.reset();
  }

  Future<void> _import() async {
    final text = TextEditingController();
    final raw = await _sheet<String>(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('백업 코드 가져오기', style: TextStyle(fontSize: 23)),
          const SizedBox(height: 18),
          TextField(
            controller: text,
            maxLines: 5,
            maxLength: 5 * 1024 * 1024,
            decoration: const InputDecoration(
              hintText: '복사한 백업 코드를 붙여넣어 주세요.',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          PixelButton(
            label: '저장 확인',
            onPressed: () => Navigator.pop(context, text.text),
          ),
        ],
      ),
    );
    text.dispose();
    if (raw == null || !mounted) return;
    try {
      final preview = controller.previewImport(raw);
      final ok = await _sheet<bool>(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('이 커리어로 이어갈까요?', style: TextStyle(fontSize: 23)),
            const SizedBox(height: 17),
            Text(
              '${content.ranks[preview.rank]['name']} · LV.${preview.level}\n${won(preview.cash)}\n현재 진행을 이 백업으로 교체해요.',
              style: const TextStyle(height: 1.8),
            ),
            const SizedBox(height: 20),
            PixelButton(
              label: '현재 진행 교체하기',
              onPressed: () => Navigator.pop(context, true),
            ),
            const SizedBox(height: 10),
            PixelButton(
              label: '취소',
              primary: false,
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        ),
      );
      if (ok == true) await controller.importSave(raw);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('올바른 Flutter 백업 코드인지 확인해 주세요.')),
        );
      }
    }
  }
}
