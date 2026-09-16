import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Four room shells plus deterministic per-level furnishings and daylight.
int roomForLevel(int level, int rank) =>
    math.max(rank, (level - 1) ~/ 5).clamp(0, 3);

class OfficeScene extends StatefulWidget {
  const OfficeScene({
    super.key,
    required this.level,
    required this.rank,
    required this.reducedMotion,
  });
  final int level, rank;
  final bool reducedMotion;
  @override
  State<OfficeScene> createState() => _OfficeSceneState();
}

class _OfficeSceneState extends State<OfficeScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );
  ui.Image? _rooms, _sprites;
  Object? _error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<ui.Image> _image(String path) async {
    final bytes = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
    );
    final frame = await codec.getNextFrame();
    codec.dispose();
    return frame.image;
  }

  Future<void> _load() async {
    try {
      final images = await Future.wait([
        _image('assets/sprites/office-rooms.png'),
        _image('assets/sprites/office-sprites.png'),
      ]);
      if (!mounted) {
        for (final image in images) {
          image.dispose();
        }
        return;
      }
      setState(() {
        _rooms = images[0];
        _sprites = images[1];
      });
    } catch (e) {
      if (mounted) {
        setState(() => _error = e);
      }
    }
  }

  void _motion() {
    final stop =
        widget.reducedMotion || MediaQuery.disableAnimationsOf(context);
    if (stop) {
      _clock.stop();
    } else if (!_clock.isAnimating) {
      _clock.repeat();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _motion();
  }

  @override
  void didUpdateWidget(covariant OfficeScene oldWidget) {
    super.didUpdateWidget(oldWidget);
    _motion();
  }

  @override
  void dispose() {
    _clock.dispose();
    _rooms?.dispose();
    _sprites?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label:
        '레벨 ${widget.level} 사무실, ${['작은 사무실', '열린 사무실', '팀장 사무실', '전망 좋은 사무실'][roomForLevel(widget.level, widget.rank)]}',
    child: AspectRatio(
      aspectRatio: 1.5,
      child: RepaintBoundary(
        child: _rooms == null || _sprites == null
            ? ColoredBox(
                color: const Color(0xffd8dfc4),
                child: Center(
                  child: Text(
                    _error == null ? '사무실 준비 중…' : '사무실 이미지를 불러오지 못했어요.',
                  ),
                ),
              )
            : AnimatedBuilder(
                animation: _clock,
                builder: (_, _) => CustomPaint(
                  painter: _OfficePainter(
                    _rooms!,
                    _sprites!,
                    widget.level,
                    widget.rank,
                    (_clock.value * 4).floor().clamp(0, 3),
                  ),
                ),
              ),
      ),
    ),
  );
}

class _OfficePainter extends CustomPainter {
  _OfficePainter(this.rooms, this.sprites, this.level, this.rank, this.frame);
  final ui.Image rooms, sprites;
  final int level, rank, frame;
  @override
  void paint(Canvas canvas, Size size) {
    final tier = roomForLevel(level, rank);
    final paint = Paint()
      ..filterQuality = FilterQuality.none
      ..isAntiAlias = false;
    canvas.drawImageRect(
      rooms,
      Rect.fromLTWH(
        (tier % 2) * rooms.width / 2,
        (tier ~/ 2) * rooms.height / 2,
        rooms.width / 2,
        rooms.height / 2,
      ),
      Offset.zero & size,
      paint,
    );
    // Each numerical level changes the daylight and prop positions; major tiers replace the room.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = [
          const Color(0x08fff0ba),
          const Color(0x0c9ecfdd),
          const Color(0x10ffbb79),
          const Color(0x089fbfa2),
          const Color(0x0bbaa1d1),
        ][(level - 1) % 5],
    );
    void sprite(int cell, double x, double y, double w) {
      // The generated atlas uses unequal furniture bounds. Explicit UVs prevent
      // neighbouring props and feet from bleeding into animation frames.
      final Rect uv;
      if (cell < 8) {
        uv = Rect.fromLTWH(
          (cell % 4) * .25,
          cell < 4 ? 0 : .28,
          .25,
          cell < 4 ? .28 : .26,
        );
      } else if (cell < 12) {
        const edges = [0.0, .265, .565, .77, 1.0];
        final i = cell - 8;
        uv = Rect.fromLTRB(edges[i], .54, edges[i + 1], .775);
      } else {
        uv = Rect.fromLTWH((cell % 4) * .25, .775, .25, .225);
      }
      canvas.drawImageRect(
        sprites,
        Rect.fromLTWH(
          uv.left * sprites.width,
          uv.top * sprites.height,
          uv.width * sprites.width,
          uv.height * sprites.height,
        ),
        Rect.fromLTWH(
          (x * size.width).roundToDouble(),
          (y * size.height).roundToDouble(),
          (w * size.width).roundToDouble(),
          (w * size.width).roundToDouble(),
        ),
        paint,
      );
    }

    final shift = ((level - 1) % 5) * .022 + (level - 1) * .0005;
    sprite(11, .02, .39, .24); // bookcase
    sprite(10, .76 - shift, .46, .21); // plant
    if (level >= 2) {
      sprite(13, .01 + shift, .49, .20);
    }
    if (level >= 3) {
      sprite(12, .71, .62, .18);
    }
    // Character sits behind the independent desk layer.
    sprite((rank >= 2 ? 4 : 0) + frame, .30, .34, .36);
    sprite(8, .38, .43, .35);
    sprite(14, .10 + shift, .76, .17);
    if (level >= 5) {
      sprite(15, .07, .29, .10);
    }
  }

  @override
  bool shouldRepaint(covariant _OfficePainter old) =>
      old.frame != frame ||
      old.level != level ||
      old.rank != rank ||
      old.rooms != rooms ||
      old.sprites != sprites;
}


