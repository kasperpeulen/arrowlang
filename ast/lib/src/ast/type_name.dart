part of arrow.ast.ast;

class TypeName extends Identifier {
  const TypeName(String name) : super(name);

  bool operator ==(other) {
    return other is TypeName
        && super == other;
  }
}

class UndeclaredType extends TypeName {
  const UndeclaredType() : super(null);

  bool operator ==(other) {
    return other is UndeclaredType;
  }
}
