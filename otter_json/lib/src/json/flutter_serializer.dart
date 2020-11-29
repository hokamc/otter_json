import 'package:flutter/material.dart';
import 'package:otter_json/otter_json.dart';

class ColorJsonSerializer implements JsonSerializer<Color, int> {
  @override
  Color decode(int output) {
    return Color(output);
  }

  @override
  int encode(Color input) {
    return input.value;
  }
}

class DateTimeJsonSerializer implements JsonSerializer<DateTime, String> {
  @override
  DateTime decode(String output) {
    return DateTime.tryParse(output);
  }

  @override
  String encode(DateTime input) {
    return input.toIso8601String();
  }
}

class DurationJsonSerializer implements JsonSerializer<Duration, int> {
  @override
  Duration decode(int output) {
    return Duration(milliseconds: output);
  }

  @override
  int encode(Duration input) {
    return input.inMilliseconds;
  }
}
