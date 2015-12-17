part of arrow.ast.ast;

abstract class Node {
  final NodeList<Node> children;

  const Node(this.children);
  const Node.empty() : children = const NodeList<Node>.empty();
}