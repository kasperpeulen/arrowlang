part of arrow.ast.ast;

abstract class TopLevelNode implements Node {
  /// [TopLevelNode] ::=
  ///   [ScriptHead]?
  ///   (
  ///     []
  ///   )
  factory TopLevelNode.parse(Parser parser) {
    throw new UnimplementedError('TODO: Top level nodes');
  }
}
