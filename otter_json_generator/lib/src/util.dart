import 'package:analyzer/dart/element/element.dart';

String extractGenericType(String name) {
  int openIdx = name.indexOf('<') + 1;
  int closeIdx = name.lastIndexOf('>');
  if (openIdx < 1 || closeIdx < 0 || openIdx >= closeIdx) return "";
  return name.substring(openIdx, closeIdx);
}

List<String> extractMapGenericType(String name) {
  return extractGenericType(name).split(',').map((e) => e.trim()).toList();
}

void printClassElement(ClassElement classElement) {
  print({
    'enclosingElement.source.uri': classElement.enclosingElement.source.uri,
    'accessors': classElement.accessors,
    'allSupertypes': classElement.allSupertypes,
    'constructors': classElement.constructors,
    'displayName': classElement.displayName,
    'enclosingElement': classElement.enclosingElement,
    'fields': classElement.fields,
    'hasNonFinalField': classElement.hasNonFinalField,
    'hasStaticMember': classElement.hasStaticMember,
    'interfaces': classElement.interfaces,
    'isAbstract': classElement.isAbstract,
    'isDartCoreObject': classElement.isDartCoreObject,
    'isEnum': classElement.isEnum,
    'isMixin': classElement.isMixin,
    'isMixinApplication': classElement.isMixinApplication,
    'isValidMixin': classElement.isValidMixin,
    'methods': classElement.methods,
    'mixins': classElement.mixins,
    'name': classElement.name,
    'superclassConstraints': classElement.superclassConstraints,
    'supertype': classElement.supertype,
    'thisType': classElement.thisType,
    'unnamedConstructor': classElement.unnamedConstructor,
  });
}
