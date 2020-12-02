import 'dart:convert';

import 'package:otter_json/src/api/json_module.dart';
import 'package:otter_json/src/api/json_serializer.dart';
import 'package:otter_json/src/json/otter_internal.dart';

class Otter {
  Otter._();

  static Map<String, dynamic> toMap<T>(T object) {
    return OtterInternal.encode(object);
  }

  static T fromMap<T>(Map<String, dynamic> source) {
    return OtterInternal.decode(source);
  }

  static String toJson<T>(T object) {
    if (object == null) return null;
    return jsonEncode(OtterInternal.encode(object));
  }

  static T fromJson<T>(String json) {
    if (json == null) return null;
    return OtterInternal.decode(jsonDecode(json));
  }

  static void module(JsonModule module) {
    OtterInternal.module(module);
  }

  static void serializer<I, O>(JsonSerializer<I, O> serializer) {
    OtterInternal.serializer(serializer);
  }
}
