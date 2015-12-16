library arrow.ast;

import 'src/tokenizer.dart';
import 'src/parser.dart';
import 'src/ast.dart';

export 'src/ast.dart';

ArrowAst parse(String source) {
  final tokens = new Tokenizer(source).tokenize();
  return new Parser(tokens).parse();
}
