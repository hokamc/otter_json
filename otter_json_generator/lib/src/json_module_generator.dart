import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:otter_json/otter_json.dart';
import 'package:source_gen/source_gen.dart';

class JsonModuleBuilder implements Builder {
  @override
  final buildExtensions = const {
    r'$lib$': ['generated/generated_json_module.dart']
  };

  String enumSerializer(ClassElement clazz) {
    var enums = StringBuffer();
    enums.writeln('{');
    clazz.fields.where((field) => field.isEnumConstant).forEach((field) {
      enums.writeln("    '${field.name}': ${clazz.name}.${field.name},");
    });
    enums.write('  };');

    return '''

class _${clazz.name}JsonSerializer implements JsonSerializer<${clazz.name}, String>{
  final Map<String, ${clazz.name}> enums = $enums
  
  @override
  ${clazz.name} decode(String output) {
    var result = enums[output];
    if (result == null) {
      throw ArgumentError('enum not found, output=\$output');
    }
    return result;
  }

  @override
  String encode(${clazz.name} input) {
    return describeEnum(input);
  }
}
''';
  }

  String objectSerializer(ClassElement clazz) {
    var constructor = StringBuffer();
    var mapper = StringBuffer();

    constructor.writeln('var object = ${clazz.name}();');
    mapper.writeln('return {');

    clazz.fields.forEach((field) {
      if (field.type.isDartCoreList) {
        constructor.writeln("    object.${field.name} = OtterInternal.decodeList(output['${field.name}']);");
        mapper.writeln("      '${field.name}': OtterInternal.encodeList(input.${field.name}),");
      } else if (field.type.isDartCoreSet) {
        constructor.writeln("    object.${field.name} = OtterInternal.decodeSet(output['${field.name}']);");
        mapper.writeln("      '${field.name}': OtterInternal.encodeSet(input.${field.name}),");
      } else if (field.type.isDartCoreMap) {
        constructor.writeln("    object.${field.name} = OtterInternal.decodeMap(output['${field.name}']);");
        mapper.writeln("      '${field.name}': OtterInternal.encodeMap(input.${field.name}),");
      } else {
        constructor.writeln("    object.${field.name} = OtterInternal.decode(output['${field.name}']);");
        mapper.writeln("      '${field.name}': OtterInternal.encode(input.${field.name}),");
      }
    });

    constructor.write('    return object;');
    mapper.write('    };');

    return '''

class _${clazz.name}JsonSerializer implements JsonSerializer<${clazz.name}, Map<String, dynamic>>{
  @override
  ${clazz.name} decode(Map<String, dynamic> output) {
    $constructor
  }

  @override
  Map<String, dynamic> encode(${clazz.name} input) {
    $mapper
  }
}
''';
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final assets = buildStep.findAssets(Glob('**/*.dart'));

    var serializers = Set();
    var enums = Set();
    var dependencies = Set();
    var module = Set();

    await for (final asset in assets) {
      final library = LibraryReader(await buildStep.resolver.libraryFor(asset));

      var typeChecker = TypeChecker.fromRuntime(JSON);
      for (var annotatedElement in library.annotatedWith(typeChecker)) {
        if (annotatedElement.element is ClassElement) {
          ClassElement classElement = annotatedElement.element;

          classElement.fields.forEach((element) {
            ClassElement enumElement = element.type.element;
            if (enumElement.isEnum && enums.add(enumElement.name)) {
              serializers.add(enumSerializer(enumElement));
              dependencies.add("import '${enumElement.library.identifier}';");
              module.add("      '${enumElement.name}': _${enumElement.name}JsonSerializer(),");
            }
          });

          var anyFinals = classElement.fields.any((e) => e.isFinal);
          var anyPrivates = classElement.fields.any((e) => e.isPrivate);

          if (anyFinals) {
            throw ArgumentError('[ERROR] all fields should not be final, class=${classElement.name}');
          }

          if (anyPrivates) {
            throw ArgumentError('[ERROR] all fields should not be private, class=${classElement.name}');
          }

          serializers.add(objectSerializer(classElement));
          dependencies.add("import '${classElement.library.identifier}';");
          module.add("      '${classElement.name}': _${classElement.name}JsonSerializer(),");
        }
      }

      var code = '''

import 'package:otter_json/otter_json.dart';
import 'package:flutter/foundation.dart';
${dependencies.join('\n')}

class GeneratedJsonModule implements JsonModule {
  @override
  Map<String, JsonSerializer> serializers() {
    return {
${module.join('\n')}
    };
  }
}

${serializers.join('\n')}

''';

      await buildStep.writeAsString(AssetId(buildStep.inputId.package, 'lib/generated/generated_json_module.dart'), code);
    }
  }
}
