part of arrow.ast.ast;

class ImportDeclaration extends Node {
  final Token start;
  final Token end;
  final NamespaceQualifiedIdentifier name;
  final String uri;
  final Identifier as;
  final List<TypeName> show;
  final List<TypeName> hide;

  const ImportDeclaration(
      Token importToken,
      Token breakToken, {
        this.name,
        this.uri,
        this.as,
        this.show: const [],
        this.hide: const []
      }
    ) : start = importToken,
        end = breakToken,
        super(const NodeList.empty());

  /// [ImportDeclaration] ::=
  ///   'import'
  ///   [Identifier]
  ///   ('as' [Identifier])?
  ///   (
  ///     showList? hideList
  ///     |
  ///     hideList? showList
  ///   )?
  ///
  /// showList ::=
  ///   'show'
  ///   ([Identifier] ',')*
  ///   [Identifier]
  ///
  /// hideList ::=
  ///   'hide'
  ///   ([Identifier] ',')*
  ///   [Identifier]
  factory ImportDeclaration.parse(Parser parser) {
    final importToken = parser
        .expect(TokenType.importKeyword)
        .move();

    final id = new NamespaceQualifiedIdentifier.parse(parser);
    final uri = _parseUri(parser);

    final Identifier as = () {
      if (parser.next.isnt(TokenType.asKeyword))
        return null;
      parser.move(); // as

      final id = parser
          .expect(TokenType.identifier)
          .move();

      return new Identifier(id.content);
    }();

    final showHideList = new _ShowHideList(parser);

    final breakToken = parser
        .expectBreak()
        .move();

    return new ImportDeclaration(
        importToken,
        breakToken,
        name: id,
        uri: uri,
        as: as,
        show: showHideList.show,
        hide: showHideList.hide
    );
  }

  String toString() {
    final asPart = as == null ? '' : ' as ${as.name}';
    final showPart = show.isEmpty ? '' : ' show ${show.map((t) => '$t').join(', ')}';
    final hidePart = hide.isEmpty ? '' : ' hide ${hide.map((t) => '$t').join(', ')}';
    return '$runtimeType: import ${name.name}$asPart$showPart$hidePart ($start -> $end)';
  }

  bool operator ==(other) {
    return other is ImportDeclaration
        && other.name == name
        && other.uri == uri
        && other.as == as
        && _equalIterables(other.show, show)
        && _equalIterables(other.hide, hide)
        && super == other;
  }
}

String _parseUri(Parser parser) {
  if (parser.next.isnt(TokenType.string)) return null;
  return parser.expect(TokenType.string).move().content;
}

class ExportDeclaration extends Node {
  final Token start;
  final Token end;
  final NamespaceQualifiedIdentifier name;
  final String uri;
  final List<TypeName> show;
  final List<TypeName> hide;

  const ExportDeclaration(
      Token importToken,
      Token breakToken, {
        this.name,
        this.uri,
        this.show: const [],
        this.hide: const []
      }
      ) : start = importToken,
          end = breakToken,
          super(const NodeList.empty());

  /// [ExportDeclaration] ::=
  ///   'export'
  ///   [Identifier]
  ///   (
  ///     showList? hideList
  ///     |
  ///     hideList? showList
  ///   )?
  ///
  /// showList ::=
  ///   'show'
  ///   ([Identifier] ',')*
  ///   [Identifier]
  ///
  /// hideList ::=
  ///   'hide'
  ///   ([Identifier] ',')*
  ///   [Identifier]
  factory ExportDeclaration.parse(Parser parser) {
    final exportToken = parser
        .expect(TokenType.exportKeyword)
        .move();

    final id = new NamespaceQualifiedIdentifier.parse(parser);
    final uri = _parseUri(parser);

    final showHideList = new _ShowHideList(parser);

    final breakToken = parser
        .expectBreak()
        .move();

    return new ExportDeclaration(
        exportToken,
        breakToken,
        name: id,
        uri: uri,
        show: showHideList.show,
        hide: showHideList.hide
    );
  }

  String toString() {
    final showPart = show.isEmpty ? '' : ' show ${show.map((t) => '$t').join(', ')}';
    final hidePart = hide.isEmpty ? '' : ' hide ${hide.map((t) => '$t').join(', ')}';
    return '$runtimeType: export ${name.name}$showPart$hidePart ($start -> $end)';
  }

  bool operator ==(other) {
    return other is ExportDeclaration
        && other.name == name
        && other.uri == uri
        && _equalIterables(other.show, show)
        && _equalIterables(other.hide, hide)
        && super == other;
  }
}


class _ShowHideList {
  List<TypeName> show;
  List<TypeName> hide;

  _ShowHideList._(this.show, this.hide);

  factory _ShowHideList(Parser parser) {
    if (parser.next.content == 'show') {
      final show = _parseShow(parser);
      final hide = _parseHide(parser);
      return new _ShowHideList._(show, hide);
    }
    else if (parser.next.content == 'hide') {
      final hide = _parseHide(parser);
      final show = _parseShow(parser);
      return new _ShowHideList._(show, hide);
    }
    return new _ShowHideList._([], []);
  }

  static List<TypeName> _parseShow(Parser parser) {
    if (parser.next.content == 'show') {
      parser.move(); // show
      return new List.unmodifiable(_parseTypeList(parser));
    }
    return [];
  }

  static List<TypeName> _parseHide(Parser parser) {
    if (parser.next.content == 'hide') {
      parser.move(); // hide
      return new List.unmodifiable(_parseTypeList(parser));
    }
    return [];
  }

  static Iterable<TypeName> _parseTypeList(Parser parser) sync* {
    while (true) {
      yield new TypeName.parse(parser);
      if (parser.next.isnt(TokenType.comma)) break;
      parser.move(); // ,
    }
  }
}
