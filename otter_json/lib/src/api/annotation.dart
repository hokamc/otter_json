// constrict user input
abstract class Json {}

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
