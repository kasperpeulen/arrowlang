part of arrow.ast.ast;

class Argument extends ValueDeclaration {
  const Argument(
      Identifier name,
      TypeName type
  ) : super(null, null, name, type: type);

  factory Argument.parse(Parser parser) {
    final name = parser
      .expect(TokenType.identifier)
      .move();

    final TypeName type = new TypeName.parseDeclaration(parser);

    return new Argument(
      new Identifier(name.content),
      type
    );
  }

  /// argumentList ::=
  ///   '('
  ///     ([Argument] ',')*
  ///     [Argument]?
  ///     (
  ///       (
  ///         ','
  ///         '['
  ///         ([PositionalArgument] ',')*
  ///         [PositionalArgument]?
  ///         ']'
  ///       )
  ///       |
  ///       (
  ///         ','
  ///         '{'
  ///         ([NamedArgument] ',')*
  ///         [NamedArgument]?
  ///         '}'
  ///       )
  ///     )?
  ///   ')'
  static Iterable<Argument> parseList(Parser parser) sync* {
    parser.expect(TokenType.openParenthesis).move();

    while(true) {
      if (parser.next.isA(TokenType.closeParenthesis))
        break;

      if (parser.next.isA(TokenType.openBracket)) {
        yield* OptionalArgument.parseList(parser);
        break;
      }
      if (parser.next.isA(TokenType.openCurly)) {
        yield* NamedArgument.parseList(parser);
        break;
      }

      yield new Argument.parse(parser);

      if (parser.next.isA(TokenType.closeParenthesis))
        break;

      parser.expect(TokenType.comma).move();
    }

    parser.expect(TokenType.closeParenthesis).move();
  }
}

class OptionalArgument extends Argument {
  const OptionalArgument(
      Identifier name,
      TypeName type
  ) : super(name, type);

  /// [OptionalArgument] ::=
  ///   [Identifier]
  ///   (
  ///     ':'
  ///     [TypeName]
  ///   )?
  ///   (
  ///     '='
  ///     [Expression]
  ///   )?
  factory OptionalArgument.parse(Parser parser) {
    final name = parser
      .expect(TokenType.identifier)
      .move();

    final TypeName type = new TypeName.parseDeclaration(parser);

    return new OptionalArgument(
      new Identifier(name.content),
      type
    );
  }

  static Iterable<OptionalArgument> parseList(Parser parser) sync* {
    parser.expect(TokenType.openBracket).move();

    while(true) {
      yield new OptionalArgument.parse(parser);

      if (parser.next.isA(TokenType.closeBracket))
        break;

      parser.expect(TokenType.comma).move();
    }

    parser.expect(TokenType.closeBracket).move();
  }
}

class NamedArgument extends Argument {
  const NamedArgument(
      Identifier name,
      TypeName type
  ) : super(name, type);

  /// [NamedArgument] ::=
  ///   [Identifier]
  ///   (
  ///     ':'
  ///     [TypeName]
  ///   )?
  ///   (
  ///     '='
  ///     [Expression]
  ///   )?
  factory NamedArgument.parse(Parser parser) {
    final name = parser
      .expect(TokenType.identifier)
      .move();

    final TypeName type = new TypeName.parseDeclaration(parser);

    return new NamedArgument(
      new Identifier(name.content),
      type
    );
  }

  static Iterable<NamedArgument> parseList(Parser parser) sync* {
    parser.expect(TokenType.openCurly).move();

    while(true) {
      yield new NamedArgument.parse(parser);

      if (parser.next.isA(TokenType.closeCurly))
        break;

      parser.expect(TokenType.comma).move();
    }

    parser.expect(TokenType.closeCurly).move();
  }
}
