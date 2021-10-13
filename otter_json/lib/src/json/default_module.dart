import 'package:otter_json/src/api/annotation.dart';
import 'package:otter_json/src/json/primitive_serializers.dart';

@JsonModule([
  StringJsonSerializer,
  DoubleJsonSerializer,
  IntJsonSerializer,
  NumJsonSerializer,
  BoolJsonSerializer,
])
class DefaultJsonModule {}
