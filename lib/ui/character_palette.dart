import 'dart:ui';

import '../domain/office_style.dart';

/// Three independent palette channels. Pose, silhouette and furniture are
/// shared, so new colorways never require copies of the 16-frame atlas.
const characterColors = <String, Color>{
  'hair-black': Color(0xff302b38),
  'hair-brown': Color(0xff805132),
  'hair-silver': Color(0xffb6b9c5),
  'hair-purple': Color(0xff8552ad),
  'shirt-white': Color(0xffeef2f8),
  'shirt-blue': Color(0xff6b9de3),
  'shirt-coral': Color(0xffdd7b72),
  'shirt-sage': Color(0xff83b28c),
  'skin-warm': Color(0xffedb98a),
  'skin-light': Color(0xffffd8bc),
  'skin-deep': Color(0xffa56743),
};

Color characterColor(Map<String, String> style, String slot) =>
    characterColors[officeChoice(style, slot)]!;
