import 'package:testcase/testcase.dart';
export 'package:testcase/init.dart';
import 'package:arrow2dart/arrow2dart.dart';

class IntegrationTest extends TestCase {
  setUp() {}

  tearDown() {}

  expectArrow2Dart(String arrow, String dart) {
    expect(arrow2dart(arrow), dart);
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
  }
}
