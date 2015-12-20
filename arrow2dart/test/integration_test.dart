import 'package:testcase/testcase.dart';
export 'package:testcase/init.dart';
import 'package:arrow2dart/arrow2dart.dart';

class IntegrationTest extends TestCase {
  setUp() {}

  tearDown() {}

  expectArrow2Dart(String arrow, String dart) {
    expect(arrow2dart(arrow).trim(), dart);
  }

  @test
  script_head() {
    expectArrow2Dart('library x', "library x;");
    expectArrow2Dart('x() {}', "x() {}");
    expectArrow2Dart('x(): Null {}', "void x() {}");
    expectArrow2Dart('x(): X {}', "X x() {}");
    expectArrow2Dart('x(): sync X {}', "X x() {}");
    expectArrow2Dart('x(): sync* X {}', "Iterable<X> x() sync* {}");
    expectArrow2Dart('x(): async X {}', "Future<X> x() async {}");
    expectArrow2Dart('x(): async* X {}', "Stream<X> x() async* {}");
    expectArrow2Dart('x(): sync Future<X> {}', "Future<X> x() {}");
    expectArrow2Dart('x(): Future<X> {}', "Future<X> x() {}");
    expectArrow2Dart('import x', "import 'x.dart';");
    expectArrow2Dart('import x.y', "import 'x/y.dart';");
    expectArrow2Dart('import x:', "import 'package:x/x.dart';");
    expectArrow2Dart('import x:y', "import 'package:x/y.dart';");
    expectArrow2Dart('import dart:html', "import 'dart:html';");
    expectArrow2Dart("import 'a.dart'", "import 'a.dart';");
  }

  @test
  example_script() {
    expectArrow2Dart(r'''
library my_library

import other_package:
import other_package:util

part my_util

main(): async Null {
  let greeting = 'Hello'
  let name = 'Friend'

  let message = await new Greeter(greeting).greet(name)

  print(message) // Hello, Friend!
}

class Greeter {
  let greeting: String

  Greeter(this.greeting)

  greet(name: String): async String {
    await something

    return '$greeting, $name!'
  }
}
    ''', r'''
library my_library;

import 'package:other_package/other_package.dart';
import 'package:other_package/util.dart';

part 'my_util.dart';

Future main() {
  final greeting = 'Hello';
  final name = 'Friend';

  final message = await new Greeter(greeting).greet(name);

  print(message); // Hello, Friend!
}

class Greeter {
  final String greeting;

  Greeter(this.greeting);

  Future<String> greet(String name) async {
    await something;

    return '$greeting, $name!';
  }
}
    ''');
  }
}
