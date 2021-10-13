<p align="center">
<img src="../icon.png"  width="200" alt="Otter JSON">
</p>
<h1 align="center">Otter JSON</h1>

<div align="center">

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)]()
[![Status](https://img.shields.io/badge/status-active-success.svg)]()

</div>

<p align="center"> 
JSON serialization with code generation.
<br></p>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Why use it](#why-use-it)
- [How to](#how-to)
- [Link](#link)
- [Authors](#authors)

## Why use it

Do you suffer from json_serializable? All generated code and 'part' make your source code messy. With Otter JSON, keep everything simple and clean.

## Features

- Generated code and source code are separated
- Easy to register new serializer
- Support all primitives
- Support flutter common class
- Support List<T>, Set<T>, Map<String, T>
- Support nested object

## How to

- dependencies
```yaml
dependencies:
  otter_json:

dev_dependencies:
  build_runner:
  otter_json_generator:
```

- annotate
```dart
@JSON
class Person {
  String firstName;
  String lastName;
}
```

- generate
```shell script
flutter pub run build_runner build
```

- register
```dart
Otter.module(GeneratedJsonModule());
```

- toJson, fromJson
```dart
Map<String, dynamic> map = Otter.toJson(Person());
Person person = Otter.fromJson({});
```

- custom serializer
```dart
class ColorSerializer implements JsonSerializer<Color, int> {
  @override
  Color decode(int output) {
    return Color(output);
  }

  @override
  int encode(Color input) {
    return input.value;
  }
}

Otter.serializer(ColorSerializer());
```

## Link

[otter_json](https://pub.dev/packages/otter_json)

[otter_json_generator](https://pub.dev/packages/otter_json_generator)

## Authors

- [@hokamc](https://github.com/hokamc)
