import 'package:flutter/material.dart';

const ink = Color(0xff3e4c3c),
    green = Color(0xff536f4c),
    paper = Color(0xfffffbeb),
    gold = Color(0xffecd595);
const muted = Color(0xff778169), border = Color(0xff839077);

class PixelPanel extends StatelessWidget {
  const PixelPanel({
    required this.child,
    this.color = paper,
    this.padding = const EdgeInsets.all(14),
    super.key,
  });
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 4),
    padding: padding,
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: border, width: 2),
      boxShadow: const [
        BoxShadow(color: Color(0xffbec1a5), offset: Offset(3, 4)),
      ],
    ),
    child: child,
  );
}

class PixelButton extends StatelessWidget {
  const PixelButton({
    required this.label,
    this.onPressed,
    this.primary = true,
    this.compact = false,
    super.key,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool primary, compact;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: onPressed != null,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Material(
        color: onPressed == null
            ? const Color(0xffe4e6d3)
            : primary
            ? green
            : const Color(0xfff0e5be),
        shape: Border.all(color: onPressed == null ? border : ink, width: 2),
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 9 : 14,
              vertical: 12,
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: compact ? 13 : 16,
                color: onPressed == null
                    ? muted
                    : primary
                    ? paper
                    : ink,
                height: 1.4,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class PixelMeter extends StatelessWidget {
  const PixelMeter(this.value, {super.key});
  final double value;
  @override
  Widget build(BuildContext context) => Container(
    height: 10,
    padding: const EdgeInsets.all(2),
    decoration: BoxDecoration(
      color: const Color(0xffe5e5ce),
      border: Border.all(color: border),
    ),
    child: Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: value.clamp(0, 1),
        child: const ColoredBox(color: green),
      ),
    ),
  );
}

class PixelIcon extends StatelessWidget {
  const PixelIcon(this.kind, {this.size = 28, this.color = ink, super.key});
  final String kind;
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(painter: _PixelPainter(kind, color)),
  );
}

class _PixelPainter extends CustomPainter {
  _PixelPainter(this.kind, this.color);
  final String kind;
  final Color color;
  static const patterns = {
    'office': [
      '000011110000',
      '000010010000',
      '001111111100',
      '001001001100',
      '001001001100',
      '001111111100',
      '001001001100',
      '001001001100',
      '001111111100',
      '001101101100',
      '001101101100',
      '011111111110',
    ],
    'career': [
      '000001100000',
      '011111111110',
      '011001100110',
      '001101101100',
      '000111111000',
      '000011110000',
      '000001100000',
      '000001100000',
      '000011110000',
      '000111111000',
      '000111111000',
      '000000000000',
    ],
    'skills': [
      '011110111100',
      '110011100110',
      '110011100110',
      '110011100110',
      '110011100110',
      '110011100110',
      '110011100110',
      '110011100110',
      '110011100110',
      '011111111100',
      '000001100000',
      '000000000000',
    ],
    'equipment': [
      '000011110000',
      '000110011000',
      '000110011000',
      '011111111110',
      '110000000011',
      '110000000011',
      '111111111111',
      '110001100011',
      '110000000011',
      '110000000011',
      '011111111110',
      '000000000000',
    ],
    'journal': [
      '001111111100',
      '001000000100',
      '001011110100',
      '001000000100',
      '001011110100',
      '001000000100',
      '001011110100',
      '001000000100',
      '001011000100',
      '001000000100',
      '001111111100',
      '000000000000',
    ],
    'coin': [
      '000111111000',
      '001100001100',
      '011001100110',
      '110111111011',
      '110001100011',
      '110011110011',
      '110001100011',
      '110111111011',
      '011001100110',
      '001100001100',
      '000111111000',
      '000000000000',
    ],
    'speed': [
      '000000110000',
      '000001110000',
      '000011100000',
      '000111000000',
      '001111111100',
      '011111111000',
      '000001110000',
      '000011100000',
      '000111000000',
      '001110000000',
      '001100000000',
      '000000000000',
    ],
    'efficiency': [
      '000000000110',
      '000000001110',
      '000000011110',
      '000000111110',
      '000001111110',
      '000011111110',
      '000111111110',
      '001111111110',
      '011111111110',
      '011111111110',
      '000000000000',
      '000000000000',
    ],
    'focus': [
      '000111111000',
      '001100001100',
      '011001100110',
      '110011110011',
      '110110011011',
      '110111111011',
      '110111111011',
      '110110011011',
      '011011110110',
      '001100001100',
      '000111111000',
      '000000000000',
    ],
    'settings': [
      '000011110000',
      '011011110110',
      '011111111110',
      '001110011100',
      '111100001111',
      '111000000111',
      '111000000111',
      '111100001111',
      '001110011100',
      '011111111110',
      '011011110110',
      '000011110000',
    ],
    'chat': [
      '011111111110',
      '110000000011',
      '110000000011',
      '110110110011',
      '110000000011',
      '110000000011',
      '011111111110',
      '000110000000',
      '000100000000',
      '000000000000',
      '000000000000',
      '000000000000',
    ],
    'laptop': [
      '011111111110',
      '010000000010',
      '010000000010',
      '010000000010',
      '010000000010',
      '010000000010',
      '011111111110',
      '001111111100',
      '011111111110',
      '111111111111',
      '000000000000',
      '000000000000',
    ],
    'suit': [
      '001100001100',
      '011111111110',
      '111011110111',
      '110011110011',
      '000011110000',
      '000011110000',
      '000011110000',
      '000011110000',
      '000011110000',
      '000011110000',
      '000000000000',
      '000000000000',
    ],
  };
  @override
  void paint(Canvas canvas, Size size) {
    final p = patterns[kind] ?? patterns['equipment']!;
    final paint = Paint()
      ..color = color
      ..isAntiAlias = false;
    for (var y = 0; y < p.length; y++) {
      for (var x = 0; x < p[y].length; x++) {
        if (p[y][x] == '1') {
          canvas.drawRect(
            Rect.fromLTWH(
              x * size.width / 12,
              y * size.height / 12,
              size.width / 12,
              size.height / 12,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_PixelPainter old) =>
      old.kind != kind || old.color != color;
}

String won(BigInt amount) {
  for (final unit in [
    (BigInt.from(10).pow(12), '조'),
    (BigInt.from(10).pow(8), '억'),
    (BigInt.from(10000), '만'),
  ]) {
    if (amount >= unit.$1) {
      final whole = amount ~/ unit.$1;
      final fraction = (amount % unit.$1 * BigInt.from(100) ~/ unit.$1)
          .toString()
          .padLeft(2, '0')
          .replaceFirst(RegExp(r'0+$'), '');
      return '₩$whole${fraction.isEmpty ? '' : '.$fraction'}${unit.$2}';
    }
  }
  return '₩${amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
}

String durationLabel(int seconds) => seconds >= 3600
    ? '${seconds ~/ 3600}시간 ${(seconds % 3600) ~/ 60}분'
    : '${seconds ~/ 60}분 ${seconds % 60}초';
