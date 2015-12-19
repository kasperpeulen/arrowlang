import 'package:testcase/testcase.dart';
import 'package:arrow_ast/src/tokens.dart';
import 'package:arrow_ast/src/tokenizer.dart';
export 'package:testcase/init.dart';

class TokenizerTest implements TestCase {
  setUp() {}
  tearDown() {}

  void expectTokens(String source, Iterable<Token> expectedTokens) {
    final tokenizer = new Tokenizer(source);
    final tokens = tokenizer.tokenize();
    final offset = source.length;
    expect(tokens, expectedTokens.toList()
      ..add(new Token(
          TokenType.eof,
          null,
          offset,
          line: tokenizer.currentLine(offset),
          column: tokenizer.currentColumn(offset))
      )
    );
  }

  void expectToken(String source, TokenType type) {
    expectTokens(source, [new Token(type, source, 0)]);
  }

  @test
  all_tokens() {
    expectTokens('', []);
    expectToken(' ', TokenType.whitespace);
    expectToken('\n', TokenType.lineBreak);
    expectToken('\n\n', TokenType.lineBreak);
    expectToken('\n  \n', TokenType.lineBreak);
    expectToken('\n  \n\n  \n\t \n', TokenType.lineBreak);

    // Keywords
    expectToken('abstract', TokenType.abstractKeyword);
    expectToken('continue', TokenType.continueKeyword);
    expectToken('false', TokenType.falseKeyword);
    expectToken('new', TokenType.newKeyword);
    expectToken('this', TokenType.thisKeyword);
    expectToken('as', TokenType.asKeyword);
    expectToken('default', TokenType.defaultKeyword);
    expectToken('let', TokenType.letKeyword);
    expectToken('null', TokenType.nullKeyword);
    expectToken('throw', TokenType.throwKeyword);
    expectToken('assert', TokenType.assertKeyword);
    expectToken('deferred', TokenType.deferredKeyword);
    expectToken('finally', TokenType.finallyKeyword);
    expectToken('operator', TokenType.operatorKeyword);
    expectToken('true', TokenType.trueKeyword);
    expectToken('do', TokenType.doKeyword);
    expectToken('for', TokenType.forKeyword);
    expectToken('part', TokenType.partKeyword);
    expectToken('part of', TokenType.partOfKeyword);
    expectToken('try', TokenType.tryKeyword);
    expectToken('dynamic', TokenType.dynamicKeyword);
    expectToken('get', TokenType.getKeyword);
    expectToken('rethrow', TokenType.rethrowKeyword);
    expectToken('typedef', TokenType.typedefKeyword);
    expectToken('await', TokenType.awaitKeyword);
    expectToken('else', TokenType.elseKeyword);
    expectToken('if', TokenType.ifKeyword);
    expectToken('return', TokenType.returnKeyword);
    expectToken('var', TokenType.varKeyword);
    expectToken('break', TokenType.breakKeyword);
    expectToken('enum', TokenType.enumKeyword);
    expectToken('implements', TokenType.implementsKeyword);
    expectToken('set', TokenType.setKeyword);
    expectToken('void', TokenType.voidKeyword);
    expectToken('case', TokenType.caseKeyword);
    expectToken('export', TokenType.exportKeyword);
    expectToken('import', TokenType.importKeyword);
    expectToken('static', TokenType.staticKeyword);
    expectToken('while', TokenType.whileKeyword);
    expectToken('catch', TokenType.catchKeyword);
    expectToken('external', TokenType.externalKeyword);
    expectToken('in', TokenType.inKeyword);
    expectToken('super', TokenType.superKeyword);
    expectToken('with', TokenType.withKeyword);
    expectToken('class', TokenType.classKeyword);
    expectToken('extends', TokenType.extendsKeyword);
    expectToken('is', TokenType.isKeyword);
    expectToken('switch', TokenType.switchKeyword);
    expectToken('yield', TokenType.yieldKeyword);
    expectToken('const', TokenType.constKeyword);
    expectToken('factory', TokenType.factoryKeyword);
    expectToken('library', TokenType.libraryKeyword);

    // Modifier keywords
    expectToken('sync', TokenType.syncKeyword);
    expectToken('async', TokenType.asyncKeyword);
    expectToken('sync*', TokenType.syncStarKeyword);
    expectToken('async*', TokenType.asyncStarKeyword);

    // Symbols
    expectToken('public', TokenType.identifier);
    expectToken('_private', TokenType.identifier);
    expectToken(r'$special', TokenType.identifier);
    expectToken(r'_$special', TokenType.identifier);
    expectToken(r'$_special', TokenType.identifier);
    expectToken(r'$1_special', TokenType.identifier);
    expectToken(r'_1$special', TokenType.identifier);

    // Comments
    expectToken('//c', TokenType.lineComment);
    expectToken('///c', TokenType.lineComment);
    expectToken('/*c\nc*/', TokenType.multilineComment);

    // Raw strings
    expectToken('r""', TokenType.rawString);
    expectToken("r''", TokenType.rawString);
    expectToken('r"x"', TokenType.rawString);
    expectToken("r'x'", TokenType.rawString);
    expectToken('r"""\n"""', TokenType.rawString);
    expectToken("r'''\n'''", TokenType.rawString);

    // Strings
    expectToken('""', TokenType.string);
    expectToken("''", TokenType.string);
    expectToken('"x"', TokenType.string);
    expectToken("'x'", TokenType.string);
    expectToken('"""\n"""', TokenType.string);
    expectToken("'''\n'''", TokenType.string);
    expectToken(r"'\$'", TokenType.string);

    // Punctuation
    expectToken(';', TokenType.semicolon);
    expectToken(':', TokenType.colon);
    expectToken('.', TokenType.period);
    expectToken(',', TokenType.comma);
    expectToken('(', TokenType.openParenthesis);
    expectToken(')', TokenType.closeParenthesis);
    expectToken('[', TokenType.openBracket);
    expectToken(']', TokenType.closeBracket);
    expectToken('{', TokenType.openCurly);
    expectToken('}', TokenType.closeCurly);
    expectToken('<', TokenType.openAngleBracket);
    expectToken('>', TokenType.closeAngleBracket);
    expectToken('*', TokenType.star);
  }

