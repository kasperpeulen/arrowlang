part of arrow.ast.ast;

abstract class ValueDeclaration extends Node {
  final Identifier name;
  final TypeName type;

  const ValueDeclaration(
      this.name, this.type
  ) : super.empty();
}
