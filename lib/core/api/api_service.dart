import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_exceptions.dart';

class ApiService {
  static const String baseUrl = 'https://fitness.wigian.in/';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  ApiService() {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 500 &&
              error.requestOptions.extra['retryCount'] == null) {
            error.requestOptions.extra['retryCount'] = 1;
            try {
              await Future.delayed(const Duration(seconds: 1));
              final response = await _dio.fetch(error.requestOptions);
              handler.resolve(response);
              return;
            } catch (e) {}
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getPlans(String date) async {
    try {
      if (kDebugMode) {
        print('🔄 Fetching plans for date: $date');
      }

      final res = await _dio.get(
        'user_plan_api.php',
        queryParameters: {'date': date},
      );

      if (kDebugMode) {
        print('✅ Successfully fetched plans');
      }

      // Handle both direct data and wrapped response
      if (res.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(res.data);
      } else {
        return {'date': date, 'plans': res.data ?? []};
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching plans: ${e.message}');
      }
      throw ApiException.fromDio(e);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unexpected error: $e');
      }
      throw ApiException('Unexpected error occurred', code: 500);
    }
  }

  Future<Map<String, dynamic>> upsertPlans(Map<String, dynamic> body) async {
    try {
      if (kDebugMode) {
        print('🔄 Upserting plans: ${body['plans']?.length ?? 0} plans');
      }

      final res = await _dio.post('user_plan_api.php', data: body);

      if (kDebugMode) {
        print('✅ Successfully upserted plans');
      }

      if (res.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(res.data);
      } else {
        return {'message': res.data?.toString() ?? 'Success', 'success': true};
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Error upserting plans: ${e.message}');
      }
      throw ApiException.fromDio(e);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unexpected error: $e');
      }
      throw ApiException('Unexpected error occurred', code: 500);
    }
  }

  Future<bool> healthCheck() async {
    try {
      final res = await _dio.get('health.php');
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
