part of arrow.ast.ast;

abstract class TopLevelNode implements Node {
  /// [TopLevelNode] ::=
  factory TopLevelNode.parse(Parser parser) {
    throw new UnimplementedError('TODO: Top level nodes');
  }

  static Iterable<TopLevelNode> parseMultiple(Parser parser) sync* {
    while (parser.next.isnt(TokenType.eof))
      yield new TopLevelNode.parse(parser);
  }
}

class TopLevelFunction extends FunctionDeclaration implements TopLevelNode {
  const TopLevelFunction(
      Token start,
      Token end,
      Identifier name,
      TypeName returnType,
      List<Argument> arguments,
      NodeList<BlockLevelNode> block
  ) : super(
      start, end, name, returnType, arguments, block
  );
}

abstract class BlockLevelNode implements Node {}
