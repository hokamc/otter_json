import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:otter_json/otter_json.dart';
import 'package:otter_json_generator/src/template.dart';
import 'package:otter_json_generator/src/util.dart';
import 'package:source_gen/source_gen.dart';

class GeneratedJsonSerializerInfo {
  final String className;
  final String uri;
  final bool enumIsInt;
  final List<GeneratedJsonSerializerFieldInfo> fields;

  GeneratedJsonSerializerInfo(this.className, this.fields, this.uri, {this.enumIsInt = false});

  @override
  String toString() {
    return 'className: $className\nfields: $fields\nuri:$uri';
  }
}

class GeneratedJsonSerializerFieldInfo {
  final FieldType type;
  final bool isNullable;
  final String inputName;
  final String outputName;

  GeneratedJsonSerializerFieldInfo(this.type, this.isNullable, this.inputName, this.outputName);
}

class Modules {
  final Set<String> dependencies;
  final Set<String> modules;

  Modules(this.dependencies, this.modules);
}

enum FieldType { list, map, field, enumT }

List<GeneratedJsonSerializerInfo> generateJsonSerializerFieldInfo(Set<String> supportedTypes, Set<ClassElement> generatedJsonSerializers) {
  List<GeneratedJsonSerializerInfo> infos = [];
  for (final generatedJsonSerializer in generatedJsonSerializers) {
    if (generatedJsonSerializer.unnamedConstructor!.parameters.any((parameter) => !parameter.isNamed)) {
      throw ArgumentError.value(generatedJsonSerializer.name, 'all parameters in constructor must be named');
    }

    GeneratedJsonSerializerInfo info =
    GeneratedJsonSerializerInfo(generatedJsonSerializer.displayName, [], generatedJsonSerializer.enclosingElement.source.uri.toString());
    final jsonFieldChecker = TypeChecker.fromRuntime(JsonField);

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

      String outputKey = field.name;
      if (jsonFieldChecker.hasAnnotationOf(field)) {
        outputKey = jsonFieldChecker.firstAnnotationOf(field)!.getField("name")!.toStringValue()!;
      }

      bool isNullable = field.type.nullabilitySuffix == NullabilitySuffix.question;
      info.fields.add(GeneratedJsonSerializerFieldInfo(_fieldType(field.type), isNullable, field.name, outputKey));
    }

    infos.add(info);
  }
  return infos;
}

List<GeneratedJsonSerializerInfo> generateEnumSerializerFieldInfo(Set<ClassElement> enumJsonSerializers) {
  List<GeneratedJsonSerializerInfo> infos = [];

  for (final enumSerializer in enumJsonSerializers) {
    List<GeneratedJsonSerializerFieldInfo> fields = [];
    final jsonFieldChecker = TypeChecker.fromRuntime(JsonField);

    bool init = false;
    bool enumIsInt = false;
    for (var i = 0; i < enumSerializer.fields.length; i++) {
      FieldElement field = enumSerializer.fields[i];
      if (!field.isEnumConstant) {
        continue;
      }
      String outputKey = field.name;
      if (jsonFieldChecker.hasAnnotationOf(field)) {
        DartObject fieldValue = jsonFieldChecker.firstAnnotationOf(field)!.getField("name")!;

        DartType fieldType = fieldValue.type!;
        if (!fieldType.isDartCoreInt && !fieldType.isDartCoreString) {
          throw ArgumentError("all enum json field must be int or string");
        }
        if (!init) {
          enumIsInt = fieldType.isDartCoreInt;
          init = true;
        } else if (enumIsInt != fieldType.isDartCoreInt) {
          throw ArgumentError("all enum json field must have same type of value");
        }
        if (enumIsInt) {
          outputKey = fieldValue.toIntValue()!.toString();
        } else {
          outputKey = fieldValue.toStringValue()!;
        }
      } else if (enumIsInt) {
        throw ArgumentError("all enum json field must have same type of value");
      }
      fields.add(GeneratedJsonSerializerFieldInfo(FieldType.enumT, false, field.name, outputKey));
    }

    infos.add(
        GeneratedJsonSerializerInfo(enumSerializer.displayName, fields, enumSerializer.enclosingElement.source.uri.toString(), enumIsInt: enumIsInt));
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
        decode.write("      ${field.inputName}: OtterInternal.decodeList(output['${field.outputName}'])");
        encode.write("      '${field.outputName}': OtterInternal.encodeList(input.${field.inputName})");
        break;
      case FieldType.map:
        decode.write("      ${field.inputName}: OtterInternal.decodeMap(output['${field.outputName}'])");
        encode.write("      '${field.outputName}': OtterInternal.encodeMap(input.${field.inputName})");
        break;
      case FieldType.field:
        decode.write("      ${field.inputName}: OtterInternal.decode(output['${field.outputName}'])");
        encode.write("      '${field.outputName}': OtterInternal.encode(input.${field.inputName})");
        if (!field.isNullable) {
          decode.write('!');
          encode.write('!');
        }
        break;
      case FieldType.enumT:
        break;
    }
    decode.write(',\n');
    encode.write(',\n');
  });

  decode.write('    );');
  encode.write('    };');

  return jsonSerializerTemplate(info.className, encode.toString(), decode.toString());
}

String generateEnumSerializer(GeneratedJsonSerializerInfo info) {
  final decode = StringBuffer();
  var encode = StringBuffer();

  info.fields.forEach((field) {
    if (info.enumIsInt) {
      encode.writeln("      ${info.className}.${field.inputName}: ${field.outputName},");
      decode.writeln("      ${field.outputName}: ${info.className}.${field.inputName},");
    } else {
      encode.writeln("      ${info.className}.${field.inputName}: '${field.outputName}',");
      decode.writeln("      '${field.outputName}': ${info.className}.${field.inputName},");
    }
  });

  return enumJsonSerializerTemplate(info.className, encode.toString(), decode.toString(), info.enumIsInt ? 'int' : 'String');
}

Modules generateModules(Set<ClassElement> userJsonSerializers, List<GeneratedJsonSerializerInfo> serializerInfos) {
  Set<String> dependencies = {};
  Set<String> modules = {};
  for (final userJsonSerializer in userJsonSerializers) {
    dependencies.add("import '${userJsonSerializer.enclosingElement.source.uri.toString()}';");
    modules.add("      '${userJsonSerializer.getMethod('decode')!.returnType.toString()}': ${userJsonSerializer.name}(),");
  }
  for (final serializerInfo in serializerInfos) {
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
