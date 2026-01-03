class AppException implements Exception {
  final String message;
  final int? statusCode;
  final Object? cause;

  const AppException({required this.message, this.statusCode, this.cause});

  @override
  String toString() =>
      'AppException(statusCode: $statusCode, message: $message, cause: $cause)';
}

// --- Remote / API ---
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.cause,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Unauthorized',
    super.statusCode,
    super.cause,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Not found',
    super.statusCode,
    super.cause,
  });
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timed out',
    super.statusCode,
    super.cause,
  });
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.statusCode,
    super.cause,
  });
}

class ParsingException extends AppException {
  const ParsingException({
    super.message = 'Failed to parse response',
    super.statusCode,
    super.cause,
  });
}

// --- Local / Cache ---
class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error',
    super.statusCode,
    super.cause,
  });
}

class UnknownException extends AppException {
  const UnknownException({
    super.message = 'Unknown error',
    super.statusCode,
    super.cause,
  });
}
