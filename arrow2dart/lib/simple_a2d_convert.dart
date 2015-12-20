library arrow2dart.simple_a2d_convert;

import 'package:arrow_ast/arrow_ast.dart';

String arrowAstAsDart(ArrowAst ast) {
  return _convertNode(ast);
}

String _convertNode(Node node) {
  if (node is LibraryDeclaration) return 'library ${node.name.name};';
  if (node is ImportDeclaration) return _convertImportExport('import', node, node.as);
  if (node is ExportDeclaration) return _convertImportExport('export', node);
  if (node is FunctionDeclaration) return _convertFunction(node);
  return node.children.map(_convertNode).join();
}

String _convertImportExport(String keyword, node, [Identifier as]) {
  final asPart = as == null ? '' : ' as ${as.name}';
  final showPart = node.show.isEmpty ? '' : ' show ${node.show.map(_convertTypeName).join(', ')}';
  final hidePart = node.hide.isEmpty ? '' : ' hide ${node.hide.map(_convertTypeName).join(', ')}';
  return "$keyword ${_convertImportExportUri(node.name, node.uri)}$asPart$showPart$hidePart;";
}

String _convertImportExportUri(NamespaceQualifiedIdentifier name, String uri) {
  if (name == null) return uri;
  final namespace = name.namespace?.name;
  final parts = name.identifier.parts.map((i) => i.name);
  if (namespace == 'dart')
    return "'dart:${parts.join('.')}'";
  if (name.namespace == null) {
    final path = name.identifier.parts.map((i) => i.name).join('/');
    return "'$path.dart'";
  }
  final package = name.namespace.name;
  if (name.identifier.parts.isEmpty)
    return "'package:$package/$package.dart'";
  final path = name.identifier.parts.map((i) => i.name).join('/');
  return "'package:$package/$path.dart'";
}

String _convertArgument(Argument argument) {
  final typePart = argument.type is UndeclaredType ? '' : ' ${_convertTypeName(argument.type)}';
  return 'final$typePart ${argument.name.name}';
}

String _convertFunction(FunctionDeclaration function) {
  final returnType = _convertTypeName(function.returnType);
  final modifier = () {
    if (function.returnType.multi && function.returnType.async)
      return ' async*';
    if (function.returnType.multi)
      return ' sync*';
    if (function.returnType.async)
      return ' async';
    return '';
  }();
  final arguments = () {
    final normal = function.arguments
        .where((a) => a is! OptionalArgument && a is! NamedArgument);
    final optional = function.arguments
        .where((a) => a is OptionalArgument);
    final named = function.arguments
        .where((a) => a is NamedArgument);
    final out = [];
    if (normal.isNotEmpty) out.add(normal.map(_convertArgument).join(', '));
    if (optional.isNotEmpty) out.add('[${optional.map(_convertArgument).join(', ')}]');
    else if (named.isNotEmpty) out.add('{${named.map(_convertArgument).join(', ')}}');
    return out.join(', ');
  }();
  return '$returnType ${function.name.name}($arguments)$modifier {}';
}

String _convertTypeName(TypeName type) {
  final name = () {
    final name = type is UndeclaredType ? '' : type.id.name;
    if (name == 'Int') return 'int';
    if (name == 'Num') return 'num';
    if (name == 'Bool') return 'bool';
    if (name == 'Null') return 'void';
    if (type.arguments.isEmpty)
      return name;
    return '$name<${type.arguments.map(_convertTypeName).join(', ')}>';
  }();
  final typePart = type is UndeclaredType || name == 'void' ? '' : '<$name>';
  if (type.async && type.multi)
    return 'Stream$typePart';
  if (type.async)
    return 'Future$typePart';
  if (type.multi)
    return 'Iterable$typePart';
  return type is UndeclaredType ? '' : name;
}
