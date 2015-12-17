part of arrow.ast.ast;

class LibraryDeclaration extends Node {
  final Identifier name;

  const LibraryDeclaration(this.name) : super(const NodeList.empty());
  factory LibraryDeclaration.parse(Parser parser) {
    throw new UnimplementedError('TODO: LibraryDeclaration');
  }
}
