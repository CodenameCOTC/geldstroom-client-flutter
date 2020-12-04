import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ServerError extends Equatable {
  final String message;
  final String errorCode;
  final Map<String, dynamic> error;

  const ServerError({
    @required this.message,
    @required this.errorCode,
    this.error,
  });

  factory ServerError.fromJson(Map<String, dynamic> json) {
    return ServerError(
      message: json['message'],
      errorCode: json['errorCode'],
      error: json['error'],
    );
  }

  factory ServerError.networkError() {
    return ServerError(
      message: 'Network error',
      errorCode: 'NETWORK_0001',
    );
  }

  factory ServerError.unknownError() {
    return ServerError(
      message: 'Unknown error occurs, please try again later',
      errorCode: 'UNKNOWN_0001',
    );
  }

  @override
  List<Object> get props => [message, errorCode, error];
}

/// error code base on API spec
class UserErrorCode {
  static const duplicateEmail = 'USER_0001';
  static const emailIsNotVerified = 'USER_0002';
  static const invalidCredentials = 'USER_0003';
  static const userNotFound = 'USER_0004';
  static const emailIsAlreadyVerified = 'USER_0005';
  static const validationError = 'USER_400';
}
