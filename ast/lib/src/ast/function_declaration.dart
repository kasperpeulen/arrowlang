part of arrow.ast.ast;

class FunctionDeclaration extends Node {
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

  /// [FunctionDeclaration] ::=
  ///   [Identifier]
  ///   argumentList
  ///   (':' [TypeName])?
  ///   block
  ///
  /// argumentList ::=
  ///   '('
  ///   ([Argument] ',')*
  ///   [Argument]?
  ///   ')'
  ///
  /// modifier ::=
  ///   ('sync'|'async'|'sync*'|'async*')
  factory FunctionDeclaration.parse(Parser parser) {
    final name = parser
      .expect(TokenType.identifier)
      .move();

    final arguments = new List.unmodifiable(Argument.parseList(parser));

    final type = new TypeName.parseReturnType(parser);

    final block = new NodeList<BlockLevelNode>(
        new List<BlockLevelNode>.unmodifiable(
            BlockLevelNode.parseMulti(parser)
        )
    );
    final end = parser.current;

    return new FunctionDeclaration(
      name,
      end,
      new Identifier(name.content),
      type,
      arguments,
      block
    );
  }

  bool operator ==(other) {
    return other is FunctionDeclaration
        && other.name == name
        && other.returnType == returnType
        && super == other;
  }

  String toString() => '$runtimeType: ${name.name}(): $returnType';
}
