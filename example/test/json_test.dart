import 'package:example/color_serializer.dart';
import 'package:example/generated/generated_json_module.dart';
import 'package:example/person.dart';
import 'package:flutter/material.dart';
import 'package:otter_json/otter_json.dart';

void main() {
  Otter.module(GeneratedJsonModule());
  Otter.serializer(ColorSerializer());
  var person = Person()
    ..lastName = 'ben'
    ..firstName = 'ten'
    ..age = 10
    ..balance = 100
    ..isOld = true
    ..gender = Gender.Male
    ..weight = 80
    ..cards = {'1': 1, '2': 2}
    ..color = Colors.red
    ..friends = [Person(), Person(), Person()];

  Map<String, dynamic> map = Otter.toJson(person);
  Person newPerson = Otter.fromJson(map);
  print(map);
  print(newPerson);
}
