part of arrow.ast.ast;

class Identifier {
  final String name;

  const Identifier(this.name);

  bool operator ==(other) {
    return other is Identifier
        && other.name == name;
  }

  String toString() => '#$name';
}

class QualifiedIdentifier implements Identifier {
  final List<Identifier> parts;

  const QualifiedIdentifier(this.parts);

  String get name => parts.map((i) => i.name).join('.');

  factory QualifiedIdentifier.parse(Parser parser) {
    return new QualifiedIdentifier(
        new List.unmodifiable(
            _parseParts(parser)
        )
    );
  }

  static Iterable<Identifier> _parseParts(Parser parser) sync* {
    while (true) {
      final id = parser
          .expect(TokenType.identifier)
          .move();
      yield new Identifier(id.content);
      if (parser.next.isnt(TokenType.period))
        break;
      parser.move();
    }
  }

  bool operator ==(other) {
    return other is QualifiedIdentifier
        && _equalIterables(other.parts, parts);
  }
}

class NamespaceQualifiedIdentifier implements Identifier {
  final Identifier namespace;
  final QualifiedIdentifier identifier;

  const NamespaceQualifiedIdentifier(this.namespace, this.identifier);

  factory NamespaceQualifiedIdentifier.parse(Parser parser) {
    if (parser.next.isnt(TokenType.identifier)) return null;
    final namespace = parser.expect(TokenType.identifier).move();
    if (parser.next.isA(TokenType.colon)) {
      parser.expect(TokenType.colon).move();
      final id = new QualifiedIdentifier.parse(parser);
      return new NamespaceQualifiedIdentifier(new Identifier(namespace.content), id);
    }
    parser.moveBack();
    return new NamespaceQualifiedIdentifier(
        null,
        new QualifiedIdentifier.parse(parser)
    );
  }

  String get name => '${namespace == null
      ? ''
      : '${namespace.name}:'
  }${identifier.name}';

  bool operator ==(other) {
    return other is NamespaceQualifiedIdentifier
        && other.namespace == namespace
        && other.identifier == identifier;
  }
}
