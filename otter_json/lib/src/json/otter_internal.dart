import 'package:otter_json/src/api/json_module.dart';
import 'package:otter_json/src/api/json_serializer.dart';

/// this is for generated file to use only!
class OtterInternal {
  OtterInternal._();

  static final Map<String, JsonSerializer> _serializers = {};

  static void importGeneratedModule(GeneratedJsonModule module) {
    _serializers.addAll(module.serializers());
  }

  static O encode<I, O>(I object) {
    var serializer = _serializers[I.toString()];
    if (serializer == null) {
      throw ArgumentError.value('$I', 'cannot find serializer');
    }
    return serializer.encode(object);
  }

  static I decode<I, O>(O source) {
    var serializer = _serializers[I.toString()];
    if (serializer == null) {
      throw ArgumentError('$I cannot find serializer');
    }
    return serializer.decode(source);
  }

  static List<O> encodeList<I, O>(List<I> objects) {
    return objects.map((e) => encode<I, O>(e)).toList();
  }

  static List<I> decodeList<I, O>(List<O> sources) {
    return sources.map((e) => decode<I, O>(e)).toList();
  }

  static Map<String, O> encodeMap<I, O>(Map<String, I> objects) {
    return objects.map((key, value) => MapEntry(key, encode(value)));
  }

  static Map<String, I> decodeMap<I, O>(Map<String, O> sources) {
    return sources.map((key, value) => MapEntry(key, decode(value)));
  }
}
