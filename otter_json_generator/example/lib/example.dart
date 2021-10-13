library example;

import 'package:otter_json/otter_json.dart';

@ImportJsonModule([DefaultJsonModule])
class ExampleImportJsonModule {}

class Example implements Json {
  final String name;
  final int age;
  final double money;
  final List<int> list;
  final Map<String, int> map;
  final AnotherExample example2;
  final List<AnotherExample> example2s;

  Example({
    required this.name,
    required this.age,
    required this.money,
    required this.list,
    required this.map,
    required this.example2,
    required this.example2s,
  });
}

class AnotherExample implements Json {
  final String name;

  AnotherExample({required this.name});
}
