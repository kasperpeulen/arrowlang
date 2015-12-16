library arrow.ast.tokens;

enum TokenType {
  eof,
  whitespace,
  lineBreak,
  lineComment,
  multilineComment,
  string,
}

class Token {
  final TokenType type;
  final String content;
  final int offset;

  const Token(this.type, this.content, this.offset);

  int get start => offset;

  int get end => offset + (content?.length ?? 0);

  String toString() => 'Token($type, "$content", $offset)';

  bool operator ==(other) {
    return other is Token
        && other.offset == offset
        && other.content == content
        && other.type == type;
  }
}
