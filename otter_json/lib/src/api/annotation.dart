// constrict user input
abstract class Json {}

// annotate field with other name or annotate enum with other value
class JsonField {
  final String name;

  const JsonField(this.name);
}

// gather serializers for code generation
class JsonModule {
  final List<Type> serializers;

  const JsonModule(this.serializers);
}

// gather modules for code generations
class ImportJsonModule {
  final List<Type> modules;
  const ImportJsonModule(this.modules);
}
