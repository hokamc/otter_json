import 'package:example/example.dart';
import 'package:example/json_module.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otter_json/otter_json.dart';

void main() {
  Otter.importGeneratedModule(OtterGeneratedJsonModule());
  group('test generated serializers', () {
    test('example', () {
      AnotherExample example2 = AnotherExample(name: 'name');
      Example example = Example(
        name: 'name',
        age: 1,
        money: 99.0,
        list: [1, 2],
        map: {'abc': 10},
        example2: example2,
        example2s: [example2],
        color: Colors.white,
      );
      expect(Otter.toJson(example),
          '{"name":"name","age":1,"money":99.0,"list":[1,2],"map":{"abc":10},"example2":{"name":"name"},"example2s":[{"name":"name"}],"color":4294967295}');
      expect(Otter.toMap(example), {
        'name': 'name',
        'age': 1,
        'money': 99.0,
        'list': [1, 2],
        'map': {'abc': 10},
        'color': 4294967295,
        'example2': {'name': 'name'},
        'example2s': [
          {'name': 'name'}
        ]
      });
    });
  });
}
