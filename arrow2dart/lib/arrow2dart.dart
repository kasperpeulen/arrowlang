library arrow2dart;

import 'package:arrow_ast/arrow_ast.dart' as arrow;
import 'package:arrow_ast/src/tokens.dart' as arrow show Token, TokenType;
import 'package:analyzer/analyzer.dart' as dart;
import 'package:analyzer/src/generated/scanner.dart' as dart show Token, TokenType;
import 'package:arrowfmt/arrowfmt.dart';
import 'package:dart_style/dart_style.dart' as dart_style;

import 'simple_a2d_convert.dart' as simple_a2d;

final dart_style.DartFormatter _formatter = new dart_style.DartFormatter();

String arrow2dart(String source) {
  final arrowAst = arrow.parse(source);
  final dartAst = _arrow2dart(arrowAst);
  return '$dartAst';
}

String dart2arrow(String source) {
  final dartAst = dart.parseCompilationUnit(source);
  final arrowAst = _dart2arrow(dartAst);
  return formatAst(arrowAst);
}

dart.CompilationUnit _arrow2dart(arrow.ArrowAst ast) {
  // This it the bad way to do it. The goal is to convert
  // the actual Arrow AST to a analyzer CompilationUnit.
  return dart.parseCompilationUnit(simple_a2d.arrowAstAsDart(ast));
}

arrow.ArrowAst _dart2arrow(dart.CompilationUnit ast) {
  throw new UnimplementedError('TODO: Convert Dart AST to Arrow');
  final source = '';
  return arrow.parse(source);
}
