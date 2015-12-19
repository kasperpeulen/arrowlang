part of arrow.ast.ast;

abstract class TopLevelNode implements Node {
  /// [TopLevelNode] ::=
  ///   [TopLevelFunction]
  factory TopLevelNode.parse(Parser parser) {
    if (parser.next.isA(TokenType.identifier))
      return new TopLevelFunction.parse(parser);
    throw new UnimplementedError('TODO: Top level nodes');
  }

  static Iterable<TopLevelNode> parseMultiple(Parser parser) sync* {
    while (parser.next.isnt(TokenType.eof)) {
      if (parser.next.isA(TokenType.lineBreak)) {
        parser.move();
        continue;
      }
      yield new TopLevelNode.parse(parser);
    }
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

  factory TopLevelFunction.parse(Parser parser) {
    final func = new FunctionDeclaration.parse(parser);
    return new TopLevelFunction(
      func.start,
      func.end,
      func.name,
      func.returnType,
      func.arguments,
      func.children
    );
  }
}

abstract class BlockLevelNode implements Node {}
