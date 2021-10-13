// generated by otter_json_generator
// don't make change on this manually
  
import 'package:otter_json/otter_json.dart';
import 'package:otter_json/src/json/primitive_serializers.dart';
import 'package:example/example.dart';

class OtterGeneratedJsonModule implements GeneratedJsonModule {
  @override
  Map<String, JsonSerializer> serializers() {
    return {
      'String': StringJsonSerializer(),
      'double': DoubleJsonSerializer(),
      'int': IntJsonSerializer(),
      'num': NumJsonSerializer(),
      'bool': BoolJsonSerializer(),
      'Example': ExampleJsonSerializer(),
      'AnotherExample': AnotherExampleJsonSerializer(),
    };
  }
}


class ExampleJsonSerializer implements JsonSerializer<Example, Map<String, dynamic>> {
  @override
  Example decode(Map<String, dynamic> output) {
    return Example(
      name: OtterInternal.decode(output['name']),
      age: OtterInternal.decode(output['age']),
      money: OtterInternal.decode(output['money']),
      list: OtterInternal.decodeList(output['list']),
      map: OtterInternal.decodeMap(output['map']),
      example2: OtterInternal.decode(output['example2']),
      example2s: OtterInternal.decodeList(output['example2s']),
    );
  }

  @override
  Map<String, dynamic> encode(Example input) {
    return {
      'name': OtterInternal.encode(input.name),
      'age': OtterInternal.encode(input.age),
      'money': OtterInternal.encode(input.money),
      'list': OtterInternal.encodeList(input.list),
      'map': OtterInternal.encodeMap(input.map),
      'example2': OtterInternal.encode(input.example2),
      'example2s': OtterInternal.encodeList(input.example2s),
    };
  }
}



class AnotherExampleJsonSerializer implements JsonSerializer<AnotherExample, Map<String, dynamic>> {
  @override
  AnotherExample decode(Map<String, dynamic> output) {
    return AnotherExample(
      name: OtterInternal.decode(output['name']),
    );
  }

  @override
  Map<String, dynamic> encode(AnotherExample input) {
    return {
      'name': OtterInternal.encode(input.name),
    };
  }
}

