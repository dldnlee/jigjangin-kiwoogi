part of 'game_screen.dart';

extension _Screens on _GameScreenState {
  Widget _upgrade(Json u) {
    final key = u['id'] as String;
    final level = s.upgrades[key]!;
    final cost = upgradeCost(u['base'], level);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PixelPanel(
        padding: const EdgeInsets.all(11),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              color: const Color(0xffe7ecd7),
              child: PixelIcon(key, size: 22, color: green),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${u['name']} LV.$level',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    u['desc'],
                    style: const TextStyle(fontSize: 11, color: muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            SizedBox(
              width: 90,
              child: PixelButton(
                label: level >= 200 ? 'MAX' : won(cost),
                compact: true,
                onPressed: !controller.busy && level < 200 && s.cash >= cost
                    ? () => act('upgrade', key: key)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _career() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _title('CAREER QUEST', '한 계단씩, 더 멀리.', '실력을 쌓고 다음 명함을 준비해요.'),
      PixelPanel(
        child: Column(
          children: [
            for (var i = 0; i < content.ranks.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: i <= s.rank ? green : const Color(0xffe5e7d3),
                        border: Border.all(color: border),
                      ),
                      child: Text(
                        i < s.rank ? '✓' : '${i + 1}',
                        style: TextStyle(color: i <= s.rank ? paper : muted),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        content.ranks[i]['name'],
                        style: TextStyle(color: i == s.rank ? green : ink),
                      ),
                    ),
                    Text(
                      i == s.rank
                          ? '지금 여기'
                          : i < s.rank
                          ? '달성'
                          : 'LV.${content.ranks[i]['level']}',
                      style: const TextStyle(fontSize: 12, color: muted),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      if (s.rank < 4)
        PixelPanel(
          color: const Color(0xffeef1df),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${content.ranks[s.rank + 1]['name']} 승진 준비',
                style: const TextStyle(fontSize: 21),
              ),
              const SizedBox(height: 18),
              for (final r in engine.requirements(s)) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(r.label, style: const TextStyle(fontSize: 14)),
                    Text(
                      '${r.current} / ${r.target} ${r.met ? '✓' : ''}',
                      style: const TextStyle(fontSize: 13, color: green),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                PixelMeter(r.progress),
                const SizedBox(height: 14),
              ],
              Text(
                '승진 가능성 ${engine.chance(s) ~/ 100}%',
                style: const TextStyle(fontSize: 19, color: green),
              ),
              const SizedBox(height: 6),
              Text(
                '최대 4번째 평가에서 확정 · 실패 ${s.failures}/3',
                style: const TextStyle(fontSize: 12, color: muted),
              ),
              const SizedBox(height: 15),
              PixelButton(
                label: s.nextAttempt > s.seconds
                    ? '${durationLabel(s.nextAttempt - s.seconds)} 후 평가'
                    : '승진 평가 받기',
                onPressed: !controller.busy && engine.canPromote(s)
                    ? () => act('promote')
                    : null,
              ),
              const SizedBox(height: 10),
              const Text(
                '무료 평가 · 재도전 대기 2분',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: muted),
              ),
            ],
          ),
        )
      else
        const PixelPanel(
          child: Text(
            '모든 직급 달성!\n장비 수집과 능력 개발은 계속돼요.',
            style: TextStyle(height: 1.8),
          ),
        ),
      const SizedBox(height: 25),
      const Text('새로운 회사, 새로운 기회', style: TextStyle(fontSize: 19)),
      const SizedBox(height: 8),
      Text(
        s.rank == 0
            ? '사원으로 승진하면 채용이 열려요.'
            : '다음 채용까지 ${durationLabel(600 - s.seconds % 600)}',
        style: const TextStyle(fontSize: 12, color: muted),
      ),
      const SizedBox(height: 14),
      for (final company in content.companies) _company(company),
    ],
  );
  Widget _company(Json c) {
    final matches = s.offers.where((o) => o['company'] == c['id']);
    final offer = matches.isEmpty ? null : matches.first;
    final qualified = engine.skill(s, 'expertise') >= (c['expertise'] as int);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: PixelPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const PixelIcon('office', size: 28, color: green),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(c['name'], style: const TextStyle(fontSize: 19)),
                ),
                if (s.companyId == c['id'])
                  const Text(
                    '근무 중',
                    style: TextStyle(fontSize: 12, color: green),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(c['desc'], style: const TextStyle(fontSize: 14, color: muted)),
            const SizedBox(height: 14),
            Text(
              '급여 ×${((c['salary'] as int) / 10000).toStringAsFixed(1)} · 평가 ${(7000 - (c['difficulty'] as int)) ~/ 100}%',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 7),
            Text(
              '전문성 ${c['expertise']} 필요 · 협상 +${math.min(1000, 50 * engine.skill(s, 'talk')) / 100}%p',
              style: const TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 14),
            PixelButton(
              label: s.companyId == c['id']
                  ? '현재 회사'
                  : offer == null
                  ? '다음 제안을 기다리는 중'
                  : qualified
                  ? '제안 수락'
                  : '전문성이 더 필요해요',
              primary: false,
              onPressed: offer != null && qualified && !controller.busy
                  ? () => _confirmOffer(offer, c)
                  : null,
            ),
            if (offer != null) ...[
              const SizedBox(height: 8),
              Text(
                '제안 유효 ${durationLabel(offer['expires'] - s.seconds)}',
                style: const TextStyle(fontSize: 11, color: muted),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _skills() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _title('SKILL UP!', '나에게 투자하는 시간.', '배운 능력은 이직해도 남아요.'),
      if (!s.unlocked) ...[
        const PixelPanel(color: gold, child: Text('업무에서 첫 업그레이드를 구매해 주세요.')),
        const SizedBox(height: 18),
      ],
      for (final k in content.skills)
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: PixelPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    PixelIcon(
                      k['id'] == 'talk' ? 'chat' : 'skills',
                      size: 30,
                      color: green,
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Text(
                        k['name'],
                        style: const TextStyle(fontSize: 23),
                      ),
                    ),
                    Text(
                      'LV.${s.skills[k['id']]}',
                      style: const TextStyle(fontSize: 20, color: green),
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                Text(
                  k['desc'],
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: muted,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '장비 포함 ${engine.skill(s, k['id'])} 레벨',
                  style: const TextStyle(fontSize: 13, color: green),
                ),
                const SizedBox(height: 16),
                PixelButton(
                  label: s.skills[k['id']]! >= 100
                      ? '최대 레벨'
                      : '훈련하기 · ${won(upgradeCost(1000, s.skills[k['id']]!, 118))}',
                  onPressed:
                      !controller.busy &&
                          s.unlocked &&
                          s.skills[k['id']]! < 100 &&
                          s.cash >= upgradeCost(1000, s.skills[k['id']]!, 118)
                      ? () => act('train', key: k['id'])
                      : null,
                ),
              ],
            ),
          ),
        ),
    ],
  );
  Widget _equipment() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _title('MY INVENTORY', '일잘러의 준비물.', '구매 후 바로 장착! 슬롯마다 하나씩.'),
      PixelPanel(
        color: const Color(0xffe7ecd8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${s.inventory.length}/15 보유 · ${won(s.cash)}',
              style: const TextStyle(fontSize: 16, color: green),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 9,
              runSpacing: 9,
              children: [
                for (final slot in content.slots.entries)
                  Tooltip(
                    message: s.equipped[slot.key] == null
                        ? '빈 ${slot.value}'
                        : content.item(s.equipped[slot.key]!)['name'],
                    child: InkWell(
                      onTap: s.equipped.containsKey(slot.key)
                          ? () => act('unequip', key: slot.key)
                          : null,
                      child: Container(
                        width: 58,
                        height: 62,
                        decoration: BoxDecoration(
                          color: s.equipped.containsKey(slot.key)
                              ? gold
                              : paper,
                          border: Border.all(color: border, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PixelIcon(slot.key, size: 22, color: green),
                            const SizedBox(height: 7),
                            Text(
                              slot.value,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              '장착된 슬롯을 누르면 해제해요.',
              style: TextStyle(fontSize: 11, color: muted),
            ),
          ],
        ),
      ),
      const SizedBox(height: 17),
      DropdownButtonFormField<String>(
        initialValue: _gearFilter,
        decoration: const InputDecoration(
          labelText: '장비 종류',
          border: OutlineInputBorder(borderRadius: BorderRadius.zero),
        ),
        items: [
          const DropdownMenuItem(value: 'all', child: Text('전체 장비')),
          for (final slot in content.slots.entries)
            DropdownMenuItem(value: slot.key, child: Text(slot.value)),
        ],
        onChanged: (v) => _filter(v!),
      ),
      const SizedBox(height: 18),
      for (final g in content.equipment.where(
        (g) => _gearFilter == 'all' || g['slot'] == _gearFilter,
      ))
        _gear(g),
    ],
  );
  Widget _gear(Json g) {
    final owned = s.inventory.contains(g['id']),
        equipped = s.equipped[g['slot']] == g['id'];
    final locked = s.rank < (g['rank'] as int) || !s.unlocked;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: PixelPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xffe7ecd6),
                  child: PixelIcon(g['slot'], size: 30, color: green),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${g['rarity']} · ${content.slots[g['slot']]}',
                        style: const TextStyle(fontSize: 11, color: muted),
                      ),
                      const SizedBox(height: 6),
                      Text(g['name'], style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              (g['flat'] as Map).entries
                      .map(
                        (e) =>
                            '${content.skills.firstWhere((v) => v['id'] == e.key)['name']} +${e.value}',
                      )
                      .join(' · ') +
                  (g['income'] > 0 ? ' · 급여 +2%p' : ''),
              style: const TextStyle(fontSize: 13, color: green),
            ),
            const SizedBox(height: 14),
            PixelButton(
              label: equipped
                  ? '✓ 장착 중'
                  : locked
                  ? '${s.unlocked ? content.ranks[g['rank']]['name'] : '첫 업그레이드'}부터 사용'
                  : owned
                  ? '장착하기'
                  : '${won(BigInt.from(g['price']))} · 구매 후 장착',
              primary: !owned,
              onPressed:
                  !controller.busy &&
                      !locked &&
                      !equipped &&
                      (owned || s.cash >= BigInt.from(g['price']))
                  ? () => act('gear', key: g['id'])
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _journal() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _title('MY STORY', '작은 순간, 나의 이야기.', '차곡차곡 쌓아 온 커리어를 돌아봐요.'),
      PixelPanel(
        color: gold,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '지금까지 번 급여와 보상',
              style: TextStyle(fontSize: 13, color: muted),
            ),
            const SizedBox(height: 10),
            Text(won(s.earned), style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 15),
            Text(
              '근무 ${durationLabel(s.seconds)}\n평판 ${s.reputation} · 보유 장비 ${s.inventory.length}',
              style: const TextStyle(fontSize: 14, height: 1.8),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      if (s.journal.isEmpty)
        const PixelPanel(
          child: Column(
            children: [
              PixelIcon('journal', size: 40, color: green),
              SizedBox(height: 20),
              Text('아직 첫 페이지예요.'),
              SizedBox(height: 8),
              Text(
                '승진과 이직, 사무실 선택이 기록돼요.',
                style: TextStyle(fontSize: 13, color: muted),
              ),
            ],
          ),
        ),
      for (final j in s.journal.take(100))
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: PixelPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  durationLabel(j['seconds']),
                  style: const TextStyle(fontSize: 11, color: muted),
                ),
                const SizedBox(height: 9),
                Text(
                  j['text'],
                  style: const TextStyle(fontSize: 15, height: 1.6),
                ),
              ],
            ),
          ),
        ),
      const SizedBox(height: 16),
      const Text(
        'FIRST CHAPTER · v0.2\n커리어, 능력, 장비와 20개의 이야기',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: muted, height: 1.8),
      ),
    ],
  );
}
