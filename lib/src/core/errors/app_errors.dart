import 'package:equatable/equatable.dart';

/// Base class for all app errors
abstract class AppError extends Equatable {
  final String message;
  final String? code;

  const AppError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Network related errors
class NetworkError extends AppError {
  const NetworkError(super.message, {super.code});
}

/// Server related errors
class ServerError extends AppError {
  final int? statusCode;

  const ServerError(super.message, {super.code, this.statusCode});

  @override
  List<Object?> get props => [message, code, statusCode];
}

/// Data validation errors
class ValidationError extends AppError {
  const ValidationError(super.message, {super.code});
}

/// Unknown errors
class UnknownError extends AppError {
  const UnknownError(super.message, {super.code});
}

/// Post specific errors
class PostError extends AppError {
  const PostError(super.message, {super.code});
}

/// Comment specific errors
class CommentError extends AppError {
  const CommentError(super.message, {super.code});
}
