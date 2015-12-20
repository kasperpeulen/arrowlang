part of arrow.ast.ast;

class Expression {
  final List<ExpressionLevelNode> parts;

  const Expression(this.parts);

  factory Expression.parse(Parser parser) {
    return new Expression(
        new List.unmodifiable(
            _parseParts(parser)
        )
    );
  }

  static Iterable<ExpressionLevelNode> _parseParts(Parser parser) sync* {
    while (true) {
      throw new UnimplementedError('TODO: ExpressionLevelNode');
      break;
    }
  }

  bool operator ==(other) {
    return other is Expression;
  }
}

class NumberLiteral implements ExpressionLevelNode {
  final num value;

  const NumberLiteral(this.value);

  bool operator ==(other) {
    return other is NumberLiteral
        && other.value == value;
  }
}
