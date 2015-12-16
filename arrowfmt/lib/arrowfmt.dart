library arrowfmt;

import 'package:arrow_ast/arrow_ast.dart';

String formatAst(ArrowAst ast) {
  throw new UnimplementedError('TODO: Format Arrow AST to String');
}

String format(String source) {
  return formatAst(parse(source));
}
