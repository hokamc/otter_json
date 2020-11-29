import 'package:example/person.dart';
import 'package:otter_json/otter_json.dart';

class GeneratedJsonModule implements JsonModule {
  @override
  Map<String, JsonSerializer> serializers() {
    return {
      'Person': _PersonJsonSerializer(),
    };
  }
}

class _PersonJsonSerializer implements JsonSerializer<Person, Map<String, dynamic>> {
  @override
  Person decode(Map<String, dynamic> output) {
    var object = Person();
    object.firstName = OtterInternal.decode(output['firstName']);
    object.lastName = OtterInternal.decode(output['lastName']);
    object.age = OtterInternal.decode(output['age']);
    object.isMale = OtterInternal.decode(output['isMale']);
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
      'isMale': OtterInternal.encode(input.isMale),
      'balance': OtterInternal.encode(input.balance),
      'weight': OtterInternal.encode(input.weight),
      'friends': OtterInternal.encodeList(input.friends),
      'cards': OtterInternal.encodeMap(input.cards),
      'color': OtterInternal.encode(input.color),
    };
  }
}
