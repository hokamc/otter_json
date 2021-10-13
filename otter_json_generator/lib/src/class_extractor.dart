import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:otter_json/otter_json.dart';
import 'package:source_gen/source_gen.dart';

class ClassExtraction {
  final Set<ClassElement> userJsonSerializers;
  final Set<ClassElement> generatedJsonSerializers;

  ClassExtraction(this.userJsonSerializers, this.generatedJsonSerializers);

  @override
  String toString() {
    return 'userJsonSerializers: $userJsonSerializers\ngeneratedJsonSerializers: $generatedJsonSerializers';
  }
}

Future<ClassExtraction> extractClasses(BuildStep buildStep) async {
  final assets = buildStep.findAssets(Glob('**/*.dart'));

  final jsonChecker = TypeChecker.fromRuntime(Json);
  final importJsonModuleChecker = TypeChecker.fromRuntime(ImportJsonModule);
  final jsonModuleChecker = TypeChecker.fromRuntime(JsonModule);
  final userJsonSerializers = Set<ClassElement>();
  final generatedJsonSerializer = Set<ClassElement>();

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
        generatedJsonSerializer.add(cls);
      }
    }
  }

  return ClassExtraction(userJsonSerializers, generatedJsonSerializer);
}
