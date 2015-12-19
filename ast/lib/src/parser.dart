library arrow.ast.parser;

import 'ast.dart';
import 'tokens.dart';

class Parser {
  final List<Token> source;
  int _cursor = -1;

  Parser._(this.source);

  factory Parser(Iterable<Token> source) {
    return new Parser._(
        new List.unmodifiable(
            source.where((t) => t.isnt(TokenType.whitespace))
        )
    );
  }

  ArrowAst parse() {
    return new ArrowAst.parse(this);
  }

  Token get next => current?.isnt(TokenType.eof) ?? true ? source[_cursor + 1] : current;

  Token get current => _cursor >= 0 ? source[_cursor] : null;

  Parser expect(TokenType token, [String expected]) {
    return expectAnyOf([token], expected);
  }

  Parser expectAnyOf(Iterable<TokenType> tokens, [String expected]) {
    if (next.isntAnyOf(tokens))
      throw new ParserError('Unexpected ${next.type}, expected ${expected ?? tokens.join(', or')} at ${next.position}');
    return this;
  }

  Parser expectBreak() {
    return expectAnyOf([TokenType.lineBreak, TokenType.semicolon, TokenType.eof], 'line break or semicolon');
  }

  Token move() {
    _cursor++;
    return current;
  }
}

class ParserError extends Error {
  final String message;

  ParserError([this.message]);

  String toString() {
    if (message == null) return 'ParserException';
    return 'ParserException: $message';
  }
}