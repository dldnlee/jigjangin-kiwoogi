/// Authored projects and immutable choices. Durations use credited game time,
/// so projects share the existing eight-hour offline cap.
class ProjectApproach {
  const ProjectApproach({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.seconds,
    required this.reward,
    required this.performance,
    required this.reputation,
    required this.skill,
    this.successChance = 10000,
  });
  final String id, name, description, skill;
  final int cost, seconds, reward, performance, reputation, successChance;
}

class OfficeProject {
  const OfficeProject(
    this.id,
    this.title,
    this.description,
    this.approaches, {
    this.requires,
  });
  final String id, title, description;
  final String? requires;
  final List<ProjectApproach> approaches;
}

const officeProjects = [
  OfficeProject('presentation', '금요일 발표', '첫 발표를 맡았어요. 어떤 방식으로 준비할까요?', [
    ProjectApproach(
      id: 'solo',
      name: '혼자 꼼꼼히 준비',
      description: '자료를 직접 검토하며 전문성을 쌓아요.',
      cost: 1000,
      seconds: 180,
      reward: 6000,
      performance: 20,
      reputation: 1,
      skill: 'expertise',
    ),
    ProjectApproach(
      id: 'together',
      name: '동료와 함께 준비',
      description: '간식을 나누고 서로 발표를 연습해요.',
      cost: 2000,
      seconds: 240,
      reward: 5000,
      performance: 15,
      reputation: 5,
      skill: 'talk',
    ),
    ProjectApproach(
      id: 'rush',
      name: '빠르게 핵심만 준비',
      description: '시간을 아끼지만 발표가 아쉬울 수도 있어요.',
      cost: 500,
      seconds: 90,
      reward: 8000,
      performance: 25,
      reputation: 0,
      skill: 'work',
      successChance: 6500,
    ),
  ]),
  OfficeProject('report', '월간 보고서', '발표를 마쳤다면 이번에는 숫자로 설득해요.', [
    ProjectApproach(
      id: 'review',
      name: '근거를 하나씩 검토',
      description: '차근차근 검토해 확실한 성과를 만들어요.',
      cost: 1500,
      seconds: 180,
      reward: 7000,
      performance: 25,
      reputation: 2,
      skill: 'expertise',
    ),
    ProjectApproach(
      id: 'template',
      name: '업무 양식 정리',
      description: '양식을 개선해 짧은 시간에 정리해요.',
      cost: 1000,
      seconds: 120,
      reward: 5000,
      performance: 15,
      reputation: 1,
      skill: 'work',
    ),
  ], requires: 'presentation'),
  OfficeProject('team', '팀 공동 제안', '팀의 아이디어를 하나의 제안서로 모아요.', [
    ProjectApproach(
      id: 'coordinate',
      name: '의견을 모아 조율',
      description: '모두의 의견을 듣고 신뢰를 쌓아요.',
      cost: 2500,
      seconds: 240,
      reward: 9000,
      performance: 30,
      reputation: 8,
      skill: 'talk',
    ),
    ProjectApproach(
      id: 'prototype',
      name: '시제품으로 설득',
      description: '직접 만든 결과물로 가능성을 보여 줘요.',
      cost: 3000,
      seconds: 180,
      reward: 12000,
      performance: 40,
      reputation: 3,
      skill: 'expertise',
      successChance: 8000,
    ),
  ], requires: 'report'),
];

OfficeProject projectById(String id) => officeProjects.firstWhere(
  (p) => p.id == id,
  orElse: () => throw const FormatException('알 수 없는 프로젝트예요.'),
);
ProjectApproach approachById(OfficeProject project, String id) =>
    project.approaches.firstWhere(
      (a) => a.id == id,
      orElse: () => throw const FormatException('알 수 없는 준비 방식이에요.'),
    );

class ProjectRun {
  const ProjectRun(
    this.projectId,
    this.approachId,
    this.startedAt,
    this.roll, [
    this.helpers = const [],
  ]);
  final String projectId, approachId;
  final int startedAt, roll;

  /// Coworkers whose perks were active when the project started.
  final List<String> helpers;
  OfficeProject get project => projectById(projectId);
  ProjectApproach get approach => approachById(project, approachId);
  int get seconds => projectSeconds(approach, helpers);
  int get finishesAt => startedAt + seconds;
  int get successChance => projectChance(approach, helpers);
  int get reward => projectReward(approach, helpers);
  bool get succeeded => roll < successChance;
  Map<String, dynamic> toJson() => {
    'projectId': projectId,
    'approachId': approachId,
    'startedAt': startedAt,
    'roll': roll,
    if (helpers.isNotEmpty) 'helpers': helpers,
  };
  factory ProjectRun.fromJson(Map<String, dynamic> json) => ProjectRun(
    json['projectId'] as String,
    json['approachId'] as String,
    json['startedAt'] as int,
    json['roll'] as int,
    List<String>.from(json['helpers'] ?? const []),
  );
}

int projectSeconds(ProjectApproach a, List<String> helpers) =>
    helpers.contains('kim') ? a.seconds * 85 ~/ 100 : a.seconds;
int projectChance(ProjectApproach a, List<String> helpers) =>
    helpers.contains('park') && a.successChance < 10000
    ? (a.successChance + 1000).clamp(0, 10000)
    : a.successChance;
int projectReward(ProjectApproach a, List<String> helpers) =>
    helpers.contains('lee') ? a.reward * 110 ~/ 100 : a.reward;
