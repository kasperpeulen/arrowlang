library arrow.ast.tokenizer;

import 'tokens.dart';

class Tokenizer {
  final String source;
  static const Map<String, TokenType> matchers = const {
    r'^\r?\n(?:\s*\n)*': TokenType.lineBreak,
    r'^\s+': TokenType.whitespace,
    r'^\/\/.*': TokenType.lineComment,
    r'^\/\*[^]*?\*\/': TokenType.multilineComment,
    r'''^r(['"])(?:\1\1[^]*?\1\1|.*?)\1''': TokenType.rawString,

    // Keywords
    r'^abstract\b': TokenType.abstractKeyword,
    r'^continue\b': TokenType.continueKeyword,
    r'^false\b': TokenType.falseKeyword,
    r'^new\b': TokenType.newKeyword,
    r'^this\b': TokenType.thisKeyword,
    r'^as\b': TokenType.asKeyword,
    r'^default\b': TokenType.defaultKeyword,
    r'^let\b': TokenType.letKeyword,
    r'^null\b': TokenType.nullKeyword,
    r'^throw\b': TokenType.throwKeyword,
    r'^assert\b': TokenType.assertKeyword,
    r'^deferred\b': TokenType.deferredKeyword,
    r'^finally\b': TokenType.finallyKeyword,
    r'^operator\b': TokenType.operatorKeyword,
    r'^true\b': TokenType.trueKeyword,
    r'^async\b': TokenType.asyncKeyword,
    r'^do\b': TokenType.doKeyword,
    r'^for\b': TokenType.forKeyword,
    r'^part of\b': TokenType.partOfKeyword,
    r'^part\b': TokenType.partKeyword,
    r'^try\b': TokenType.tryKeyword,
    r'^dynamic\b': TokenType.dynamicKeyword,
    r'^get\b': TokenType.getKeyword,
    r'^rethrow\b': TokenType.rethrowKeyword,
    r'^typedef\b': TokenType.typedefKeyword,
    r'^await\b': TokenType.awaitKeyword,
    r'^else\b': TokenType.elseKeyword,
    r'^if\b': TokenType.ifKeyword,
    r'^return\b': TokenType.returnKeyword,
    r'^var\b': TokenType.varKeyword,
    r'^break\b': TokenType.breakKeyword,
    r'^enum\b': TokenType.enumKeyword,
    r'^implements\b': TokenType.implementsKeyword,
    r'^set\b': TokenType.setKeyword,
    r'^void\b': TokenType.voidKeyword,
    r'^case\b': TokenType.caseKeyword,
    r'^export\b': TokenType.exportKeyword,
    r'^import\b': TokenType.importKeyword,
    r'^static\b': TokenType.staticKeyword,
    r'^while\b': TokenType.whileKeyword,
    r'^catch\b': TokenType.catchKeyword,
    r'^external\b': TokenType.externalKeyword,
    r'^in\b': TokenType.inKeyword,
    r'^super\b': TokenType.superKeyword,
    r'^with\b': TokenType.withKeyword,
    r'^class\b': TokenType.classKeyword,
    r'^extends\b': TokenType.extendsKeyword,
    r'^is\b': TokenType.isKeyword,
    r'^switch\b': TokenType.switchKeyword,
    r'^yield\b': TokenType.yieldKeyword,
    r'^const\b': TokenType.constKeyword,
    r'^factory\b': TokenType.factoryKeyword,
    r'^library\b': TokenType.libraryKeyword,

    // Punctuation
    r'^\;': TokenType.semicolon,
    r'^\.': TokenType.period,
    r'^\,': TokenType.comma,
    r'^\(': TokenType.openParenthesis,
    r'^\)': TokenType.closeParenthesis,
    r'^\[': TokenType.openBracket,
    r'^\]': TokenType.closeBracket,
    r'^\{': TokenType.openCurly,
    r'^\}': TokenType.closeCurly,
    r'^\<': TokenType.openAngleBracket,
    r'^\>': TokenType.closeAngleBracket,

    _identifierMatcher: TokenType.identifier,
  };
  static const _stringStartPattern = r'''^['"]''';
  static const _identifierMatcher = r'^(?:\$|(?![0-9])\w)[\w$]*';

  Tokenizer(this.source);

  Iterable<Token> tokenize() sync* {
    final tokens = _tokenizeUntil((offset) => offset == source.length, 0);
    yield* tokens;
    yield _t(TokenType.eof, null, _endOffset(tokens));
  }

  Iterable<Token> _tokenizeUntil(bool condition(int offset), int offset) {
    return __tokenizeUntil(condition, offset, []);
  }

  int _endOffset(Iterable<Token> tokens, {int initial: 0}) {
    return tokens.length == 0 ? initial : tokens.last.end;
  }

  Iterable<Token> __tokenizeUntil(bool condition(int offset), int offset, Iterable<Token> tokens) {
    if (condition(offset)) return tokens;
    final Iterable<Token> newTokens = (){
      if (new RegExp(_stringStartPattern).hasMatch(_source(offset)))
        return _tokenizeString(offset);
      return [_tokenizeNext(offset)];
    }();
    final concat = new List.unmodifiable(tokens.toList()..addAll(newTokens));
    return __tokenizeUntil(condition, newTokens.last.end, concat);
  }

  Token _t(TokenType type, String content, int offset) {
    return new Token(type, content, offset, line: currentLine(offset), column: currentColumn(offset));
  }

