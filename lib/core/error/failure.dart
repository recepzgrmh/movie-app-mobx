import 'package:equatable/equatable.dart';
import 'exceptions.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required super.message, super.statusCode});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message, super.statusCode});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({required super.message, super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.statusCode});
}

class ParsingFailure extends Failure {
  const ParsingFailure({required super.message, super.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.statusCode});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.statusCode});
}

Failure failureFrom(Object error) {
  if (error is UnauthorizedException) {
    return UnauthorizedFailure(
      message: error.message,
      statusCode: error.statusCode,
    );
  }
  if (error is NotFoundException) {
    return NotFoundFailure(
      message: error.message,
      statusCode: error.statusCode,
    );
  }
  if (error is TimeoutException) {
    return TimeoutFailure(message: error.message, statusCode: error.statusCode);
  }
  if (error is NetworkException) {
    return NetworkFailure(message: error.message, statusCode: error.statusCode);
  }
  if (error is ParsingException) {
    return ParsingFailure(message: error.message, statusCode: error.statusCode);
  }
  if (error is CacheException) {
    return CacheFailure(message: error.message, statusCode: error.statusCode);
  }
  if (error is ServerException) {
    return ServerFailure(message: error.message, statusCode: error.statusCode);
  }
  if (error is AppException) {
    return UnknownFailure(message: error.message, statusCode: error.statusCode);
  }

  return UnknownFailure(message: 'Unexpected error: $error');
}
