part of arrow.ast.ast;

abstract class Node {
  final NodeList<Node> children;

  const Node(this.children);

  const Node.empty() : children = const NodeList<Node>.empty();

  Token get start => children.length > 1 ? children.first.start : null;

  Token get end => children.length > 1 ? children.last.end : null;

  bool operator ==(other) {
    return other is Node
        && other.start == start
        && other.end == end
        && other.children == children;
  }

  String toString() => '$runtimeType$_children';

  String get _children {
    if (children.length == 0) return '';
    final childrenString = children.map((n) => n.toString()).join('\n');
    return ':\n${childrenString.split('\n').map((s) => '  $s').join('\n')}';
  }
}