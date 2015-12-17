part of arrow.ast.ast;

class ArrowAst extends Node {
  const ArrowAst(NodeList<TopLevelNode> children) : super(children);
  const ArrowAst.empty() : super.empty();

  /// [ArrowAst] ::=
  ///   [ScriptHead]
  ///   [TopLevelNode]*
  factory ArrowAst.parse(Parser parser) {
    return new ArrowAst(
        new NodeList<TopLevelNode>(
            [new ScriptHead.parse(parser)]
        ) + _parseTopLevelNodes(parser)
    );
  }

  static Iterable<TopLevelNode> _parseTopLevelNodes(Parser parser) sync* {
    while (parser.next.isnt(TokenType.eof))
      yield new TopLevelNode.parse(parser);
  }
}
