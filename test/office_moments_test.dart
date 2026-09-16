import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:office_worker/ui/office_moments.dart';

void main() {
  test('all five vignettes play once per bag with work in between', () {
    final director = OfficeDirector(random: Random(19));
    final scenes = <OfficeMoment>[];
    for (var i = 0; i < 20; i++) {
      expect(director.moment, OfficeMoment.working);
      expect(director.durationMs, inInclusiveRange(8000, 14000));
      director.advance(director.durationMs);
      scenes.add(director.moment);
      expect(director.durationMs, inInclusiveRange(6500, 8500));
      director.advance(director.durationMs);
    }
    for (var i = 0; i < scenes.length; i += 5) {
      expect(scenes.sublist(i, i + 5).toSet().length, 5);
    }
    for (var i = 1; i < scenes.length; i++) {
      expect(scenes[i], isNot(scenes[i - 1]));
    }
  });
  test('small ticks and large ticks produce identical choreography', () {
    final one = OfficeDirector(random: Random(71));
    final many = OfficeDirector(random: Random(71));
    one.advance(600000);
    for (var i = 0; i < 4000; i++) {
      many.advance(150);
    }
    expect(many.moment, one.moment);
    expect(many.elapsedMs, one.elapsedMs);
    expect(many.durationMs, one.durationMs);
    expect(() => many.advance(-1), throwsArgumentError);
  });
}
