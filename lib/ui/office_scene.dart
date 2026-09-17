import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'office_moments.dart';
import 'pixel_widgets.dart';

int roomForLevel(int level, int rank) =>
    math.max(rank, (level - 1) ~/ 5).clamp(0, 3);

class OfficeScene extends StatefulWidget {
  const OfficeScene({
    super.key,
    required this.level,
    required this.rank,
    required this.reducedMotion,
    this.fillSpace = false,
    this.previewMoment,
    this.previewFrame = 0,
    this.previewProgress = .5,
  });
  final int level, rank;
  final bool reducedMotion, fillSpace;

  /// Static art-direction/test preview; gameplay always uses the random director.
  final OfficeMoment? previewMoment;
  final int previewFrame;
  final double previewProgress;
  @override
  State<OfficeScene> createState() => _OfficeSceneState();
}

class _OfficeSceneState extends State<OfficeScene>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final _director = OfficeDirector();
  late final Ticker _ticker = createTicker(_tick);
  Duration _previous = Duration.zero;
  int _paintMs = 0, _animationMs = 0;
  bool _active = true;
  ui.Image? _rooms, _sprites, _boss, _workstation, _worker;
  Object? _error;
  OfficeMoment get moment => widget.previewMoment ?? _director.moment;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  Future<ui.Image> _image(String path) async {
    final bytes = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
    );
    final image = (await codec.getNextFrame()).image;
    codec.dispose();
    return image;
  }

  Future<void> _load() async {
    final loaded = <ui.Image>[];
    try {
      for (final name in [
        'office-rooms',
        'office-sprites',
        'office-boss',
        'office-workstation',
        'office-worker-seated',
      ]) {
        loaded.add(await _image('assets/sprites/$name.png'));
      }
      if (!mounted) {
        for (final image in loaded) {
          image.dispose();
        }
        return;
      }
      setState(() {
        _rooms = loaded[0];
        _sprites = loaded[1];
        _boss = loaded[2];
        _workstation = loaded[3];
        _worker = loaded[4];
      });
    } catch (e) {
      for (final image in loaded) {
        image.dispose();
      }
      if (mounted) {
        setState(() => _error = e);
      }
    }
  }

  void _tick(Duration elapsed) {
    final delta = (elapsed - _previous).inMilliseconds.clamp(0, 250);
    _previous = elapsed;
    _director.advance(delta);
    _animationMs += delta;
    _paintMs += delta;
    if (_paintMs >= 33) {
      _paintMs = 0;
      setState(() {});
    }
  }

  void _motion() {
    final stop =
        widget.reducedMotion ||
        widget.previewMoment != null ||
        MediaQuery.disableAnimationsOf(context) ||
        !TickerMode.valuesOf(context).enabled ||
        !_active;
    if (stop) {
      _ticker.stop();
      _previous = Duration.zero;
    } else if (!_ticker.isActive) {
      _previous = Duration.zero;
      _ticker.start();
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _active = state == AppLifecycleState.resumed;
    _motion();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker.dispose();
    _rooms?.dispose();
    _sprites?.dispose();
    _boss?.dispose();
    _workstation?.dispose();
    _worker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.previewMoment != null
        ? widget.previewProgress
        : _director.progress;
    final tense =
        moment == OfficeMoment.deadline || moment == OfficeMoment.feedback;
    final accent = tense
        ? coral
        : moment == OfficeMoment.approved
        ? gold
        : navy;
    final captionColor = tense
        ? const Color(0xffffeded)
        : moment == OfficeMoment.approved
        ? const Color(0xffffefb6)
        : paper;
    final content = ClipRect(
      child: Semantics(
        label: '레벨 ${widget.level} 사무실, ${moment.title}',
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_rooms == null ||
                _sprites == null ||
                _boss == null ||
                _workstation == null ||
                _worker == null)
              ColoredBox(
                color: const Color(0xffdce3ef),
                child: Center(
                  child: Text(
                    _error == null ? '사무실 준비 중…' : '사무실 이미지를 불러오지 못했어요.',
                  ),
                ),
              )
            else
              RepaintBoundary(
                child: CustomPaint(
                  painter: _OfficePainter(
                    _rooms!,
                    _sprites!,
                    _boss!,
                    _workstation!,
                    _worker!,
                    widget.level,
                    widget.rank,
                    widget.previewMoment == null
                        ? (_animationMs ~/ 300) % 4
                        : widget.previewFrame.clamp(0, 3),
                    moment,
                    progress,
                  ),
                ),
              ),
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 290),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: paper.withValues(alpha: .97),
                    border: Border.all(color: accent, width: 2),
                    boxShadow: const [
                      BoxShadow(color: Color(0x30202c40), offset: Offset(2, 2)),
                    ],
                  ),
                  child: Text(
                    moment.dialogue(progress < .5 ? 0 : 1, widget.rank),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: ink,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 27,
                padding: const EdgeInsets.symmetric(horizontal: 9),
                color: captionColor.withValues(alpha: .97),
                alignment: Alignment.centerLeft,
                child: Text(
                  '●  ${moment.title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: tense ? coral : navy),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return widget.fillSpace
        ? content
        : AspectRatio(aspectRatio: 1.5, child: content);
  }
}

class _OfficePainter extends CustomPainter {
  _OfficePainter(
    this.rooms,
    this.sprites,
    this.boss,
    this.workstation,
    this.worker,
    this.level,
    this.rank,
    this.frame,
    this.moment,
    this.progress,
  );
  final ui.Image rooms, sprites, boss, workstation, worker;
  final int level, rank, frame;
  final OfficeMoment moment;
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    final tier = roomForLevel(level, rank);
    final paint = Paint()
      ..filterQuality = FilterQuality.none
      ..isAntiAlias = false;
    final room = Rect.fromLTWH(
      (tier % 2) * rooms.width / 2,
      (tier ~/ 2) * rooms.height / 2,
      rooms.width / 2,
      rooms.height / 2,
    );
    final fitted = applyBoxFit(BoxFit.cover, room.size, size);
    final crop = Alignment.center.inscribe(fitted.source, room);
    canvas.drawImageRect(rooms, crop, Offset.zero & size, paint);
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
    // Keep a consistent floor baseline at every device height. Sprite sizes depend
    // on width but shrink on short phones, leaving the dialogue unobstructed.
    final unit = math.min(size.width, (size.height - 50) * 1.5);
    final left = (size.width - unit) / 2;
    final floor = size.height - 34;
    void draw(
      ui.Image atlas,
      Rect uv,
      double x,
      double bottom,
      double w, {
      double dx = 0,
      double dy = 0,
      double aspect = 1,
    }) {
      final dest = Rect.fromLTWH(
        (left + x * unit + dx).roundToDouble(),
        (floor - bottom * unit - w * unit / aspect + dy).roundToDouble(),
        (w * unit).roundToDouble(),
        (w * unit / aspect).roundToDouble(),
      );
      canvas.drawImageRect(
        atlas,
        Rect.fromLTWH(
          uv.left * atlas.width,
          uv.top * atlas.height,
          uv.width * atlas.width,
          uv.height * atlas.height,
        ),
        dest,
        paint,
      );
    }

    void prop(int cell, double x, double bottom, double w) {
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
      draw(sprites, uv, x, bottom, w);
    }

    final shift = ((level - 1) % 5) * .02 + (level - 1) * .0005;
    prop(11, .01, .13, .24);
    prop(10, .77 - shift, .09, .22);
    if (level >= 2) {
      prop(13, .02 + shift, .03, .18);
    }
    if (level >= 5) {
      prop(15, .07, .33, .10);
    }
    final interacting =
        moment == OfficeMoment.feedback || moment == OfficeMoment.meeting;
    // Walk cycles only play while travelling; planted gesture frames take over
    // at the desk. Departure faces right instead of sliding backwards.
    if (interacting) {
      final arriving = progress < .22;
      final leaving = progress > .78;
      final distance = arriving
          ? 1 - progress / .22
          : leaving
          ? (progress - .78) / .22
          : 0.0;
      final bossRow = arriving
          ? 0
          : leaving
          ? 1
          : moment == OfficeMoment.feedback
          ? 2
          : 3;
      final bossFrame = arriving || leaving
          ? (((arriving ? 1 - distance : distance) * 12).floor() % 4)
          : frame;
      draw(
        boss,
        Rect.fromLTWH(bossFrame * .25, bossRow * .25, .25, .25),
        .70 + distance * .48,
        .00,
        .34,
      );
    }
    // Keep chair, hands, keyboard and desk aligned in every animation frame.
    final row = switch (moment) {
      OfficeMoment.deadline => 1,
      OfficeMoment.approved => 2,
      OfficeMoment.feedback || OfficeMoment.meeting => 3,
      OfficeMoment.working || OfficeMoment.coffee => 0,
    };
    draw(
      worker,
      Rect.fromLTWH(frame * .25, row * .25, .25, .25),
      .18,
      .02,
      .60,
      aspect: workstation.width / workstation.height,
    );
    // Sample furniture ONLY from frame zero. Never animate its source or anchor.
    final deskOrigin = Offset(
      (left + .18 * unit).roundToDouble(),
      (floor - .02 * unit - .60 * unit / 1.5).roundToDouble(),
    );
    final deskScale = (.60 * unit).roundToDouble() / 384;
    canvas.save();
    canvas.translate(deskOrigin.dx, deskOrigin.dy);
    canvas.scale(deskScale);
    final furniture = Path()
      ..addRect(const Rect.fromLTWH(158, 164, 204, 17))
      ..addRect(const Rect.fromLTWH(265, 42, 100, 212))
      ..addRect(const Rect.fromLTWH(209, 152, 44, 13));
    canvas.clipPath(furniture, doAntiAlias: false);
    canvas.drawImageRect(
      workstation,
      const Rect.fromLTWH(0, 0, 384, 256),
      const Rect.fromLTWH(0, 0, 384, 256),
      paint,
    );
    canvas.restore();
    prop(14, .12 + shift, -.01, .16);
    // Pixel effects are independent overlays, never baked into the room.
    void pixel(double x, double y, double w, double h, Color color) {
      canvas.drawRect(
        Rect.fromLTWH(
          (left + x * unit).roundToDouble(),
          (floor - y * unit).roundToDouble(),
          w * unit,
          h * unit,
        ),
        Paint()..color = color,
      );
    }

    if (moment == OfficeMoment.deadline) {
      pixel(.44, .35 + (frame % 2) * .007, .008, .018, const Color(0xff69a9c6));
      for (var i = 0; i < 3; i++) {
        pixel(.66, .15 + i * .01, .07, .008, paper);
      }
    }
    if (moment == OfficeMoment.approved) {
      for (var i = 0; i < 3; i++) {
        final x = .28 + i * .13, y = .38 + (frame % 2) * .015;
        pixel(x, y, .025, .007, gold);
        pixel(x + .009, y + .008, .007, .025, gold);
      }
    }
    if (moment == OfficeMoment.coffee) {
      final lift = frame == 1 || frame == 2 ? .055 : 0;
      pixel(.475, .20 + lift, .034, .053, const Color(0xffa76f49));
      pixel(.472, .205 + lift, .04, .007, const Color(0xfff1e5c5));
      pixel(.495, .23 + lift, .005, .035, const Color(0xff577566));
    }
  }

  @override
  bool shouldRepaint(covariant _OfficePainter old) =>
      old.frame != frame ||
      old.moment != moment ||
      old.progress != progress ||
      old.level != level ||
      old.rank != rank ||
      old.rooms != rooms ||
      old.boss != boss ||
      old.workstation != workstation;
}
