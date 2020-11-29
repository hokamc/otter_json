import 'dart:ui';

import 'package:otter_json/otter_json.dart';

@JSON()
class Person {
  String firstName;
  String lastName;
  int age;
  bool isMale;
  num balance;
  double weight;
  List<Person> friends;
  Map<String, int> cards;
  Color color;
}
