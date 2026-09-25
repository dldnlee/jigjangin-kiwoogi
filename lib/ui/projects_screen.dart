part of 'game_screen.dart';

extension _Projects on _GameScreenState {
  Future<void> _projects() => _sheet<void>(
    Consumer(
      builder: (context, ref, _) {
        final c = ref.watch(gameProvider);
        final state = c.state!;
        final run = state.activeProject;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('이번엔 내가 맡을게요', style: TextStyle(fontSize: 21)),
                ),
                IconButton(
                  tooltip: '닫기',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Text('프로젝트', style: TextStyle(fontSize: 12, color: muted)),
            const SizedBox(height: 12),
            Text(
              '보유 ${won(state.cash)} · 완료 ${state.completedProjects.length}/${officeProjects.length}',
              style: const TextStyle(color: navy),
            ),
            const SizedBox(height: 10),
            const Text(
              '한 번에 하나씩 맡아요. 급여는 계속 쌓이고, 자리를 비워도 최대 8시간까지 준비가 진행돼요.',
              style: TextStyle(fontSize: 13, color: muted, height: 1.6),
            ),
            const SizedBox(height: 18),
            if (run != null) _activeProject(c, run),
            for (final project in officeProjects)
              if (run?.projectId != project.id) _projectCard(c, project),
            if (state.completedProjects.length == officeProjects.length)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  '모든 프로젝트를 마쳤어요! 쌓은 성과로 다음 승진에 도전해 보세요.',
                  style: TextStyle(color: navy, height: 1.6),
                ),
              ),
          ],
        );
      },
    ),
  );

  Widget _activeProject(GameController c, ProjectRun run) {
    final remaining = math.max(0, run.finishesAt - c.state!.seconds);
    final ready = remaining == 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: PixelPanel(
        color: const Color(0xfffff4d2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(run.project.title, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text(run.approach.name, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 14),
            PixelMeter(1 - remaining / run.seconds),
            const SizedBox(height: 10),
            Text(
              ready
                  ? '준비 완료! 결과를 확인해 주세요.'
                  : '준비 중 · ${durationLabel(remaining)} 남음',
              key: const ValueKey('project-status'),
              style: const TextStyle(fontSize: 13, color: navy),
            ),
            const SizedBox(height: 10),
            Text(
              _projectReward(run.approach, run.helpers),
              style: const TextStyle(fontSize: 13, height: 1.6),
            ),
            if (run.helpers.isNotEmpty) _helpersNote(run.helpers),
            const SizedBox(height: 12),
            PixelButton(
              label: ready ? '결과 확인 · 보상 받기' : '준비 중이에요',
              onPressed: ready && !c.busy
                  ? () => act('claimProject', key: run.projectId)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  String _projectReward(ProjectApproach a, List<String> helpers) {
    final skill = {'work': '업무력', 'expertise': '전문성', 'talk': '말빨'}[a.skill];
    final team = a.skill == 'talk' ? '\n함께 준비하면 모든 동료 친밀도 +8 (실패 시 +4)' : '';
    return '${projectChance(a, helpers) == 10000 ? '확정 보상' : '성공 시 보상'} ${won(BigInt.from(projectReward(a, helpers)))}\n성과 +${a.performance} · 평판 +${a.reputation} · $skill +1 (최대 100)$team';
  }

  Widget _helpersNote(List<String> helpers) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Text(
      '동료 도움 · ${helpers.map((id) => '${coworkerById(id).name}(${coworkerById(id).perk})').join(', ')}',
      style: const TextStyle(fontSize: 12, color: navy, height: 1.6),
    ),
  );

  Widget _projectCard(GameController c, OfficeProject project) {
    final state = c.state!;
    final complete = state.completedProjects.contains(project.id);
    final locked =
        project.requires != null &&
        !state.completedProjects.contains(project.requires);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: PixelPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${complete ? '✓ ' : ''}${project.title}',
              style: const TextStyle(fontSize: 19),
            ),
            const SizedBox(height: 8),
            Text(
              complete ? '완료 · 결과는 일지에 남겼어요.' : project.description,
              style: const TextStyle(fontSize: 13, color: muted, height: 1.6),
            ),
            if (complete) ...[
              const SizedBox(height: 10),
              Text(
                state.journal
                            .where(
                              (entry) => (entry['text'] as String).startsWith(
                                project.title,
                              ),
                            )
                            .firstOrNull?['text']
                        as String? ??
                    '완료한 프로젝트예요.',
                style: const TextStyle(fontSize: 13, color: navy, height: 1.6),
              ),
            ],
            if (locked) ...[
              const SizedBox(height: 12),
              Text(
                '${projectById(project.requires!).title} 완료 후 열려요.',
                style: const TextStyle(fontSize: 13, color: muted),
              ),
            ] else if (!complete && state.activeProject == null) ...[
              if (state.helpers.isNotEmpty) _helpersNote(state.helpers),
              for (var i = 0; i < project.approaches.length; i++) ...[
                const SizedBox(height: 18),
                Text(
                  project.approaches[i].name,
                  style: const TextStyle(fontSize: 16, color: navy),
                ),
                const SizedBox(height: 6),
                Text(
                  project.approaches[i].description,
                  style: const TextStyle(fontSize: 13, height: 1.6),
                ),
                const SizedBox(height: 6),
                Text(
                  '준비 ${durationLabel(projectSeconds(project.approaches[i], state.helpers))} · 성공률 ${projectChance(project.approaches[i], state.helpers) ~/ 100}%\n${_projectReward(project.approaches[i], state.helpers)}',
                  style: const TextStyle(fontSize: 13, height: 1.6),
                ),
                if (projectChance(project.approaches[i], state.helpers) < 10000)
                  const Text(
                    '실패하면 준비 비용은 돌아오지 않고 추가 보상도 없어요. 다음 프로젝트는 열려요.',
                    style: TextStyle(fontSize: 12, color: coral, height: 1.6),
                  ),
                const SizedBox(height: 8),
                PixelButton(
                  key: ValueKey('start-${project.id}-$i'),
                  compact: true,
                  label: state.cash < BigInt.from(project.approaches[i].cost)
                      ? '${won(BigInt.from(project.approaches[i].cost))} 필요'
                      : '${won(BigInt.from(project.approaches[i].cost))} 지불하고 시작',
                  onPressed:
                      !c.busy &&
                          state.cash >= BigInt.from(project.approaches[i].cost)
                      ? () => act('startProject', key: project.id, choice: i)
                      : null,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
