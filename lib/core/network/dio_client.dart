import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

class DioClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final baseUrl = dotenv.env['WEATHER_BASE_URL'] ?? '';
    final apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.connectTimeoutMs),
        receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeoutMs),
        queryParameters: {'key': apiKey},
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      _LogInterceptor(),
      _RetryInterceptor(dio),
    ]);

    return dio;
  }
}

class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ignore: avoid_print
    print('[DIO] REQUEST: ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print('[DIO] ERROR: ${err.type} ${err.message}');
    handler.next(err);
  }
}

class _RetryInterceptor extends Interceptor {
  final Dio dio;
  int _retryCount = 0;

  _RetryInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && _retryCount < AppConstants.maxRetries) {
      _retryCount++;
      try {
        await Future.delayed(Duration(seconds: _retryCount));
        final response = await dio.fetch(err.requestOptions);
        _retryCount = 0;
        handler.resolve(response);
        return;
      } catch (e) {
        // continue to handler
      }
    }
    _retryCount = 0;
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}

/// Converts Dio exceptions to app-level exceptions.
Exception handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const NetworkException('No internet connection. Please check your network.');
    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      final message = e.response?.data?['error']?['message'] ?? 'Server error occurred.';
      return ServerException(message, statusCode: statusCode);
    default:
      return ServerException(e.message ?? 'An unexpected error occurred.');
  }
}
