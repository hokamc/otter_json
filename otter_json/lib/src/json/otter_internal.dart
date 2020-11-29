import 'package:otter_json/src/api/json_module.dart';
import 'package:otter_json/src/api/json_serializer.dart';
import 'package:otter_json/src/json/primitive_serializers.dart';

/// this is for generated file to use only!
class OtterInternal {
  OtterInternal._();

  static final Map<String, JsonSerializer> _serializers = {
    'String': StringJsonSerializer(),
    'int': IntJsonSerializer(),
    'double': DoubleJsonSerializer(),
    'bool': BoolJsonSerializer(),
    'num': NumJsonSerializer(),
  };

  static void module(JsonModule module) {
    _serializers.addAll(module.serializers());
  }

  static void serializer<I, O>(JsonSerializer<I, O> serializer) {
    _serializers[I.toString()] = serializer;
  }

  static O encode<I, O>(I object) {
    var serializer = _serializers[I.toString()];
    if (serializer == null) {
      throw ArgumentError('$I cannot find serializer');
    }
    if (object == null) return null;
    return serializer.encode(object);
  }

  static I decode<I, O>(O source) {
    var serializer = _serializers[I.toString()];
    if (serializer == null) {
      throw ArgumentError('$I cannot find serializer');
    }
    if (source == null) return null;
    return serializer.decode(source);
  }

  static List<O> encodeList<I, O>(List<I> objects) {
    if (objects == null) return null;
    return objects.map((e) => encode<I, O>(e)).toList();
  }

  static List<I> decodeList<I, O>(List<O> sources) {
    if (sources == null) return null;
    return sources.map((e) => decode<I, O>(e)).toList();
  }

  static Set<O> encodeSet<I, O>(Set<I> objects) {
    if (objects == null) return null;
    return objects.map((e) => encode<I, O>(e)).toSet();
  }

  static Set<I> decodeSet<I, O>(Set<O> sources) {
    if (sources == null) return null;
    return sources.map((e) => decode<I, O>(e)).toSet();
  }

  static Map<String, O> encodeMap<I, O>(Map<String, I> objects) {
    if (objects == null) return null;
    return objects.map((key, value) => MapEntry(key, encode(value)));
  }

  static Map<String, I> decodeMap<I, O>(Map<String, O> sources) {
    if (sources == null) return null;
    return sources.map((key, value) => MapEntry(key, decode(value)));
  }
}
