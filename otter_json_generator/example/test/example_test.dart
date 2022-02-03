import 'package:example/example.dart';
import 'package:example/json_module.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otter_json/otter_json.dart';

void main() {
  Otter.importGeneratedModule(OtterGeneratedJsonModule());
  group('test generated serializers', () {
    test('toJson and fromMap', () {
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
        eenum: ExampleEnum.a1,
      );
      expect(Otter.toJson(example),
          '{"name2":"name","age":1,"money":99.0,"list":[1,2],"map":{"abc":10},"example2":{"name":"name"},"example2s":[{"name":"name"}],"color":4294967295,"nullInt":null,"eenum":"A1"}');

      expect(Otter.toMap(example), {
        'name2': 'name',
        'age': 1,
        'money': 99.0,
        'list': [1, 2],
        'map': {'abc': 10},
        'color': 4294967295,
        'example2': {'name': 'name'},
        'example2s': [
          {'name': 'name'}
        ],
        'nullInt': null,
        "eenum": 'A1'
      });
    });

    test('null for non-nullable field', () {
      expect(() {
        Otter.fromJson<Example>(
            '{"name2":"name","age":1,"money":99.0,"list":[1,2],"map":{"abc":10},"example2":{"name":"name"},"example2s":[{"name":"name"}],"color":null}');
      }, throwsA(const TypeMatcher<TypeError>()));
    });

    test('null for non-nullable list', () {
      expect(() {
        Otter.fromJson<Example>(
            '{"name2":"name","age":1,"money":99.0,"list":[1,2],"map":{"abc":10},"example2":{"name":"name"},"example2s":null,"color":4294967295}');
      }, throwsA(const TypeMatcher<TypeError>()));
    });

    test('null for non-nullable map', () {
      expect(() {
        Otter.fromJson<Example>(
            '{"name2":"name","age":1,"money":99.0,"list":[1,2],"map":{"abc":10},"example2s":[{"name":"name"}],"color":4294967295}');
      }, throwsA(const TypeMatcher<TypeError>()));
    });

    test('enum convert fail', () {
      expect(() {
        OtterInternal.decode<ExampleEnum, String>("a3");
      }, throwsA(const TypeMatcher<ArgumentError>()));
    });
  });
}
