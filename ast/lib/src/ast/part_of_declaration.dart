part of arrow.ast.ast;

class PartOfDeclaration extends Node {
  final Token start;
  final Token end;
  final Identifier name;

  const PartOfDeclaration(
      Token partOfToken,
      Token breakToken,
      this.name
      ) : start = partOfToken,
        end = breakToken,
        super(const NodeList.empty());

  /// [PartOfDeclaration] ::=
  ///   'part of'
  ///   [Identifier]
  factory PartOfDeclaration.parse(Parser parser) {
    final partOfToken = parser
        .expect(TokenType.partOfKeyword)
        .move();
    final id = parser
        .expect(TokenType.identifier)
        .move();
    final breakToken = parser
        .expectBreak()
        .move();
    return new PartOfDeclaration(
        partOfToken,
        breakToken,
        new Identifier(id.content)
    );
  }

  bool operator ==(other) {
    return other is PartOfDeclaration
        && other.name == name
        && super == other;
  }

  String toString() => '$runtimeType: part of ${name.name}';
}
