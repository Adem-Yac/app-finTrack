import 'package:dio/dio.dart';
import 'package:fintrack/core/constants/api_constants.dart';
import 'package:fintrack/data/local/token_storage.dart';

class ApiClient {
  ApiClient(this._tokenStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        contentType: Headers.jsonContentType,
        headers: const {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.read();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (_canFallback(error)) {
            try {
              _dio.options.baseUrl = ApiConstants.hostedUrl;
              final retry = await _dio.fetch<dynamic>(
                error.requestOptions.copyWith(baseUrl: ApiConstants.hostedUrl),
              );
              handler.resolve(retry);
              return;
            } catch (_) {}
          }

          final status = error.response?.statusCode;
          final path = error.requestOptions.path;
          final isPublicAuth =
              path.contains('/auth/login') ||
              path.contains('/auth/register') ||
              path.contains('/auth/google') ||
              path.contains('/auth/forgot-password') ||
              path.contains('/auth/reset-password');
          if (status == 401 && !isPublicAuth) {
            await _tokenStorage.clear();
            onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );
  }

  final TokenStorage _tokenStorage;
  late final Dio _dio;
  void Function()? onUnauthorized;

  bool _canFallback(DioException error) {
    final current = _dio.options.baseUrl;
    if (current == ApiConstants.hostedUrl) {
      return false;
    }
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout;
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query}) {
    return _dio.get<T>(path, queryParameters: query);
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
  }) {
    return _dio.post<T>(path, data: data, queryParameters: query);
  }

  Future<Response<T>> put<T>(String path, {Object? data}) {
    return _dio.put<T>(path, data: data);
  }

  Future<Response<T>> delete<T>(String path) {
    return _dio.delete<T>(path);
  }
}
