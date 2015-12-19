part of arrow.ast.ast;

class Identifier {
  final String name;

  const Identifier(this.name);

  bool operator ==(other) {
    return other is Identifier
        && other.name == name;
  }
}
