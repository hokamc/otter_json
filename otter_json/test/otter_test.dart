import 'package:flutter/material.dart';
import 'package:otter_json/otter_json.dart';
import 'package:test/test.dart';

import 'generated_json_module.dart';

void main() {
  Otter.module(GeneratedJsonModule());

  group('toMap', () {
    test('null', () {
      expect(
          Otter.toMap(TestClass()),
          equals({
            'string': null,
            'integer': null,
            'dou': null,
            'boolean': null,
            'number': null,
            'color': null,
            'dateTime': null,
            'duration': null
          }));
    });

    test('object', () {
      expect(
          Otter.toMap(TestClass()
            ..string = 'string'
            ..integer = 1
            ..dou = 2.0
            ..boolean = false
            ..number = 10.0
            ..color = Colors.red
            ..dateTime = DateTime(2020, 10, 10)
            ..duration = Duration(milliseconds: 1)),
          equals({
            'string': 'string',
            'integer': 1,
            'dou': 2.0,
            'boolean': false,
            'number': 10.0,
            'color': 4294198070,
            'dateTime': '2020-10-10T00:00:00.000',
            'duration': 1
          }));
    });

    test('primitive', () {
      expect(() => Otter.toMap('123'), throwsA(isA<TypeError>()));
    });
  });

  group('fromMap', () {
    test('null', () {
      expect(Otter.fromMap<TestClass>(null), equals(null));
    });

    test('object', () {
      expect(
          Otter.fromMap<TestClass>({
            'string': 'string',
            'integer': 1,
            'dou': 2.0,
            'boolean': false,
            'number': 10.0,
            'color': 4294198070,
            'dateTime': '2020-10-10T00:00:00.000',
            'duration': 1
          }), predicate<TestClass>((result) {
        return result.string == 'string' &&
            result.integer == 1 &&
            result.dou == 2.0 &&
            result.boolean == false &&
            result.number == 10.0 &&
            result.color.value == 4294198070 &&
            result.dateTime.year == 2020 &&
            result.dateTime.month == 10 &&
            result.dateTime.day == 10 &&
            result.duration.inMilliseconds == 1;
      }));
    });
  });

  group('toJson', () {
    test('null', () {
      expect(Otter.toJson(null), equals(null));
    });

    test('object', () {
      expect(
          Otter.toJson(TestClass()
            ..string = 'string'
            ..integer = 1
            ..dou = 2.0
            ..boolean = false
            ..number = 10.0
            ..color = Colors.red
            ..dateTime = DateTime(2020, 10, 10)
            ..duration = Duration(milliseconds: 1)),
          equals(
              '{"string":"string","integer":1,"dou":2.0,"boolean":false,"number":10.0,"color":4294198070,"dateTime":"2020-10-10T00:00:00.000","duration":1}'));
    });

    test('primitive', () {
      expect(Otter.toJson('string'), '"string"');
      expect(Otter.toJson(1), '1');
      expect(Otter.toJson(2.0), '2.0');
      expect(Otter.toJson(false), 'false');
      expect(Otter.toJson(10.0), '10.0');
    });
  });

  group('fromJson', () {
    test('null', () {
      expect(Otter.fromJson(null), equals(null));
    });

    test('object', () {
      expect(
          Otter.fromJson<TestClass>(
              '{"string":"string","integer":1,"dou":2.0,"boolean":false,"number":10.0,"color":4294198070,"dateTime":"2020-10-10T00:00:00.000","duration":1}'),
          predicate<TestClass>((result) {
        return result.string == 'string' &&
            result.integer == 1 &&
            result.dou == 2.0 &&
            result.boolean == false &&
            result.number == 10.0 &&
            result.color.value == 4294198070 &&
            result.dateTime.year == 2020 &&
            result.dateTime.month == 10 &&
            result.dateTime.day == 10 &&
            result.duration.inMilliseconds == 1;
      }));
    });

    test('primitive', () {
      expect(Otter.fromJson<String>('"string"'), 'string');
      expect(Otter.fromJson<int>('1'), 1);
      expect(Otter.fromJson<num>('2.0'), 2.0);
      expect(Otter.fromJson<bool>('false'), false);
      expect(Otter.fromJson<double>('10.0'), 10.0);
    });
  });
}
