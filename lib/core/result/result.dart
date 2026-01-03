import '../error/failure.dart';

sealed class Result<T> {
  const Result();

  /// Returns true if this is a Success
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is an Error
  bool get isError => this is Error<T>;

  /// Gets the data if Success, otherwise returns null
  T? get dataOrNull => switch (this) {
    Success(:final data) => data,
    Error() => null,
  };

  /// Gets the failure if Error, otherwise returns null
  Failure? get failureOrNull => switch (this) {
    Success() => null,
    Error(:final failure) => failure,
  };

  /// Pattern matching helper
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) error,
  }) {
    return switch (this) {
      Success(:final data) => success(data),
      Error(:final failure) => error(failure),
    };
  }

  /// Map the success value
  Result<R> map<R>(R Function(T data) mapper) {
    return switch (this) {
      Success(:final data) => Success(mapper(data)),
      Error(:final failure) => Error(failure),
    };
  }

  /// FlatMap for chaining Results
  Result<R> flatMap<R>(Result<R> Function(T data) mapper) {
    return switch (this) {
      Success(:final data) => mapper(data),
      Error(:final failure) => Error(failure),
    };
  }
}

/// Represents a successful result containing data
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success($data)';
}

/// Represents an error result containing a Failure
final class Error<T> extends Result<T> {
  final Failure failure;

  const Error(this.failure);

  @override
  String toString() => 'Error($failure)';
}
