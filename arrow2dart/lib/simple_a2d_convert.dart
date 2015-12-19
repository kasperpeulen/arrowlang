library arrow2dart.simple_a2d_convert;

import 'package:arrow_ast/arrow_ast.dart';

String arrowAstAsDart(ArrowAst ast) {
  return '${ast.children.map(_topLevelNode).join('\n')}';
}


String _topLevelNode(TopLevelNode node) {
  if (node is ScriptHead)
    return _scriptHead(node);
  throw new UnimplementedError('TODO: Top level nodes as Dart');
}

String _scriptHead(ScriptHead scriptHead) {
  return '${scriptHead.children.map((Node node) {
    if (node is LibraryDeclaration)
      return 'library ${node.name.name};';
  }).join('\n')}';
}
