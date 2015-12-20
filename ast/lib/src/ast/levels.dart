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

abstract class BlockLevelNode implements Node {
  /// [BlockLevelNode] ::=
  ///   [BlockLevelValueDeclaration]
  factory BlockLevelNode.parse(Parser parser) {
    if (parser.next.isAnyOf([
      TokenType.letKeyword,
      TokenType.varKeyword,
      TokenType.constKeyword
    ])) return new BlockLevelValueDeclaration.parse(parser);
    throw new UnimplementedError('TODO: BlockLevelNode');
  }

  /// block ::=
  ///  '{'
  ///  [BlockLevelNode]*
  ///  '}'
  static Iterable<BlockLevelNode> parseMulti(Parser parser) sync* {
    parser.expect(TokenType.openCurly).move();
    while (parser.next.isnt(TokenType.closeCurly))
      yield new BlockLevelNode.parse(parser);
    parser.expect(TokenType.closeCurly).move();
  }
}

class BlockLevelValueDeclaration extends ValueDeclaration implements BlockLevelNode {
  const BlockLevelValueDeclaration(
      Token mutabilityKeyword,
      Token breakToken,
      Identifier name, {
        TypeName type: const UndeclaredType(),
        Expression assignment
      }
  ) : super(
      mutabilityKeyword,
      breakToken,
      name,
      type: type,
      assignment: assignment
  );

  factory BlockLevelValueDeclaration.parse(Parser parser) {
    final valueDeclaration = new ValueDeclaration.parse(parser);
    return new BlockLevelValueDeclaration(
        valueDeclaration.start,
        valueDeclaration.end,
        valueDeclaration.name,
        type: valueDeclaration.type,
        assignment: valueDeclaration.assignment
    );
  }

  bool operator ==(other) {
    return other is BlockLevelValueDeclaration
        && super == other;
  }
}

abstract class ExpressionLevelNode {}
