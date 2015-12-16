library arrow.ast.parser;

import 'ast.dart';
import 'tokens.dart';

class Parser {
  final Iterable<Token> source;

  Parser(this.source);

  ArrowAst parse() {
    throw new UnimplementedError("TODO: Parser");
  }
}
