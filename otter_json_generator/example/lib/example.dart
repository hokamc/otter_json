library example;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otter_json/otter_json.dart';

@ImportJsonModule([DefaultJsonModule, ExampleJsonModule])
class ExampleImportJsonModule {}

@JsonModule([ExampleSerializer])
class ExampleJsonModule {}

class Example implements Json {
  final String name;
  final int age;
  final double money;
  final List<int> list;
  final Map<String, int> map;
  final AnotherExample example2;
  final List<AnotherExample> example2s;
  final Color color;

  Example({
    required this.name,
    required this.age,
    required this.money,
    required this.list,
    required this.map,
    required this.example2,
    required this.example2s,
    required this.color,
  });
}

class AnotherExample implements Json {
  final String name;

  AnotherExample({required this.name});
}

class ExampleSerializer implements JsonSerializer<Color, int> {
  @override
  Color decode(int output) {
    return Color(output);
  }

  @override
  int encode(Color input) {
    return input.value;
  }
}
