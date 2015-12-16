library arrow2dart;

import 'package:arrow_ast/arrow_ast.dart' as arrow;
import 'package:analyzer/analyzer.dart' as dart;
import 'package:arrowfmt/arrowfmt.dart';
import 'package:dart_style/dart_style.dart' as dart_style;

final dart_style.DartFormatter _formatter = new dart_style.DartFormatter();

String arrow2dart(String source) {
  final arrowAst = arrow.parse(source);
  final dartAst = _arrow2dart(arrowAst);
  return _formatter.format('$dartAst');
}

String dart2arrow(String source) {
  final dartAst = dart.parseCompilationUnit(source);
  final arrowAst = _dart2arrow(dartAst);
  return formatAst(arrowAst);
}

dart.CompilationUnit _arrow2dart(arrow.ArrowAst ast) {
  throw new UnimplementedError('TODO: Convert Arrow AST to Dart');
  final source = _formatter.format('');
  return dart.parseCompilationUnit(source);
}

arrow.ArrowAst _dart2arrow(dart.CompilationUnit ast) {
  throw new UnimplementedError('TODO: Convert Dart AST to Arrow');
  final source = '';
  return arrow.parse(source);
}
