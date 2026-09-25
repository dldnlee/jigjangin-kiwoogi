/// Recurring coworkers. Relationship values are 0–100; perks unlock at
/// [coworkerPerkAt] and are captured when a project starts, so a later change
/// in friendship never rewrites a project already in progress.
class ChatTopic {
  const ChatTopic(this.id, this.label, this.reply);
  final String id, label, reply;
}

class Coworker {
  const Coworker({
    required this.id,
    required this.name,
    required this.role,
    required this.intro,
    required this.favorite,
    required this.topics,
    required this.perk,
    required this.memories,
  });
  final String id, name, role, intro, favorite, perk;
  final List<ChatTopic> topics;

  /// Greeting that recalls the last topic, keyed by topic id.
  final Map<String, String> memories;
}

const coworkerPerkAt = 30;
const coworkerChatCooldown = 300;
const coworkerCoffeeCost = 1500;

const coworkers = [
  Coworker(
    id: 'park',
    name: '박 선배',
    role: '기획팀 과장',
    intro: '말은 짧지만 보고서는 누구보다 꼼꼼히 봐 줘요.',
    favorite: 'advice',
    topics: [
      ChatTopic('advice', '보고서 조언 구하기', '"결론부터 써. 근거는 그다음이야."'),
      ChatTopic('smalltalk', '주말 이야기', '"주말? 등산 갔지. …너도 쉬긴 쉬어라."'),
    ],
    perk: '프로젝트 성공률 +10%p',
    memories: {
      'advice': '"지난번 보고서, 결론부터 쓴 거 봤다."',
      'smalltalk': '"등산 이야기 또 하려고? 커피나 마셔."',
    },
  ),
  Coworker(
    id: 'kim',
    name: '김 대리',
    role: '옆자리 동기',
    intro: '야근 메이트. 단축키와 양식을 누구보다 많이 알아요.',
    favorite: 'smalltalk',
    topics: [
      ChatTopic('advice', '업무 요령 묻기', '"이 양식 복사해 가. 반은 끝난 거야."'),
      ChatTopic('smalltalk', '점심 메뉴 고민', '"오늘은 제육이다. 이견 없지?"'),
    ],
    perk: '프로젝트 준비 시간 -15%',
    memories: {
      'advice': '"그 양식 잘 쓰고 있지? 다음 것도 줄게."',
      'smalltalk': '"어제 제육 맛있었지? 오늘은 국밥이야."',
    },
  ),
  Coworker(
    id: 'lee',
    name: '이 인턴',
    role: '신입 인턴',
    intro: '열정 가득한 인턴. 자료 조사를 도와주고 싶어 해요.',
    favorite: 'advice',
    topics: [
      ChatTopic('advice', '일 가르쳐 주기', '"우와, 메모할게요! 감사합니다!"'),
      ChatTopic('smalltalk', '회사 적응 묻기', '"아직 긴장돼요. 그래도 재밌어요!"'),
    ],
    perk: '프로젝트 성공 보상 +10%',
    memories: {
      'advice': '"알려 주신 방법으로 자료 정리했어요!"',
      'smalltalk': '"요즘은 덜 긴장돼요. 챙겨 주셔서요!"',
    },
  ),
];

Coworker coworkerById(String id) => coworkers.firstWhere(
  (c) => c.id == id,
  orElse: () => throw const FormatException('알 수 없는 동료예요.'),
);

String coworkerTier(int value) => value >= 70
    ? '든든한 동료'
    : value >= coworkerPerkAt
    ? '친한 사이'
    : value >= 10
    ? '인사하는 사이'
    : '어색한 사이';

/// Appends the particle matching the final syllable, e.g. 선배와 / 인턴과.
String josa(String word, String vowel, String consonant) {
  final code = word.codeUnitAt(word.length - 1);
  final batchim = code >= 0xac00 && code <= 0xd7a3 && (code - 0xac00) % 28 > 0;
  return '$word${batchim ? consonant : vowel}';
}
