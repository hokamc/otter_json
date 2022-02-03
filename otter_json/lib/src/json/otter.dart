import 'dart:convert';

import 'package:otter_json/src/api/annotation.dart';
import 'package:otter_json/src/api/json_module.dart';
import 'package:otter_json/src/json/otter_internal.dart';

class Otter {
  Otter._();

  static Map<String, dynamic> toMap<T extends Json>(T object) {
    return OtterInternal.encode(object);
  }

  static T fromMap<T extends Json>(Map<String, dynamic> source) {
    return OtterInternal.decode(source)!;
  }

  static String toJson<T extends Json>(T object) {
    return jsonEncode(OtterInternal.encode(object));
  }

  static T fromJson<T extends Json>(String json) {
    return OtterInternal.decode(jsonDecode(json))!;
  }

  static void importGeneratedModule(GeneratedJsonModule module) {
    OtterInternal.importGeneratedModule(module);
  }
}
