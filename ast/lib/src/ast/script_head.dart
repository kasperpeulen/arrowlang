part of arrow.ast.ast;

class ScriptHead extends Node implements TopLevelNode {
  const ScriptHead(NodeList<Node> children) : super(children);
  const ScriptHead.empty() : super.empty();

  /// [ScriptHead] ::=
  ///   (
  ///     [LibraryDeclaration]
  ///     |
  ///     [PartOfDeclaration]
  ///   )?
  ///   (
  ///     [ImportDeclaration]
  ///     |
  ///     [ExportDeclaration]
  ///   )*
  ///   [PartDeclaration]*
  factory ScriptHead.parse(Parser parser) {
    return new ScriptHead(new NodeList<Node>(
        new List.unmodifiable(_parseScriptHead(parser))
    ));
  }

  static Iterable<Node> _parseScriptHead(Parser parser) sync* {
    switch (parser.next.type) {
      case TokenType.libraryKeyword:
        yield new LibraryDeclaration.parse(parser);
        break;
      case TokenType.partOfKeyword:
        yield new PartOfDeclaration.parse(parser);
        break;
      default:
        break;
    }
    switch (parser.next.type) {
      case TokenType.partKeyword:
      case TokenType.importKeyword:
      case TokenType.exportKeyword:
        yield* _parseHeadMembers(parser);
        break;
      default:
        break;
    }
  }

  static Iterable<Node> _parseHeadMembers(Parser parser) sync* {
    while (parser.next.isAnyOf([
      TokenType.partKeyword,
      TokenType.importKeyword,
      TokenType.exportKeyword,
    ])) {
      if (parser.next.isA(TokenType.partKeyword))
        yield new PartDeclaration.parse(parser);
      else if (parser.next.isA(TokenType.importKeyword))
        yield new ImportDeclaration.parse(parser);
      else if (parser.next.isA(TokenType.exportKeyword))
        yield new ExportDeclaration.parse(parser);
    }
  }
}