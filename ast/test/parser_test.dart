import 'package:testcase/testcase.dart';
import 'package:arrow_ast/arrow_ast.dart';
export 'package:testcase/init.dart';

class ParserTest implements TestCase {
  setUp() {}
  tearDown() {}

  expectParsesTo(String source, matcher) {
    expect(parse(source), matcher);
  }

  @test
  it_parses_source_into_ast() {
    expectParsesTo('', const ArrowAst.empty());
    expectParsesTo(' ', const ArrowAst.empty());
    expectParsesTo(' \n', const ArrowAst.empty());
  }

  @test
  script_head() {
    expectParsesTo('''
      library x
    ''', const ArrowAst(const NodeList(const [
      const ScriptHead(const NodeList(const [
        const LibraryDeclaration(const Identifier('x'))
      ]))
    ])));
  }
}