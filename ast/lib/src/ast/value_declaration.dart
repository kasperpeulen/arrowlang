part of arrow.ast.ast;

class ValueDeclaration extends Node {
  final Token start;
  final Token end;
  final Identifier name;
  final TypeName type;
  final Expression assignment;

  const ValueDeclaration(
      Token mutabilityKeyword,
      Token breakToken,
      this.name,
      {
        this.type: const UndeclaredType(),
        this.assignment
      }
  )
      : start = mutabilityKeyword,
        end = breakToken,
        super.empty();

  factory ValueDeclaration.parse(Parser parser) {
    final start = parser.expectAnyOf([
      TokenType.letKeyword,
      TokenType.constKeyword,
      TokenType.varKeyword,
    ]).move();
    final name = parser.expect(TokenType.identifier).move();
    final type = new TypeName.parseDeclaration(parser);
    final Expression assignment = () {
      if (parser.next.isnt(TokenType.equals))
        return null;
      parser.move();
      return new Expression.parse(parser);
    }();
    final end = parser.expectBreak().move();
    return new ValueDeclaration(
        start, end, new Identifier(name.content),
        type: type, assignment: assignment
    );
  }

  bool get isVar => start?.type == TokenType.varKeyword ?? false;

  bool get isLet => start?.type == TokenType.letKeyword ?? true;

  bool get isConst => start?.type == TokenType.constKeyword ?? false;
}
