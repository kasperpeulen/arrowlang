main() {
  // prints "Greetings, friend!"
  new Greeter('Greetings').greet('friend');
}

class Greeter {
  final String greeting;

  Greeter(this.greeting);

  void greet(final String name) {
    final message = '$greeting, $name!';

    print(message);
  }
}