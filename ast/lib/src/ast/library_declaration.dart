part of arrow.ast.ast;

class LibraryDeclaration extends Node {
  final Identifier name;
  final Token start;
  final Token end;

  const LibraryDeclaration(Token libraryToken, Token breakToken, this.name)
      : start = libraryToken,
        end = breakToken,
        super(const NodeList.empty());

  factory LibraryDeclaration.parse(Parser parser) {
    final libraryToken = parser
        .expect(TokenType.libraryKeyword)
        .move();

    final id = parser
        .expect(TokenType.identifier)
        .move();

    final breakToken = parser
        .expectBreak()
        .move();

    return new LibraryDeclaration(
        libraryToken,
        breakToken,
        new Identifier(id.content)
    );
  }

  String toString() => '$runtimeType: library ${name.name} ($start -> $end)';

  bool operator ==(other) {
    return other is LibraryDeclaration
        && other.name == name
        && super == other;
  }
}
