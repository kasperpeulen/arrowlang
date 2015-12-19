part of arrow.ast.ast;

class Argument extends ValueDeclaration {
  const Argument(
      Identifier name,
      TypeName type
  ) : super(name, type);
}

class OptionalArgument extends Argument {
  const OptionalArgument(
      Identifier name,
      TypeName type
  ) : super(name, type);
}

class NamedArgument extends Argument {
  const NamedArgument(
      Identifier name,
      TypeName type
  ) : super(name, type);
}
