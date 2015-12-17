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
  asyncKeyword,
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
}

class Token {
  final TokenType type;
  final String content;
  final int offset;

  const Token(this.type, this.content, this.offset);

  int get start => offset;

  int get end => offset + (content?.length ?? 0);

  String toString() => 'Token($type, "$content", $offset)';

  bool isA(TokenType type) => type == this.type;

  bool isnt(TokenType type) => !isA(type);

  bool operator ==(other) {
    return other is Token
        && other.offset == offset
        && other.content == content
        && other.type == type;
  }

  bool isAnyOf(Iterable<TokenType> types) {
    for (final type in types)
      if (isA(type)) return true;
    return false;
  }
}
