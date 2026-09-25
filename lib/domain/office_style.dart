/// Cosmetic options reuse the reviewed room and sprite atlases. No gameplay
/// bonuses: milestones unlock free, reversible choices.
class OfficeDecoration {
  const OfficeDecoration(
    this.id,
    this.slot,
    this.name,
    this.description, {
    this.level = 1,
    this.rank,
    this.room,
  });
  final String id, slot, name, description;
  final int level;
  final int? rank, room;
  bool unlocked(int currentLevel, int currentRank) =>
      currentLevel >= level || (rank != null && currentRank >= rank!);
  String get requirement => level == 1
      ? '처음부터 사용 가능'
      : '레벨 $level${rank == null ? '' : ' 또는 직급 ${rank! + 1}단계'}에 열려요';
}

const decorationSlots = {
  'room': '공간',
  'desk': '책상',
  'plant': '화분',
  'pet': '고양이',
};
const defaultOfficeStyle = {
  'room': 'room-auto',
  'desk': 'desk-oak',
  'plant': 'plant-leafy',
  'pet': 'pet-orange',
};
const officeDecorations = [
  OfficeDecoration('room-auto', 'room', '성장에 맞춰 자동', '레벨과 승진에 따라 사무실이 바뀌어요.'),
  OfficeDecoration(
    'room-starter',
    'room',
    '처음의 작은 사무실',
    '처음 출근한 날의 아늑한 공간.',
    room: 0,
  ),
  OfficeDecoration(
    'room-open',
    'room',
    '햇살 가득 오픈 오피스',
    '탁 트인 서울 풍경을 즐겨요.',
    level: 6,
    rank: 1,
    room: 1,
  ),
  OfficeDecoration(
    'room-manager',
    'room',
    '차분한 개인 사무실',
    '따뜻한 나무 벽과 넓은 창문.',
    level: 11,
    rank: 2,
    room: 2,
  ),
  OfficeDecoration(
    'room-executive',
    'room',
    '노을빛 스카이라인',
    '퇴근 전 노을이 머무는 높은 층.',
    level: 16,
    rank: 3,
    room: 3,
  ),
  OfficeDecoration('desk-oak', 'desk', '기본 원목 책상', '익숙한 밝은 원목 상판.'),
  OfficeDecoration(
    'desk-walnut',
    'desk',
    '짙은 월넛 책상',
    '상판만 차분한 월넛 색으로 바꿔요.',
    level: 3,
  ),
  OfficeDecoration('plant-leafy', 'plant', '풍성한 초록 화분', '책상 옆을 지키는 커다란 초록 잎.'),
  OfficeDecoration(
    'plant-small',
    'plant',
    '작은 초록 화분',
    '같은 바닥 위치에 아담하게 놓아요.',
    level: 2,
  ),
  OfficeDecoration('plant-none', 'plant', '화분 쉬게 하기', '책상 옆 공간을 비워 두어요.'),
  OfficeDecoration('pet-orange', 'pet', '치즈 고양이', '조용히 낮잠을 자는 사무실 친구.'),
  OfficeDecoration(
    'pet-silver',
    'pet',
    '회색 고양이',
    '같은 편안한 자세, 부드러운 회색 털.',
    level: 4,
  ),
  OfficeDecoration('pet-none', 'pet', '고양이 쉬게 하기', '고양이는 다른 방에서 쉬어요.'),
];
OfficeDecoration decorationById(String id) => officeDecorations.firstWhere(
  (d) => d.id == id,
  orElse: () => throw const FormatException('알 수 없는 사무실 꾸미기예요.'),
);
String officeChoice(Map<String, String> selections, String slot) =>
    selections[slot] ?? defaultOfficeStyle[slot]!;
