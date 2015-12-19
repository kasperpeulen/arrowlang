library arrow.ast.tokens;

enum TokenType {
  eof,
  whitespace,

  lineBreak,

  lineComment,
  multilineComment,

  identifier,

  string,
  rawString,
  openStringInterpolation,
  closeStringInterpolation,

  // Keywords
  abstractKeyword,
  continueKeyword,
  falseKeyword,
  newKeyword,
  thisKeyword,
  asKeyword,
  defaultKeyword,
  letKeyword,
  nullKeyword,
  throwKeyword,
  assertKeyword,
  deferredKeyword,
  finallyKeyword,
  operatorKeyword,
  trueKeyword,
  doKeyword,
  forKeyword,
  partKeyword,
  partOfKeyword,
  tryKeyword,
  dynamicKeyword,
  getKeyword,
  rethrowKeyword,
  typedefKeyword,
  awaitKeyword,
  elseKeyword,
  ifKeyword,
  returnKeyword,
  varKeyword,
  breakKeyword,
  enumKeyword,
  implementsKeyword,
  setKeyword,
  voidKeyword,
  caseKeyword,
  exportKeyword,
  importKeyword,
  staticKeyword,
  whileKeyword,
  catchKeyword,
  externalKeyword,
  inKeyword,
  superKeyword,
  withKeyword,
  classKeyword,
  extendsKeyword,
  isKeyword,
  switchKeyword,
  yieldKeyword,
  constKeyword,
  factoryKeyword,
  libraryKeyword,

  syncKeyword,
  asyncKeyword,
  syncStarKeyword,
  asyncStarKeyword,

  // Punctuation
  semicolon,
  colon,
  period,
  comma,
  openParenthesis,
  closeParenthesis,
  openBracket,
  closeBracket,
  openCurly,
  closeCurly,
  openAngleBracket,
  closeAngleBracket,
  star,
}

class Token {
  final TokenType type;
  final String content;
  final int offset;
  final int line;
  final int _column;

  int get column => _column ?? offset;

  const Token(this.type, this.content, this.offset, {this.line: 1, int column})
    : _column = column;

  int get start => offset;

  int get end => offset + (content?.length ?? 0);

  String get position => '$line:$column';

  String toString() => '$_typeName("${content?.replaceAll('\n', r'\n') ?? ''}", $position [$offset])';

  String get _typeName => type.toString().substring('$TokenType'.length + 1);

  bool isA(TokenType type) => type == this.type;

  bool isnt(TokenType type) => !isA(type);

  bool operator ==(other) {
    if (other is MatchAllToken) return true;
    return other is Token
        && other.offset == offset
        && other.content == content
        && other.line == line
        && other.column == column
        && other.start == start
        && other.end == end
        && other.type == type;
  }

  bool isAnyOf(Iterable<TokenType> types) {
    for (final type in types)
      if (isA(type)) return true;
    return false;
  }

  bool isntAnyOf(Iterable<TokenType> types) {
    return !isAnyOf(types);
  }
}

class MatchAllToken implements Token {
  const MatchAllToken();

  int get _column => null;
  String get _typeName => null;
  int get column => null;
  String get content => null;
  int get end => null;
  bool isA(TokenType type) => true;

  bool isAnyOf(Iterable<TokenType> types) => true;

  bool isnt(TokenType type) => false;

  bool isntAnyOf(Iterable<TokenType> types) => false;

  int get line => null;

  int get offset => null;

  String get position => null;

  int get start => null;

  TokenType get type => null;

  bool operator ==(other) => true;
}
