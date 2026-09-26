import 'dart:async';

import 'package:flutter/material.dart';

import 'pixel_widgets.dart';

/// Serial purchases: await each save, then recheck the latest game state.
class RepeatUpgradeButton extends StatefulWidget {
  const RepeatUpgradeButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.buy,
    this.compact = false,
  });
  final String label;
  final bool enabled, compact;
  final Future<bool> Function() buy;

  @override
  State<RepeatUpgradeButton> createState() => _RepeatUpgradeButtonState();
}

class _RepeatUpgradeButtonState extends State<RepeatUpgradeButton>
    with WidgetsBindingObserver {
  Timer? _timer;
  int _generation = 0;
  bool _buying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void _stop() {
    _generation++;
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _purchase(int generation, {required bool repeat}) async {
    if (!mounted || !widget.enabled || _buying) return;
    _buying = true;
    var keepGoing = false;
    try {
      keepGoing = await widget.buy();
    } finally {
      _buying = false;
    }
    if (mounted &&
        repeat &&
        keepGoing &&
        widget.enabled &&
        generation == _generation) {
      _timer = Timer(
        const Duration(milliseconds: 160),
        () => _purchase(generation, repeat: true),
      );
    }
  }

  @override
  void didUpdateWidget(RepeatUpgradeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled) _stop();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _stop();
  }

  @override
  void dispose() {
    _stop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    hint: '길게 누르면 연속으로 레벨을 올려요. 손을 떼면 멈춰요.',
    child: GestureDetector(
      onLongPressStart: widget.enabled
          ? (_) {
              _stop();
              unawaited(_purchase(_generation, repeat: true));
            }
          : null,
      onLongPressEnd: (_) => _stop(),
      onLongPressCancel: _stop,
      onLongPressMoveUpdate: (details) {
        final size = context.size;
        if (size != null &&
            !(Offset.zero & size).contains(details.localPosition)) {
          _stop();
        }
      },
      child: PixelButton(
        label: widget.label,
        compact: widget.compact,
        onPressed: widget.enabled
            ? () => unawaited(_purchase(_generation, repeat: false))
            : null,
      ),
    ),
  );
}
