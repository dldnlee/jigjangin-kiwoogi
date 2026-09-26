#include <flutter/runtime_effect.glsl>
precision highp float;

uniform vec2 uOrigin;
uniform vec2 uSize;
uniform vec2 uFrame;
uniform vec3 uHair;
uniform vec3 uShirt;
uniform vec3 uSkin;
uniform sampler2D uAtlas;
out vec4 fragColor;

void main() {
  vec2 local = clamp((FlutterFragCoord().xy - uOrigin) / uSize, 0.0, 0.99999);
  // Fixed logical grid makes the pixels equally chunky in every frame and
  // palette. Sample cell centers so no neighboring frame can bleed in.
  vec2 pixel = (floor(local * vec2(96.0, 64.0)) + 0.5) / vec2(96.0, 64.0);
  vec4 sampleColor = texture(uAtlas, (uFrame + pixel) / 4.0);
  if (sampleColor.a < 0.5) { fragColor = vec4(0.0); return; }
  vec3 color = sampleColor.rgb / sampleColor.a;
  vec3 target = color;
  float lightness = dot(color, vec3(0.2126, 0.7152, 0.0722));
  if (color.b > color.r * 1.08 && color.r > color.g * 1.15 && color.b > 0.16) {
    target = uHair * clamp(lightness / 0.40, 0.60, 1.35);
  } else if (color.g > color.r * 1.25 && color.g > color.b * 1.15 && color.g > 0.18) {
    target = uShirt * clamp(lightness / 0.62, 0.60, 1.12);
  } else if (color.r > color.g * 1.12 && color.g > color.b * 1.12 && color.r > 0.25) {
    target = uSkin * clamp(lightness / 0.74, 0.65, 1.13);
  }
  fragColor = vec4(clamp(target, 0.0, 1.0), 1.0);
}
