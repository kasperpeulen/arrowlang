import 'package:testcase/testcase.dart';
import 'package:arrow_ast/arrow_ast.dart';
import 'package:arrow_ast/src/tokens.dart';
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

import a
import b as b
import c show A
import d hide B
import e show A hide B
import f as f show A hide B, A
export c show A
export d hide B
export e show A hide B
    '''.trim(), const ArrowAst(const NodeList(const [
      const ScriptHead(const NodeList(const [
        const LibraryDeclaration(
            const Token(TokenType.libraryKeyword, 'library', 0),
            const Token(TokenType.lineBreak, '\n\n', 9),
            const Identifier('x')
        ),
        const ImportDeclaration(
            const Token(TokenType.importKeyword, 'import', 11, line: 3, column: 0),
            const Token(TokenType.lineBreak, '\n', 19, line: 3, column: 8),
            const Identifier('a')
        ),
        const ImportDeclaration(
            const Token(TokenType.importKeyword, 'import', 20, line: 4, column: 0),
            const Token(TokenType.lineBreak, '\n', 33, line: 4, column: 13),
            const Identifier('b'),
            as: const Identifier('b')
        ),
        const ImportDeclaration(
            const Token(TokenType.importKeyword, 'import', 34, line: 5, column: 0),
            const Token(TokenType.lineBreak, '\n', 49, line: 5, column: 15),
            const Identifier('c'),
            show: const [const TypeName('A')]
        ),
        const ImportDeclaration(
            const Token(TokenType.importKeyword, 'import', 50, line: 6, column: 0),
            const Token(TokenType.lineBreak, '\n', 65, line: 6, column: 15),
            const Identifier('d'),
            hide: const [const TypeName('B')]
        ),
        const ImportDeclaration(
            const Token(TokenType.importKeyword, 'import', 66, line: 7, column: 0),
            const Token(TokenType.lineBreak, '\n', 88, line: 7, column: 22),
            const Identifier('e'),
            show: const [const TypeName('A')],
            hide: const [const TypeName('B')]
        ),
        const ImportDeclaration(
            const Token(TokenType.importKeyword, 'import', 89, line: 8, column: 0),
            const Token(TokenType.lineBreak, '\n', 119, line: 8, column: 30),
            const Identifier('f'),
            as: const Identifier('f'),
            show: const [const TypeName('A')],
            hide: const [const TypeName('B'), const TypeName('A')]
        ),
        const ExportDeclaration(
            const Token(TokenType.exportKeyword, 'export', 120, line: 9, column: 0),
            const Token(TokenType.lineBreak, '\n', 135, line: 9, column: 15),
            const Identifier('c'),
            show: const [const TypeName('A')]
        ),
        const ExportDeclaration(
            const Token(TokenType.exportKeyword, 'export', 136, line: 10, column: 0),
            const Token(TokenType.lineBreak, '\n', 151, line: 10, column: 15),
            const Identifier('d'),
            hide: const [const TypeName('B')]
        ),
        const ExportDeclaration(
            const Token(TokenType.exportKeyword, 'export', 152, line: 11, column: 0),
            const Token(TokenType.eof, null, 174, line: 11, column: 22),
            const Identifier('e'),
            show: const [const TypeName('A')],
            hide: const [const TypeName('B')]
        ),
      ]))
    ])));
  }

  @test
  parts() {
    expectParsesTo('''
      library x
      part y
    ''', const ArrowAst(const NodeList<TopLevelNode>(const <TopLevelNode>[
      const ScriptHead(const NodeList(const [
        const LibraryDeclaration($t, $t, const Identifier('x')),
        const PartDeclaration($t, $t, const Identifier('y')),
      ]))
    ])));
    expectParsesTo('''
      part of x
    ''', const ArrowAst(const NodeList<TopLevelNode>(const <TopLevelNode>[
      const ScriptHead(const NodeList(const [
        const PartOfDeclaration($t, $t, const Identifier('x')),
      ]))
    ])));
  }

  @test
  functions() {
    expectParsesTo(
        'main() {}',
        const ArrowAst(const NodeList<TopLevelNode>(const <TopLevelNode>[
          const ScriptHead.empty(),
          const TopLevelFunction(
              const Token(TokenType.identifier, 'main', 0),
              const Token(TokenType.closeCurly, '}', 8),
              const Identifier('main'),
              const UndeclaredType(),
              const <Argument>[],
              const NodeList<BlockLevelNode>.empty()
          )
        ]))
    );
    expectParsesTo(
        'd(d) {}',
        const ArrowAst(const NodeList<TopLevelNode>(const <TopLevelNode>[
          const ScriptHead.empty(),
          const TopLevelFunction(
              $t,
              $t,
              const Identifier('d'),
              const UndeclaredType(),
              const <Argument>[
                const Argument(const Identifier('d'), const UndeclaredType())
              ],
              const NodeList<BlockLevelNode>.empty()
          )
        ]))
    );
    expectParsesTo(
        '''
          x(a: A, b: B, [c: C, d: D]): X {}
          y(a: A, b: B, {c: C, d: D}): Y {}
        ''',
        const ArrowAst(const NodeList<TopLevelNode>(const <TopLevelNode>[
          const ScriptHead.empty(),
          const TopLevelFunction(
              $t, $t,
              const Identifier('x'),
              const TypeName('X'),
              const <Argument>[
                const Argument(
                    const Identifier('a'),
                    const TypeName('A')
                ),
                const Argument(
                    const Identifier('b'),
                    const TypeName('B')
                ),
                const OptionalArgument(
                    const Identifier('c'),
                    const TypeName('C')
                ),
                const OptionalArgument(
                    const Identifier('d'),
                    const TypeName('D')
                ),
              ],
              const NodeList<BlockLevelNode>.empty()
          ),
          const TopLevelFunction(
              $t, $t,
              const Identifier('y'),
              const TypeName('Y'),
              const <Argument>[
                const Argument(
                    const Identifier('a'),
                    const TypeName('A')
                ),
                const Argument(
                    const Identifier('b'),
                    const TypeName('B')
                ),
                const NamedArgument(
                    const Identifier('c'),
                    const TypeName('C')
                ),
                const NamedArgument(
                    const Identifier('d'),
                    const TypeName('D')
                ),
              ],
              const NodeList<BlockLevelNode>.empty()
          ),
        ]))
    );
  }
}

const $t = const MatchAllToken();