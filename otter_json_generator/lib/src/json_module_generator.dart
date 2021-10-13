import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:otter_json_generator/src/class_extractor.dart';
import 'package:otter_json_generator/src/class_generation.dart';
import 'package:otter_json_generator/src/template.dart';

class ClassTraverse {
  ClassElement classElement;
  List<ClassElement> fieldElements;

  ClassTraverse(this.classElement, this.fieldElements);
}

class JsonModuleBuilder implements Builder {
  @override
  final buildExtensions = const {
    r'$lib$': ['json_module.gen.dart']
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    ClassExtraction classExtraction = await extractClasses(buildStep);
    final Set<String> supportedTypes = {};
    for (final userJsonSerializer in classExtraction.userJsonSerializers) {
      supportedTypes.add(userJsonSerializer.getMethod('encode')!.returnType.toString());
    }
    for (final generatedJsonSerializer in classExtraction.generatedJsonSerializers) {
      supportedTypes.add(generatedJsonSerializer.name);
    }
    List<GeneratedJsonSerializerInfo> serializerInfos = generateJsonSerializerFieldInfo(supportedTypes, classExtraction.generatedJsonSerializers);
    List<String> generatedSerializers = serializerInfos.map((info) => generateSerializer(info)).toList();
    Modules modules = generateModules(classExtraction.userJsonSerializers, serializerInfos);
    String generatedJsonModule = generatedModuleTemplate(modules.dependencies, modules.modules);
    await buildStep.writeAsString(
        AssetId(buildStep.inputId.package, 'lib/json_module.gen.dart'), generatedJsonModule + generatedSerializers.join('\n'));
  }
}
