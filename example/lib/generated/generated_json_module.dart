import 'package:example/person.dart';
import 'package:flutter/foundation.dart';
import 'package:otter_json/otter_json.dart';

class GeneratedJsonModule implements JsonModule {
  @override
  Map<String, JsonSerializer> serializers() {
    return {
      'Gender': _GenderJsonSerializer(),
      'Person': _PersonJsonSerializer(),
    };
  }
}


class _GenderJsonSerializer implements JsonSerializer<Gender, String> {
  final Map<String, Gender> enums = {
    'Male': Gender.Male,
    'Female': Gender.Female,
  };

  @override
  Gender decode(String output) {
    var result = enums[output];
    if (result == null) {
      throw ArgumentError('enum not found, output=$output');
    }
    return result;
  }

  @override
  String encode(Gender input) {
    return describeEnum(input);
  }
}


class _PersonJsonSerializer implements JsonSerializer<Person, Map<String, dynamic>> {
  @override
  Person decode(Map<String, dynamic> output) {
    var object = Person();
    object.firstName = OtterInternal.decode(output['firstName']);
    object.lastName = OtterInternal.decode(output['lastName']);
    object.age = OtterInternal.decode(output['age']);
    object.isOld = OtterInternal.decode(output['isOld']);
    object.gender = OtterInternal.decode(output['gender']);
    object.balance = OtterInternal.decode(output['balance']);
    object.weight = OtterInternal.decode(output['weight']);
    object.friends = OtterInternal.decodeList(output['friends']);
    object.cards = OtterInternal.decodeMap(output['cards']);
    object.color = OtterInternal.decode(output['color']);
    return object;
  }

  @override
  Map<String, dynamic> encode(Person input) {
    return {
      'firstName': OtterInternal.encode(input.firstName),
      'lastName': OtterInternal.encode(input.lastName),
      'age': OtterInternal.encode(input.age),
      'isOld': OtterInternal.encode(input.isOld),
      'gender': OtterInternal.encode(input.gender),
      'balance': OtterInternal.encode(input.balance),
      'weight': OtterInternal.encode(input.weight),
      'friends': OtterInternal.encodeList(input.friends),
      'cards': OtterInternal.encodeMap(input.cards),
      'color': OtterInternal.encode(input.color),
    };
  }
}


