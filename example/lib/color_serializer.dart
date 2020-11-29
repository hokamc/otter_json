import 'dart:ui';

import 'package:otter_json/otter_json.dart';

class ColorSerializer implements JsonSerializer<Color, int> {
  @override
  Color decode(int output) {
    return Color(output);
  }

  @override
  int encode(Color input) {
    return input.value;
  }
}
