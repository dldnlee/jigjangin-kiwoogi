part of 'game_screen.dart';

extension _Decoration on _GameScreenState {
  Future<void> _decorate() async {
    var slot = 'room';
    var preview = officeChoice(s.officeStyle, slot);
    var animate = false;
    await _sheet<void>(
      StatefulBuilder(
        builder: (context, updatePreview) => Consumer(
          builder: (context, ref, _) {
            final c = ref.watch(gameProvider);
            final state = c.state!;
            final option = decorationById(preview);
            final available = option.unlocked(state.level, state.rank);
            final applied = officeChoice(state.officeStyle, slot) == preview;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text('나만의 사무실', style: TextStyle(fontSize: 21)),
                    ),
                    IconButton(
                      tooltip: '닫기',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Text(
                  '성장하면 무료로 열려요. 미리보기는 저장되지 않고, 적용할 때만 내 사무실이 바뀌어요.',
                  style: TextStyle(fontSize: 13, color: muted, height: 1.6),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 250,
                  child: OfficeScene(
                    key: const ValueKey('decoration-preview'),
                    level: state.level,
                    rank: state.rank,
                    reducedMotion: state.reducedMotion || !animate,
                    fillSpace: true,
                    officeStyle: {...state.officeStyle, slot: preview},
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('미리보기 움직임', style: TextStyle(fontSize: 13)),
                  subtitle: state.reducedMotion
                      ? const Text(
                          '움직임 줄이기 설정이 켜져 있어요.',
                          style: TextStyle(fontSize: 12),
                        )
                      : null,
                  value: animate && !state.reducedMotion,
                  onChanged: state.reducedMotion
                      ? null
                      : (value) => updatePreview(() => animate = value),
                ),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final entry in decorationSlots.entries)
                      ChoiceChip(
                        label: Text(entry.value),
                        selected: slot == entry.key,
                        onSelected: (_) => updatePreview(() {
                          slot = entry.key;
                          preview = officeChoice(state.officeStyle, slot);
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                RadioGroup<String>(
                  groupValue: preview,
                  onChanged: (value) => updatePreview(() => preview = value!),
                  child: Column(
                    children: [
                      for (final item in officeDecorations.where(
                        (d) => d.slot == slot,
                      ))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: RadioListTile<String>(
                            title: Text(
                              item.name,
                              style: const TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              item.unlocked(state.level, state.rank)
                                  ? item.description
                                  : '잠김 · ${item.requirement}',
                              style: const TextStyle(fontSize: 12, height: 1.5),
                            ),
                            value: item.id,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  available
                      ? '무료 · 급여와 승진 조건은 바뀌지 않아요.'
                      : '미리보기 중 · ${option.requirement}',
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
                const SizedBox(height: 10),
                PixelButton(
                  key: const ValueKey('apply-decoration'),
                  label: applied
                      ? '이미 적용 중'
                      : available
                      ? '${decorationSlots[slot]} 적용하기'
                      : '아직 잠겨 있어요',
                  onPressed: available && !applied && !c.busy
                      ? () => act('decorate', key: preview)
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
