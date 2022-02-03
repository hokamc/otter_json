import 'package:analyzer/dart/element/element.dart';

import 'class_extractor.dart';

Set<String> getSupportedTypes(ClassExtraction classExtraction) {
  final Set<String> supportedTypes = {};
  for (final userJsonSerializer in classExtraction.userJsonSerializers) {
    supportedTypes.add(userJsonSerializer.getMethod('decode')!.returnType.toString());
  }
  for (final enumSerializer in classExtraction.enumSerializers) {
    supportedTypes.add(enumSerializer.name);
  }
  _validateCustomSerializers(classExtraction.userJsonSerializers, supportedTypes);
  for (final generatedJsonSerializer in classExtraction.generatedJsonSerializers) {
    supportedTypes.add(generatedJsonSerializer.name);
  }
  return supportedTypes;
}

void _validateCustomSerializers(Set<ClassElement> userJsonSerializers, Set<String> supportedTypes) {
  for (final userJsonSerializer in userJsonSerializers) {
    if (!supportedTypes.contains(userJsonSerializer.getMethod('encode')!.returnType.toString())) {
      throw ArgumentError.value(userJsonSerializer.name, 'supported types not contain custom serializer return type!');
    }
  }
}
