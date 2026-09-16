import 'dart:math';

enum OfficeMoment { working, deadline, approved, feedback, coffee, meeting }

extension OfficeMomentCopy on OfficeMoment {
  String get title => switch (this) {
    OfficeMoment.working => '차근차근 업무 중',
    OfficeMoment.deadline => '마감 전, 마지막 수정',
    OfficeMoment.approved => '기분 좋은 결재 완료',
    OfficeMoment.feedback => '보고서 피드백 받는 중',
    OfficeMoment.coffee => '잠깐의 커피 타임',
    OfficeMoment.meeting => '회의 준비 중',
  };

  String dialogue(int beat, int rank) {
    final senior = rank >= 3 ? '본부장님' : '팀장님';
    final lines = switch (this) {
      OfficeMoment.working => ['메일 확인하고, 하나씩.', '오늘도 나의 속도로!'],
      OfficeMoment.deadline => ['수정본… 이번엔 진짜 최종!', '숫자만 한 번 더 확인하자.'],
      OfficeMoment.approved => ['$senior: 정리 잘했어요.', '드디어 결재 완료!'],
      OfficeMoment.feedback => [
        '$senior: 이 수치, 다시 확인해요.',
        '네, 근거 보완해서 다시 드리겠습니다.',
      ],
      OfficeMoment.coffee => ['잠깐 쉬었다 할까요?', '아이스 아메리카노로 재충전.'],
      OfficeMoment.meeting => ['회의 5분 전! 자료 챙기자.', '공유 자료는 메일로 보냈습니다.'],
    };
    return lines[beat.clamp(0, 1)];
  }
}

/// Cosmetic randomness never consumes the economy's seeded random streams.
/// A shuffled bag gives every vignette a turn, separated by normal work.
class OfficeDirector {
  OfficeDirector({Random? random}) : _random = random ?? Random();
  final Random _random;
  final List<OfficeMoment> _bag = [];
  OfficeMoment moment = OfficeMoment.working;
  OfficeMoment? _last;
  int elapsedMs = 0, durationMs = 8000;
  double get progress => (elapsedMs / durationMs).clamp(0, 1);
  void advance(int milliseconds) {
    if (milliseconds < 0) throw ArgumentError.value(milliseconds);
    elapsedMs += milliseconds;
    while (elapsedMs >= durationMs) {
      elapsedMs -= durationMs;
      if (moment != OfficeMoment.working) {
        moment = OfficeMoment.working;
        durationMs = 8000 + _random.nextInt(6001);
      } else {
        if (_bag.isEmpty) {
          _bag.addAll(
            OfficeMoment.values.where((m) => m != OfficeMoment.working),
          );
          _bag.shuffle(_random);
          if (_bag.last == _last) {
            final first = _bag.first;
            _bag[0] = _bag.last;
            _bag[_bag.length - 1] = first;
          }
        }
        moment = _bag.removeLast();
        _last = moment;
        durationMs = 6500 + _random.nextInt(2001);
      }
    }
  }
}
