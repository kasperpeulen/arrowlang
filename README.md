# Arrow Programming Language

Arrow is an experimental programming language based on [Dart](https://www.dartlang.org),
that explores more radical changes to the Dart language that doesn't need to be reviewed
or opinionated. It should be noted that at this point the changes are my
([Emil Persson](https://github.com/emilniklas)) personal preferences.

## Usage
```shell
> git clone https://emilniklas/arrowlang
> cd arrowlang/arrow2dart
> pub get
> arrow2dart -h
```

## Changes to the Dart language

#### Optional semicolons
Each statement is terminated by either a semicolon or a line break.

```dart
// Dart
print("something");
```

```arrow
// Arrow
print("something")
```

#### Let is Final
Read only values should be encouraged, and not an awkward addition in verbosity,
so the `final` keyword from Dart is `let` in Arrow:

```dart
final x;
```

```arrow
let x
```

As a bonus, all function arguments are now final:

```dart
myFunc(final x) {}
```

```arrow
myFunc(x) {}
```

#### Right hand types
Dart uses the C style left hand types for functions and variables:

```dart
String myVar = "abc";
```

However, there are some inconsistencies when Dart adds the `final` and `const` keywords,
as well as the syntax for untyped (inferred) declarations:

```dart
String myVar;
final String myFinal;
const String myConst;

var myVar;
final myFinal;
const myConst;

String myFunc() {}
```

Arrow doesn't mix up the mutability of a value with its type, instead it uses the colon
syntax found in other modern languages:

```arrow
var myVar: String
let myFinal: String
const myConst: String

var myVar
let myFinal
const myConst

myFunc(): String {}
```

#### Universal modifiers
This one is quite controversial, but hear me out.

Here's the current async/await modifiers as of Dart 1.9:

```dart
String x() {}
Iterable<String> x() sync* {}
Future<String> x() async {}
Stream<String> x() async* {}
```

If the function should not be modified, but still return one of the types above,
nothing changes other than the modifier part, which is not a part of the signature
of the function.

Arrow adds a fourth modifier, `sync`. This modifier is optional and *inferred* on
each *unmodified* function declaration:

```arrow
x(): String {}
x(): sync String {}
```

```dart
String x() {}
String x() {}
```

With this addition (although potentially _never_ used), we can construct single and
multiple values asynchronously or no:

```arrow
x(): sync {}   // dynamic
x(): async {}  // Future<dynamic>
x(): sync* {}  // Iterable<dynamic>
x(): async* {} // Stream<dynamic>
```

Finally, Arrow makes the modifier *part of the declaration, but not the signature*. That
means that the modifier changes the functions return type without forcing the author to
type it out:

```arrow
x(): sync String {}    // String
x(): async String {}   // Future<String>
x(): sync* String {}   // Iterable<String>
x(): async* String {}  // Stream<String>

x(): Future<String> {} // inferred "sync Future<String>" meaning return type is Future<String>
```

#### Consistent type name casing
Ever wondered why the basic types in Dart are `String`, `bool`, `num`, `int`, `double`?
Arrow uses upper camel case for all those types: `String`, `Bool`, `Num`, `Int`, `Double`.

#### Null is void
In Dart, `void` is only ever used to declare a function that will not return anything. However,
it does return something – `null`! There is also a type for the `null` literal called `Null` that
is never really used. In Arrow, `void` doesn't exist. To declare a function that returns nothing,
use `Null`:

```dart
void myFunc() {}
```

```arrow
myFunc(): Null {}
```

#### Import/Export/Part URI literals
As an optional addition, these "syntactic sugars" is applied to import, export, and part statements:

```arrow
import my_pack:
import my_pack:file
import my_pack:dir.file
import dart:html
import file
import dir.file

part file
part dir.file
```

```dart
import 'package:my_pack/my_pack.dart';
import 'package:my_pack/file.dart';
import 'package:my_pack/dir/file.dart';
import 'dart:html';
import 'file.dart';
import 'dir/file.dart';

part 'file.dart';
part 'dir/file.dart';
```

---

## Review
Let's look at an Arrow script and see how it transforms to Dart:

```arrow
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
```

```dart
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
```

