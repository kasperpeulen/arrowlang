import 'package:testcase/testcase.dart';
import 'package:arrow_ast/src/tokens.dart';
import 'package:arrow_ast/src/tokenizer.dart';
export 'package:testcase/init.dart';

class TokenizerTest implements TestCase {
  setUp() {}
  tearDown() {}

  void expectTokens(String source, Iterable<Token> expectedTokens) {
    final tokens = new Tokenizer(source).tokenize();
    expect(tokens, expectedTokens.toList()
      ..add(new Token(TokenType.eof, null, source.length)));
  }

  void expectToken(String source, TokenType type) {
    expectTokens(source, [new Token(type, source, 0)]);
  }

  @test
  all_tokens() {
    expectTokens('', []);
    expectToken(' ', TokenType.whitespace);
    expectToken('\n', TokenType.lineBreak);
    expectToken('//c', TokenType.lineComment);
    expectToken('///c', TokenType.lineComment);
    expectToken('/*c\nc*/', TokenType.multilineComment);
  }
}