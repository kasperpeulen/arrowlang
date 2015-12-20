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
            const QualifiedIdentifier(const [const Identifier('x')])
        ),
        const ImportDeclaration(
            const Token(TokenType.importKeyword, 'import', 11, line: 3, column: 0),
            const Token(TokenType.lineBreak, '\n', 19, line: 3, column: 8),
            name: const NamespaceQualifiedIdentifier(null, const QualifiedIdentifier(const [const Identifier('a')]))
        ),
        const ImportDeclaration(
            const Token(TokenType.importKeyword, 'import', 20, line: 4, column: 0),
            const Token(TokenType.lineBreak, '\n', 33, line: 4, column: 13),
            name: const NamespaceQualifiedIdentifier(null, const QualifiedIdentifier(const [const Identifier('b')])),
            as: const Identifier('b')
        ),
        const ImportDeclaration(
            const Token(TokenType.importKeyword, 'import', 34, line: 5, column: 0),
            const Token(TokenType.lineBreak, '\n', 49, line: 5, column: 15),
            name: const NamespaceQualifiedIdentifier(null, const QualifiedIdentifier(const [const Identifier('c')])),
            show: const [const TypeName(const Identifier('A'))]
        ),
        const ImportDeclaration(
            const Token(TokenType.importKeyword, 'import', 50, line: 6, column: 0),
            const Token(TokenType.lineBreak, '\n', 65, line: 6, column: 15),
            name: const NamespaceQualifiedIdentifier(null, const QualifiedIdentifier(const [const Identifier('d')])),
            hide: const [const TypeName(const Identifier('B'))]
        ),
        const ImportDeclaration(
            const Token(TokenType.importKeyword, 'import', 66, line: 7, column: 0),
            const Token(TokenType.lineBreak, '\n', 88, line: 7, column: 22),
            name: const NamespaceQualifiedIdentifier(null, const QualifiedIdentifier(const [const Identifier('e')])),
            show: const [const TypeName(const Identifier('A'))],
            hide: const [const TypeName(const Identifier('B'))]
        ),
        const ImportDeclaration(
            const Token(TokenType.importKeyword, 'import', 89, line: 8, column: 0),
            const Token(TokenType.lineBreak, '\n', 119, line: 8, column: 30),
            name: const NamespaceQualifiedIdentifier(null, const QualifiedIdentifier(const [const Identifier('f')])),
            as: const Identifier('f'),
            show: const [const TypeName(const Identifier('A'))],
            hide: const [const TypeName(const Identifier('B')), const TypeName(const Identifier('A'))]
        ),
        const ExportDeclaration(
            const Token(TokenType.exportKeyword, 'export', 120, line: 9, column: 0),
            const Token(TokenType.lineBreak, '\n', 135, line: 9, column: 15),
            name: const NamespaceQualifiedIdentifier(null, const QualifiedIdentifier(const [const Identifier('c')])),
            show: const [const TypeName(const Identifier('A'))]
        ),
        const ExportDeclaration(
            const Token(TokenType.exportKeyword, 'export', 136, line: 10, column: 0),
            const Token(TokenType.lineBreak, '\n', 151, line: 10, column: 15),
            name: const NamespaceQualifiedIdentifier(null, const QualifiedIdentifier(const [const Identifier('d')])),
            hide: const [const TypeName(const Identifier('B'))]
        ),
        const ExportDeclaration(
            const Token(TokenType.exportKeyword, 'export', 152, line: 11, column: 0),
            const Token(TokenType.eof, null, 174, line: 11, column: 22),
            name: const NamespaceQualifiedIdentifier(null, const QualifiedIdentifier(const [const Identifier('e')])),
            show: const [const TypeName(const Identifier('A'))],
            hide: const [const TypeName(const Identifier('B'))]
        ),
      ]))
    ])));

    expectParsesTo('import a:b.c.d',
        const ArrowAst(const NodeList(const [
          const ScriptHead(const NodeList(const [
            const ImportDeclaration($t, $t, name: const NamespaceQualifiedIdentifier(
                const Identifier('a'),
                const QualifiedIdentifier(const [
                  const Identifier('b'),
                  const Identifier('c'),
                  const Identifier('d'),
                ])
            ))
          ]))
        ]))
    );
    expectParsesTo('import "a"',
        const ArrowAst(const NodeList(const [
          const ScriptHead(const NodeList(const [
            const ImportDeclaration($t, $t, uri: '"a"')
          ]))
        ]))
    );
  }

  @test
  parts() {
    expectParsesTo('''
      library x.y
      part y
    ''', const ArrowAst(const NodeList<TopLevelNode>(const <TopLevelNode>[
      const ScriptHead(const NodeList(const [
        const LibraryDeclaration($t, $t, const QualifiedIdentifier(const [const Identifier('x'), const Identifier('y')])),
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
              const TypeName(const Identifier('X')),
              const <Argument>[
                const Argument(
                    const Identifier('a'),
                    const TypeName(const Identifier('A'))
                ),
                const Argument(
                    const Identifier('b'),
                    const TypeName(const Identifier('B'))
                ),
                const OptionalArgument(
                    const Identifier('c'),
                    const TypeName(const Identifier('C'))
                ),
                const OptionalArgument(
                    const Identifier('d'),
                    const TypeName(const Identifier('D'))
                ),
              ],
              const NodeList<BlockLevelNode>.empty()
          ),
          const TopLevelFunction(
              $t, $t,
              const Identifier('y'),
              const TypeName(const Identifier('Y')),
              const <Argument>[
                const Argument(
                    const Identifier('a'),
                    const TypeName(const Identifier('A'))
                ),
                const Argument(
                    const Identifier('b'),
                    const TypeName(const Identifier('B'))
                ),
                const NamedArgument(
                    const Identifier('c'),
                    const TypeName(const Identifier('C'))
                ),
                const NamedArgument(
                    const Identifier('d'),
                    const TypeName(const Identifier('D'))
                ),
              ],
              const NodeList<BlockLevelNode>.empty()
          ),
        ]))
    );
    expectParsesTo(
        '''
          x(): sync X {}
          x(): sync* X {}
          x(): async X {}
          x(): async* X {}
        ''',
        const ArrowAst(const NodeList<TopLevelNode>(const <TopLevelNode>[
          const ScriptHead.empty(),
          const TopLevelFunction(
              $t, $t,
              const Identifier('x'),
              const TypeName(const Identifier('X')),
              const <Argument>[],
              const NodeList<BlockLevelNode>.empty()
          ),
          const TopLevelFunction(
              $t, $t,
              const Identifier('x'),
              const TypeName(const Identifier('X'), multi: true),
              const <Argument>[],
              const NodeList<BlockLevelNode>.empty()
          ),
          const TopLevelFunction(
              $t, $t,
              const Identifier('x'),
              const TypeName(const Identifier('X'), async: true),
              const <Argument>[],
              const NodeList<BlockLevelNode>.empty()
          ),
          const TopLevelFunction(
              $t, $t,
              const Identifier('x'),
              const TypeName(const Identifier('X'), async: true, multi: true),
              const <Argument>[],
              const NodeList<BlockLevelNode>.empty()
          ),
        ]))
    );
  }

  @test
  blocks() {
    expectParsesTo(
        'x() {let x = 3}',
        const ArrowAst(const NodeList<TopLevelNode>(const <TopLevelNode>[
        const ScriptHead.empty(),
            const TopLevelFunction(
                $t, $t,
                const Identifier('x'),
                const TypeName(const Identifier('X')),
                const <Argument>[],
                const NodeList<BlockLevelNode>(const [
                  const BlockLevelValueDeclaration(
                      $t, $t,
                      const Identifier('x'),
                      assignment: const Expression(const [
                          const NumberLiteral(3)
                      ])
                  )
                ])
            )
        ]))
    );
  }
}

const $t = const MatchAllToken();
