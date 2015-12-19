part of arrow.ast.ast;

class TypeName {
  final Identifier id;
  final bool async;
  final bool multi;
  final List<TypeName> arguments;

  const TypeName(
      Identifier id, {
        bool async: false,
        bool multi: false,
        List<TypeName> arguments: const []
      }
  ) : id = id,
      async = async,
      multi = multi,
      arguments = arguments;

  factory TypeName.parseReturnType(Parser parser) {
    if (parser.next.isnt(TokenType.colon))
      return const UndeclaredType();
    parser.move();
    final TokenType modifier = () {
      switch (parser.next.type) {
        case TokenType.syncKeyword:
        case TokenType.asyncKeyword:
        case TokenType.syncStarKeyword:
        case TokenType.asyncStarKeyword:
          return parser.move().type;
        default:
          return null;
      }
    }();
    switch (modifier) {
      case TokenType.asyncKeyword:
        return _parseTypePart(parser, async: true);
      case TokenType.syncStarKeyword:
        return _parseTypePart(parser, multi: true);
      case TokenType.asyncStarKeyword:
        return _parseTypePart(parser, multi: true, async: true);
      default:
        return _parseTypePart(parser);
    }
  }

  factory TypeName.parseDeclaration(Parser parser) {
    if (parser.next.isnt(TokenType.colon))
      return const UndeclaredType();
    parser.move();
    return _parseTypePart(parser);
  }

  factory TypeName.parse(Parser parser) {
    return _parseTypePart(parser);
  }

  static TypeName _parseTypePart(Parser parser, {bool async: false, bool multi: false}) {
    final type = parser
        .expect(TokenType.identifier)
        .move();
    final arguments = new List.unmodifiable(_parseTypeArgument(parser));
    return new TypeName(
        new Identifier(type.content),
        multi: multi,
        async: async,
        arguments: arguments
    );
  }

  static Iterable<TypeName> _parseTypeArgument(Parser parser) sync* {
    if (parser.next.isA(TokenType.openAngleBracket)) {
      parser.move();
      while (true) {
        yield new TypeName.parse(parser);
        if (parser.next.isnt(TokenType.comma))
          break;
        parser.move();
      }
      parser.expect(TokenType.closeAngleBracket).move();
    }
  }

  bool operator ==(other) {
    return other is TypeName
        && other.id == id
        && other.async == async
        && other.multi == multi
        && _equalIterables(arguments, arguments);
  }

  String toString() {
    final asyncPart = async ? 'async' : 'sync';
    final multiPart = multi ? '*' : '';
    final argumentsPart = arguments.isEmpty ? '' : '<${arguments.join(', ')}>';
    return '$runtimeType($asyncPart$multiPart ${id.name}$argumentsPart)';
  }
}

class UndeclaredType extends TypeName {
  const UndeclaredType() : super(null);

  bool operator ==(other) {
    return other is UndeclaredType;
  }
}
