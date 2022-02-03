import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:otter_json/otter_json.dart';
import 'package:source_gen/source_gen.dart';

class ClassExtraction {
  final Set<ClassElement> userJsonSerializers;
  final Set<ClassElement> generatedJsonSerializers;
  final Set<ClassElement> enumSerializers;

  ClassExtraction(this.userJsonSerializers, this.generatedJsonSerializers, this.enumSerializers);
}

Future<ClassExtraction> extractClasses(BuildStep buildStep) async {
  final assets = buildStep.findAssets(Glob('**/*.dart'));

  final jsonChecker = TypeChecker.fromRuntime(Json);
  final importJsonModuleChecker = TypeChecker.fromRuntime(ImportJsonModule);
  final jsonModuleChecker = TypeChecker.fromRuntime(JsonModule);
  final userJsonSerializers = Set<ClassElement>();
  final preGenerateJsonSerializers = Set<ClassElement>();
  final enumSerializer = Set<ClassElement>();

  await for (final asset in assets) {
    final library = LibraryReader(await buildStep.resolver.libraryFor(asset));

    for (var cls in library.classes) {
      if (importJsonModuleChecker.hasAnnotationOf(cls)) {
        for (final modules in importJsonModuleChecker.firstAnnotationOf(cls)!.getField('modules')!.toListValue()!) {
          for (var serializer in jsonModuleChecker.firstAnnotationOf(modules.toTypeValue()!.element!)!.getField('serializers')!.toListValue()!) {
            userJsonSerializers.add(serializer.toTypeValue()!.element! as ClassElement);
          }
        }
      } else if (jsonChecker.isAssignableFrom(cls)) {
        preGenerateJsonSerializers.add(cls);

        for (var field in cls.fields) {
          ClassElement fieldClass = field.type.element as ClassElement;

          if (fieldClass.isEnum) {
            enumSerializer.add(fieldClass);
          }
        }
      }
    }
  }

  return ClassExtraction(userJsonSerializers, preGenerateJsonSerializers, enumSerializer);
}
