part of 'game_screen.dart';

extension _OfficeHome on _GameScreenState {
  Widget _office() => Padding(
    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
    child: Column(
      key: const ValueKey('fixed-office-home'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xfffafbff),
            border: Border.all(color: border, width: 2),
          ),
          child: Row(
            children: [
              const PixelIcon('coin', size: 28, color: Color(0xffb57b12)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '내 지갑',
                      style: TextStyle(fontSize: 11, color: muted),
                    ),
                    Semantics(
                      label: '잔액 ${s.cash}원',
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          won(s.cash),
                          style: const TextStyle(fontSize: 25, color: ink),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    '자동 급여',
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                  Text(
                    '+${won(engine.rate(s))}/초',
                    style: const TextStyle(fontSize: 12, color: navy),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text(
                'LV.${s.level}',
                style: const TextStyle(fontSize: 12, color: onBackdrop),
              ),
              const SizedBox(width: 8),
              Expanded(child: PixelMeter(s.xp / s.xpNeeded)),
              const SizedBox(width: 8),
              Text(
                '${s.xp}/${s.xpNeeded}',
                style: const TextStyle(fontSize: 10, color: onBackdrop),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            key: const ValueKey('fixed-office-stage'),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: paper,
              border: Border.all(color: border, width: 2),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '김사원 · ${content.ranks[s.rank]['name']}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        content.company(s.companyId)['name'],
                        style: const TextStyle(fontSize: 11, color: muted),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: OfficeScene(
                    key: const ValueKey('office-scene'),
                    officeStyle: s.officeStyle,
                    level: s.level,
                    rank: s.rank,
                    reducedMotion: s.reducedMotion,
                    fillSpace: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: PixelButton(
                label:
                    s.activeProject != null &&
                        s.seconds >= s.activeProject!.finishesAt
                    ? '프로젝트 완료!'
                    : '업무 업그레이드',
                compact: true,
                onPressed:
                    s.activeProject != null &&
                        s.seconds >= s.activeProject!.finishesAt
                    ? _projects
                    : _upgrades,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: PixelButton(
                label: s.pending != null ? '새 이야기!' : '다음 승진',
                compact: true,
                primary: false,
                onPressed: s.pending != null
                    ? _event
                    : () => context.go('/career'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Text(
          '출근 ${s.seconds ~/ 3600 + 1}개월차 · ${s.age}세 · 오프라인 급여 최대 8시간',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: onBackdrop),
        ),
      ],
    ),
  );

  Future<void> _upgrades() async {
    final destination = await _sheet<String>(
      Consumer(
        builder: (context, ref, _) {
          ref.watch(gameProvider);
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('오늘의 작은 업그레이드', style: TextStyle(fontSize: 19)),
                  ),
                  IconButton(
                    tooltip: '닫기',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '보유 ${won(s.cash)} · 초당 ${won(engine.rate(s))}',
                style: const TextStyle(fontSize: 13, color: navy),
              ),
              const SizedBox(height: 16),
              PixelButton(
                label: s.activeProject == null
                    ? '프로젝트로 성과 쌓기'
                    : '진행 중인 프로젝트 보기',
                primary: false,
                onPressed: () => Navigator.pop(context, 'projects'),
              ),
              const SizedBox(height: 10),
              PixelButton(
                label: '동료와 가까워지기',
                primary: false,
                onPressed: () => Navigator.pop(context, 'coworkers'),
              ),
              const SizedBox(height: 16),
              PixelButton(
                label: '사무실 꾸미기',
                primary: false,
                onPressed: () => Navigator.pop(context, 'decorate'),
              ),
              const SizedBox(height: 16),
              const Text(
                '버튼을 길게 누르면 연속으로 업그레이드해요.',
                style: TextStyle(fontSize: 12, color: muted),
              ),
              const SizedBox(height: 10),
              for (final upgrade in content.upgrades) _upgrade(upgrade),
            ],
          );
        },
      ),
    );
    if (!mounted) return;
    if (destination == 'projects') await _projects();
    if (destination == 'coworkers') await _coworkers();
    if (destination == 'decorate') await _decorate();
  }
}
