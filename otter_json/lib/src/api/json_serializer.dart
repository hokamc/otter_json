abstract class JsonSerializer<I, O> {
  O encode(I input);

  I decode(O output);
}
