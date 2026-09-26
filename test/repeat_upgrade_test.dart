import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:office_worker/ui/repeat_upgrade_button.dart';

void main() {
  testWidgets('tap buys once; hold repeats and release stops', (tester) async {
    var count = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: RepeatUpgradeButton(
              label: 'buy',
              enabled: true,
              buy: () async {
                count++;
                return true;
              },
            ),
          ),
        ),
      ),
    );
    final button = find.text('buy');
    await tester.tap(button);
    await tester.pump();
    expect(count, 1);
    final gesture = await tester.startGesture(tester.getCenter(button));
    await tester.pump(const Duration(milliseconds: 600));
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 170));
    }
    expect(count, greaterThan(3));
    await gesture.up();
    final stopped = count;
    await tester.pump(const Duration(seconds: 1));
    expect(count, stopped);
  });

  testWidgets('awaits pending save and never schedules after release', (
    tester,
  ) async {
    var count = 0;
    final save = Completer<bool>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RepeatUpgradeButton(
            label: 'buy',
            enabled: true,
            buy: () {
              count++;
              return save.future;
            },
          ),
        ),
      ),
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.text('buy')),
    );
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(seconds: 2));
    expect(count, 1);
    await gesture.up();
    save.complete(true);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(count, 1);
  });

  for (final stop in [
    'unaffordable',
    'move',
    'background',
    'dispose',
    'cancel',
  ]) {
    testWidgets('repeat stops on $stop', (tester) async {
      var count = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RepeatUpgradeButton(
                label: 'buy',
                enabled: true,
                buy: () async {
                  count++;
                  return stop != 'unaffordable';
                },
              ),
            ),
          ),
        ),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('buy')),
      );
      await tester.pump(const Duration(milliseconds: 600));
      expect(count, 1);
      switch (stop) {
        case 'move':
          await gesture.moveBy(const Offset(300, 200));
        case 'background':
          tester.binding.handleAppLifecycleStateChanged(
            AppLifecycleState.inactive,
          );
        case 'dispose':
          await tester.pumpWidget(const SizedBox());
        case 'cancel':
          await gesture.cancel();
      }
      await tester.pump(const Duration(seconds: 1));
      expect(count, 1);
      if (stop != 'cancel') await gesture.up();
      if (stop == 'background') {
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
      }
    });
  }
}
