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
  }
}
