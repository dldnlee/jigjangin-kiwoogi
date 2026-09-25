part of 'game_screen.dart';

extension _Coworkers on _GameScreenState {
  Future<void> _coworkers() => _sheet<void>(
    Consumer(
      builder: (context, ref, _) {
        final c = ref.watch(gameProvider);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('오늘도 잘 부탁해요', style: TextStyle(fontSize: 21)),
                ),
                IconButton(
                  tooltip: '닫기',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Text('동료', style: TextStyle(fontSize: 12, color: muted)),
            const SizedBox(height: 12),
            Text(
              '친밀도 $coworkerPerkAt 이상이면 프로젝트를 도와줘요. 도움은 프로젝트를 시작할 때 정해져요. 한 동료와는 ${coworkerChatCooldown ~/ 60}분마다 대화할 수 있어요.',
              style: const TextStyle(fontSize: 13, color: muted, height: 1.6),
            ),
            const SizedBox(height: 18),
            for (final coworker in coworkers) _coworkerCard(c, coworker),
          ],
        );
      },
    ),
  );

  Widget _coworkerCard(GameController c, Coworker coworker) {
    final state = c.state!;
    final value = state.friendship(coworker.id);
    final wait = math.max(
      0,
      engine.chatReady(state, coworker.id) - state.seconds,
    );
    final memory = state.chatMemories[coworker.id];
    final ready = wait == 0 && !c.busy;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: PixelPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    coworker.name,
                    style: const TextStyle(fontSize: 19),
                  ),
                ),
                Text(
                  coworker.role,
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              memory == null ? coworker.intro : coworker.memories[memory]!,
              key: ValueKey('coworker-line-${coworker.id}'),
              style: const TextStyle(fontSize: 13, height: 1.6),
            ),
            const SizedBox(height: 12),
            PixelMeter(value / 100),
            const SizedBox(height: 8),
            Text(
              '친밀도 $value/100 · ${coworkerTier(value)}',
              key: ValueKey('coworker-value-${coworker.id}'),
              style: const TextStyle(fontSize: 13, color: navy),
            ),
            const SizedBox(height: 4),
            Text(
              value >= coworkerPerkAt
                  ? '도움 중 · ${coworker.perk}'
                  : '친밀도 $coworkerPerkAt에 도움 · ${coworker.perk}',
              style: TextStyle(
                fontSize: 12,
                color: value >= coworkerPerkAt ? navy : muted,
                height: 1.6,
              ),
            ),
            if (wait > 0)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '지금은 업무 중 · ${durationLabel(wait)} 뒤에 다시 대화',
                  style: const TextStyle(fontSize: 12, color: coral),
                ),
              ),
            const SizedBox(height: 10),
            for (var i = 0; i < coworker.topics.length; i++) ...[
              PixelButton(
                key: ValueKey('chat-${coworker.id}-$i'),
                compact: true,
                primary: false,
                label: coworker.topics[i].label,
                onPressed: ready
                    ? () => act('chat', key: coworker.id, choice: i)
                    : null,
              ),
              const SizedBox(height: 8),
            ],
            PixelButton(
              key: ValueKey('coffee-${coworker.id}'),
              compact: true,
              label:
                  '커피 사 주기 · ${won(BigInt.from(coworkerCoffeeCost))} (친밀도 +8)',
              onPressed: ready && state.cash >= BigInt.from(coworkerCoffeeCost)
                  ? () => act('coffee', key: coworker.id)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