  _tokenizeStringInterpolationMatcher(int offset, RegExp matcher, [String stringLiteralEnding]) sync* {
    final source = _source(offset);
    final $ = matcher.firstMatch(source);
    final stringAndDollarSign = $[0];
    final string = stringAndDollarSign.substring(0, stringAndDollarSign.length - 1);
    final token = _t(
        TokenType.string,
        string,
        offset
    );
    yield token;
    final ending = stringLiteralEnding ?? ($.groupCount > 1 ? $[2] : $[1]);
    yield* _tokenizeStringInterpolation(token.end, ending);
  }

  _tokenizeStringMatcher(int offset, RegExp matcher) sync* {
    yield _t(
        TokenType.string,
        matcher.firstMatch(_source(offset))[0],
        offset
    );
  }

  Iterable<Token> _tokenizeString(int offset) {
    final source = _source(offset);
    final oneLineInterpolation = new RegExp(r'''^(['"])(?:.*?(?!\\).|)\$''');
    final multiLineInterpolation = new RegExp(r'''^((['"])\2\2)(?:[^]*?(?!\\).|)\$''');
    final oneLineNoInterpolation = new RegExp(r'''^(['"]).*?\1''');
    final multiLineNoInterpolation = new RegExp(r'''^((['"])\2\2)[^]*?\2\2\2''');

    if (multiLineInterpolation.hasMatch(source)) {
      return _tokenizeStringInterpolationMatcher(offset, multiLineInterpolation);
    }
    if (oneLineInterpolation.hasMatch(source)) {
      return _tokenizeStringInterpolationMatcher(offset, oneLineInterpolation);
    }
    if (multiLineNoInterpolation.hasMatch(source)) {
      return _tokenizeStringMatcher(offset, multiLineNoInterpolation);
    }
    if (oneLineNoInterpolation.hasMatch(source)) {
      return _tokenizeStringMatcher(offset, oneLineNoInterpolation);
    }
    throw new TokenizerError('String starting at ${_describePoint(offset)} has no end');
  }

  Iterable<Token> _tokenizeStringInterpolation(int offset, String stringLiteralEnding) sync* {
    final source = _source(offset);
    if (source.startsWith(r'${')) yield* _tokenizeStringInterpolationExpression(offset, stringLiteralEnding);
    else {
      yield _t(TokenType.openStringInterpolation, r'$', offset);
      final identifier = _source(offset + 1);
      final identifierRegEx = new RegExp(_identifierMatcher);
      if (!identifierRegEx.hasMatch(identifier))
        throw new TokenizerError('Invalid token "${identifier.split(' ').first}" in interpolation at ${_describePoint(offset)}');
      final identifierToken = _t(TokenType.identifier, identifierRegEx.firstMatch(identifier)[0], offset + 1);
      yield identifierToken;
      yield _t(TokenType.closeStringInterpolation, '', identifierToken.end);
      yield* _tokenizeStringAfterInterpolation(identifierToken.end, stringLiteralEnding);
    }
  }

  Iterable<Token> _tokenizeStringAfterInterpolation(int offset, String stringLiteralEnding) {
    final source = _source(offset);
    final oneLineInterpolation = new RegExp(r'''^(?:.*?(?!\\).|)\$''');
    final multiLineInterpolation = new RegExp(r'''^(?:[^]*?(?!\\).|)\$''');
    final oneLineNoInterpolation = new RegExp(r'''^.*?''''$stringLiteralEnding');
    final multiLineNoInterpolation = new RegExp(r'''^[^]*?''''$stringLiteralEnding');

    if (multiLineInterpolation.hasMatch(source)) {
      return _tokenizeStringInterpolationMatcher(offset, multiLineInterpolation, stringLiteralEnding);
    }
    if (oneLineInterpolation.hasMatch(source)) {
      return _tokenizeStringInterpolationMatcher(offset, oneLineInterpolation, stringLiteralEnding);
    }
    if (multiLineNoInterpolation.hasMatch(source)) {
      return _tokenizeStringMatcher(offset, multiLineNoInterpolation);
    }
    if (oneLineNoInterpolation.hasMatch(source)) {
      return _tokenizeStringMatcher(offset, oneLineNoInterpolation);
    }
    throw new TokenizerError('String continuing after interpolation '
        'at ${_describePoint(offset)} has no end');
  }

  Iterable<Token> _tokenizeStringInterpolationExpression(int offset, String stringLiteralEnding) sync* {
    final openToken = _t(TokenType.openStringInterpolation, r'${', offset);
    yield openToken;
    final tokens = _tokenizeUntil((offset) => _source(offset).startsWith('}'), openToken.end);
    yield* tokens;
    final endToken = _t(TokenType.closeStringInterpolation, '}', _endOffset(tokens, initial: openToken.end));
    yield endToken;
    yield* _tokenizeStringAfterInterpolation(endToken.end, stringLiteralEnding);
  }

  Token _tokenizeNext(int offset) {
    final s = _source(offset);
    for (final pattern in matchers.keys) {
      final r = new RegExp(pattern);
      if (r.hasMatch(s)) {
        return _t(matchers[pattern], r.firstMatch(s)[0], offset);
      }
    }
    throw new TokenizerError('Unexpected token "${s[0]}" at ${_describePoint(offset)}');
  }

  String _source(int offset) => source.substring(offset);

  String _describePoint(int offset) {
    return '$currentLine:$currentColumn';
  }

  Iterable<String> parsedLines(int offset) => source.substring(0, offset).split(new RegExp(r'\r?\n'));

  int currentLine(int offset) => parsedLines(offset).length;

  int currentColumn(int offset) => parsedLines(offset).last.length;
}

class TokenizerError extends Error {
  final String message;

  TokenizerError(this.message);

  String toString() => 'TokenizerError: $message';
}
