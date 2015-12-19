part of arrow.ast.ast;

abstract class FunctionDeclaration extends Node {
  final Token start;
  final Token end;
  final Identifier name;
  final TypeName returnType;
  final List<Argument> arguments;

  const FunctionDeclaration(
      this.start,
      this.end,
      this.name,
      this.returnType,
      this.arguments,
      NodeList<BlockLevelNode> block
  ) : super(block);

  factory FunctionDeclaration.parse(Parser parser) {
    throw new UnimplementedError('TODO: FunctionDeclaration');
  }
}
