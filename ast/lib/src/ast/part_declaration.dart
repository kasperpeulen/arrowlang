part of arrow.ast.ast;

class PartDeclaration extends Node {
  final Token start;
  final Token end;
  final Identifier name;

  const PartDeclaration(
      Token partToken,
      Token breakToken,
      this.name
  ) : start = partToken,
      end = breakToken,
      super(const NodeList.empty());

  /// [PartDeclaration] ::=
  ///   'part'
  ///   [Identifier]
  factory PartDeclaration.parse(Parser parser) {
    final partToken = parser
        .expect(TokenType.partKeyword)
        .move();
    final id = parser
        .expect(TokenType.identifier)
        .move();
    final breakToken = parser
        .expectBreak()
        .move();
    return new PartDeclaration(
        partToken,
        breakToken,
        new Identifier(id.content)
    );
  }

  bool operator ==(other) {
    return other is PartDeclaration
        && other.name == name
        && super == other;
  }

  String toString() => '$runtimeType: part ${name.name}';
}
