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

  Token get next => source[_cursor + 1];

  Token get current => _cursor >= 0 ? source[_cursor] : null;
}

class ParserError extends Error {
  final String message;

  ParserError([this.message]);

  String toString() {
    if (message == null) return 'ParserException';
    return 'ParserException: $message';
  }
}