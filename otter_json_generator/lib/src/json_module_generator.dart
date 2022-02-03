import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:otter_json_generator/src/class_extractor.dart';
import 'package:otter_json_generator/src/class_generation.dart';
import 'package:otter_json_generator/src/support_types.dart';
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
    final Set<String> supportedTypes = getSupportedTypes(classExtraction);
    List<GeneratedJsonSerializerInfo> generatedSerializerInfos =
        generateJsonSerializerFieldInfo(supportedTypes, classExtraction.generatedJsonSerializers);
    List<GeneratedJsonSerializerInfo> enumSerializerInfos = generateEnumSerializerFieldInfo(classExtraction.enumSerializers);
    List<String> generatedSerializers = generatedSerializerInfos.map((info) => generateSerializer(info)).toList();
    generatedSerializers.addAll(enumSerializerInfos.map((info) => generateEnumSerializer(info)));
    Modules modules = generateModules(classExtraction.userJsonSerializers, [...generatedSerializerInfos, ...enumSerializerInfos]);
    String generatedJsonModule = generatedModuleTemplate(modules.dependencies, modules.modules);
    await buildStep.writeAsString(
        AssetId(buildStep.inputId.package, 'lib/json_module.gen.dart'), generatedJsonModule + generatedSerializers.join('\n'));
  }
}
