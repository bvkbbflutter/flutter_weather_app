/// A simple Either monad for functional error handling.
/// [L] is the failure/left type, [R] is the success/right type.
sealed class Either<L, R> {
  const Either();

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;

  L get left => (this as Left<L, R>).value;
  R get right => (this as Right<L, R>).value;

  T fold<T>(T Function(L l) onLeft, T Function(R r) onRight) {
    return switch (this) {
      Left<L, R>(value: final l) => onLeft(l),
      Right<L, R>(value: final r) => onRight(r),
    };
  }
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);
}

Either<L, R> left<L, R>(L value) => Left(value);
Either<L, R> right<L, R>(R value) => Right(value);
