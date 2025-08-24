import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? code;
  ApiException(this.message, {this.code});

  @override
  String toString() => 'ApiException($code): $message';

  factory ApiException.fromDio(DioException e) {
    final status = e.response?.statusCode;
    final msg = e.response?.data is Map
        ? (e.response?.data['message']?.toString() ?? e.message)
        : e.message;
    return ApiException(msg ?? 'Network error', code: status);
  }
}
