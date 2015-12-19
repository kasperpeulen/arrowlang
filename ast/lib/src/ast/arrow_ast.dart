part of arrow.ast.ast;

class ArrowAst extends Node {
  const ArrowAst(NodeList<TopLevelNode> children) : super(children);

  const ArrowAst.empty() : super(
      const NodeList<TopLevelNode>(
          const [
            const ScriptHead(const NodeList.empty())
          ]
      )
  );

  /// [ArrowAst] ::=
  ///   [ScriptHead]
  ///   [TopLevelNode]*
  factory ArrowAst.parse(Parser parser) {
    final head = new ScriptHead.parse(parser);
    final topLevelNodes = TopLevelNode.parseMultiple(parser);
    return new ArrowAst(
        new NodeList<TopLevelNode>([head]) + topLevelNodes
    );
  }

  bool operator ==(other) {
    return other is ArrowAst
        && super == other;
  }
}
