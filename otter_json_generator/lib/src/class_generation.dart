import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:otter_json_generator/src/template.dart';
import 'package:otter_json_generator/src/util.dart';

class GeneratedJsonSerializerInfo {
  final String className;
  final String uri;
  final List<GeneratedJsonSerializerFieldInfo> fields;

  GeneratedJsonSerializerInfo(this.className, this.fields, this.uri);

  @override
  String toString() {
    return 'className: $className\nfields: $fields\nuri:$uri';
  }
}

class GeneratedJsonSerializerFieldInfo {
  final FieldType type;
  final String name;

  GeneratedJsonSerializerFieldInfo(this.type, this.name);

  @override
  String toString() {
    return 'type: $type\nname: $name';
  }
}

class Modules {
  final Set<String> dependencies;
  final Set<String> modules;

  Modules(this.dependencies, this.modules);
}

enum FieldType { list, map, field }

List<GeneratedJsonSerializerInfo> generateJsonSerializerFieldInfo(Set<String> supportedTypes, Set<ClassElement> generatedJsonSerializers) {
  List<GeneratedJsonSerializerInfo> infos = [];
  for (final generatedJsonSerializer in generatedJsonSerializers) {
    if (generatedJsonSerializer.unnamedConstructor!.parameters.any((parameter) => !parameter.isNamed)) {
      throw ArgumentError.value(generatedJsonSerializer.name, 'all parameters in constructor must be named');
    }

    GeneratedJsonSerializerInfo info =
        GeneratedJsonSerializerInfo(generatedJsonSerializer.displayName, [], generatedJsonSerializer.enclosingElement.source.uri.toString());

    for (final field in generatedJsonSerializer.fields) {
      if (field.type.isDartCoreList) {
        String type = extractGenericType(field.type.toString());
        if (type.isEmpty || !supportedTypes.contains(type)) {
          throw ArgumentError.value(field.name, 'only one layer of list,set is accepted and support types not include that possible types');
        }
      } else if (field.type.isDartCoreMap) {
        List<String> types = extractMapGenericType(field.type.toString());
        if (types.length != 2 || types[0] != 'String' || !supportedTypes.contains(types[1])) {
          throw ArgumentError.value(
              field.name, 'only one layer of map is accepted, first type must be string and support types not include that second type');
        }
      } else if (!supportedTypes.contains(field.type.element!.displayName)) {
        throw ArgumentError.value(field.name, 'type is not included in that possible types');
      }

      info.fields.add(GeneratedJsonSerializerFieldInfo(_fieldType(field.type), field.name));
    }

    infos.add(info);
  }
  return infos;
}

String generateSerializer(GeneratedJsonSerializerInfo info) {
  final decode = StringBuffer();
  var encode = StringBuffer();

  decode.writeln('return ${info.className}(');
  encode.writeln('return {');

  info.fields.forEach((field) {
    switch (field.type) {
      case FieldType.list:
        decode.writeln("      ${field.name}: OtterInternal.decodeList(output['${field.name}']),");
        encode.writeln("      '${field.name}': OtterInternal.encodeList(input.${field.name}),");
        break;
      case FieldType.map:
        decode.writeln("      ${field.name}: OtterInternal.decodeMap(output['${field.name}']),");
        encode.writeln("      '${field.name}': OtterInternal.encodeMap(input.${field.name}),");
        break;
      case FieldType.field:
        decode.writeln("      ${field.name}: OtterInternal.decode(output['${field.name}']),");
        encode.writeln("      '${field.name}': OtterInternal.encode(input.${field.name}),");
        break;
    }
  });

  decode.write('    );');
  encode.write('    };');

  return jsonSerializerTemplate(info.className, encode.toString(), decode.toString());
}

Modules generateModules(Set<ClassElement> userJsonSerializers, List<GeneratedJsonSerializerInfo> serializerInfos) {
  Set<String> dependencies = {};
  Set<String> modules = {};
  for (final userJsonSerializer in userJsonSerializers) {
    dependencies.add("import '${userJsonSerializer.enclosingElement.source.uri.toString()}';");
    modules.add("      '${userJsonSerializer.getMethod('decode')!.returnType.toString()}': ${userJsonSerializer.name}(),");
  }
  for (var serializerInfo in serializerInfos) {
    dependencies.add("import '${serializerInfo.uri}';");
    modules.add("      '${serializerInfo.className}': ${serializerInfo.className}JsonSerializer(),");
  }
  return Modules(dependencies, modules);
}

FieldType _fieldType(DartType type) {
  if (type.isDartCoreList) {
    return FieldType.list;
  } else if (type.isDartCoreMap) {
    return FieldType.map;
  } else {
    return FieldType.field;
  }
}
