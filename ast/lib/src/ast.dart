library arrow.ast.ast;

import 'parser.dart';
import 'tokens.dart';
import 'dart:collection';

part 'ast/arrow_ast.dart';
part 'ast/node.dart';
part 'ast/levels.dart';
part 'ast/node_list.dart';
part 'ast/script_head.dart';
part 'ast/library_declaration.dart';
part 'ast/identifier.dart';
part 'ast/part_of_declaration.dart';
part 'ast/part_declaration.dart';
part 'ast/import_export_declaration.dart';
part 'ast/type_name.dart';
part 'ast/function_declaration.dart';
part 'ast/argument.dart';
part 'ast/value_declaration.dart';
part 'ast/expression.dart';

bool _equalIterables(Iterable iterableA, Iterable iterableB) {
  if (iterableA.length != iterableB.length) return false;
  final a = iterableA.iterator;
  final b = iterableB.iterator;
  while (a.moveNext()) {
    if (!b.moveNext()) return false;
    if (b.current != a.current) {
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!: \n\n${a.current}\n != \n${b.current}\n\n');
      return false;
    }
  }
  return true;
}
