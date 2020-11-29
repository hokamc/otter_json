import 'package:otter_json/src/api/json_serializer.dart';

class StringJsonSerializer implements JsonSerializer<String, String> {
  @override
  String decode(String output) {
    return output;
  }

  @override
  String encode(String input) {
    return input;
  }
}

class DoubleJsonSerializer implements JsonSerializer<double, double> {
  @override
  double decode(double output) {
    return output;
  }

  @override
  double encode(double input) {
    return input;
  }
}

class IntJsonSerializer implements JsonSerializer<int, int> {
  @override
  int decode(int output) {
    return output;
  }

  @override
  int encode(int input) {
    return input;
  }
}

class NumJsonSerializer implements JsonSerializer<num, num> {
  @override
  num decode(num output) {
    return output;
  }

  @override
  num encode(num input) {
    return input;
  }
}

class BoolJsonSerializer implements JsonSerializer<bool, bool> {
  @override
  bool decode(bool output) {
    return output;
  }

  @override
  bool encode(bool input) {
    return input;
  }
}
