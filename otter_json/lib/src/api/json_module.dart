import 'package:otter_json/src/api/json_serializer.dart';

abstract class JsonModule {
  Map<String, JsonSerializer> serializers();
}
