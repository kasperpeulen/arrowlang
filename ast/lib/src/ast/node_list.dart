part of arrow.ast.ast;

class NodeList<E extends Node> extends IterableBase<E> {
  final Iterable<E> _source;

  const NodeList(this._source);

  const NodeList.empty() : _source = const [];

  Iterator<E> get iterator => _source.iterator;

  NodeList<E> operator +(other) {
    if (other is NodeList<E> || other is Iterable<E>)
      return new NodeList<E>(
          toList()..addAll(other)
      );
    if (other is E)
      return new NodeList<E>(
          toList()..add(other)
      );
    throw new ParserError(
        '${other.runtimeType} cannot be added to a NodeList<$E>'
    );
  }
}
