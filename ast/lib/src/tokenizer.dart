library arrow.ast.tokenizer;

import 'tokens.dart';

class Tokenizer {
  final String source;
  static const Map<String, TokenType> matchers = const {
    r'^\r?\n': TokenType.lineBreak,
    r'^\s+': TokenType.whitespace,
    r'^\/\/.*': TokenType.lineComment,
    r'^\/\*[^]*?\*\/': TokenType.multilineComment,
  };
  static const _stringStartPattern = r'''^r?['"]''';

  Tokenizer(this.source);

  Iterable<Token> tokenize() {
    return _tokenize(0, []);
  }

  Iterable<Token> _tokenize(int offset, Iterable<Token> tokens) {
    if (offset == source.length)
      return new List.unmodifiable(tokens.toList()
        ..add(new Token(TokenType.eof, null, offset)));
    final Iterable<Token> newTokens = (){
      if (new RegExp(_stringStartPattern).hasMatch(_source(offset)))
        return _tokenizeString(offset);
      return [_tokenizeNext(offset)];
    }();
    final concat = new List.unmodifiable(tokens.toList()..addAll(newTokens));
    return _tokenize(newTokens.last.end, concat);
  }

  Iterable<Token> _tokenizeString(int offset) {
    throw new UnimplementedError('TODO: Tokenize string with interpolation');
  }

  Token _tokenizeNext(int offset) {
    final s = _source(offset);
    for (final pattern in matchers.keys) {
      final r = new RegExp(pattern);
      if (r.hasMatch(s)) {
        return new Token(matchers[pattern], r.firstMatch(s)[0], offset);
      }
    }
    throw new TokenizerError('Unexpected token "${s[0]}" at ${_describePoint(offset)}');
  }

  String _source(int offset) => source.substring(offset);

  String _describePoint(int offset) {
    final lines = source.substring(0, offset).split(new RegExp(r'\r?\n'));
    final line = lines.length;
    final col = lines.last.length;
    return '$line:$col';
  }
}

class TokenizerError extends Error {
  final String message;

  TokenizerError(this.message);

  String toString() => 'TokenizerError: $message';
}