  @test
  line_and_column() {
    expectTokens('x\n y', [
      const Token(TokenType.identifier, 'x', 0),
      const Token(TokenType.lineBreak, '\n', 1),
      const Token(TokenType.whitespace, ' ', 2, line: 2, column: 0),
      const Token(TokenType.identifier, 'y', 3, line: 2, column: 1),
    ]);
  }

  @test
  string_interpolation() {
    expectTokens(r"'x$y z'", [
      const Token(TokenType.string, "'x", 0),
      const Token(TokenType.openStringInterpolation, r"$", 2),
      const Token(TokenType.identifier, "y", 3),
      const Token(TokenType.closeStringInterpolation, "", 4),
      const Token(TokenType.string, " z'", 4),
    ]);
    expectTokens(r"'x${y}z'", [
      const Token(TokenType.string, "'x", 0),
      const Token(TokenType.openStringInterpolation, r"${", 2),
      const Token(TokenType.identifier, "y", 4),
      const Token(TokenType.closeStringInterpolation, "}", 5),
      const Token(TokenType.string, "z'", 6),
    ]);
    expectTokens(r"'x$y $y z'", [
      const Token(TokenType.string, "'x", 0),
      const Token(TokenType.openStringInterpolation, r"$", 2),
      const Token(TokenType.identifier, "y", 3),
      const Token(TokenType.closeStringInterpolation, "", 4),
      const Token(TokenType.string, " ", 4),
      const Token(TokenType.openStringInterpolation, r"$", 5),
      const Token(TokenType.identifier, "y", 6),
      const Token(TokenType.closeStringInterpolation, "", 7),
      const Token(TokenType.string, " z'", 7),
    ]);
    expectTokens(r"'a${b}c${d}e'", [
      const Token(TokenType.string, "'a", 0),
      const Token(TokenType.openStringInterpolation, r"${", 2),
      const Token(TokenType.identifier, "b", 4),
      const Token(TokenType.closeStringInterpolation, "}", 5),
      const Token(TokenType.string, "c", 6),
      const Token(TokenType.openStringInterpolation, r"${", 7),
      const Token(TokenType.identifier, "d", 9),
      const Token(TokenType.closeStringInterpolation, "}", 10),
      const Token(TokenType.string, "e'", 11),
    ]);
  }
}
