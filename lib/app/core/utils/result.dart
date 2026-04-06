import '../error/failures.dart';

abstract class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Error<T>;

  T? get data => isSuccess ? (this as Success<T>).value : null;
  Failure? get failure => isFailure ? (this as Error<T>).error : null;
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Error<T> extends Result<T> {
  final Failure error;
  const Error(this.error);
}
