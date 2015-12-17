part of arrow.ast.ast;

class ImportDeclaration extends Node {
  const ImportDeclaration() : super(const NodeList.empty());
  factory ImportDeclaration.parse(Parser parser) {
    throw new UnimplementedError('TODO: ImportDeclaration');
  }
}
