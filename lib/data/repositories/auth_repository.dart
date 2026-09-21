import 'package:dio/dio.dart';
import 'package:fintrack/data/local/token_storage.dart';
import 'package:fintrack/data/models/user_model.dart';
import 'package:fintrack/data/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fintrack/core/constants/api_constants.dart';

class AuthRepository {
  AuthRepository(this._api, this._tokens);

  final ApiClient _api;
  final TokenStorage _tokens;

  Future<UserModel> login(String identifier, String password) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'identifier': identifier, 'password': password},
    );
    return _persist(response.data!);
  }

  Future<UserModel> register({
    required String name,
    String? email,
    String? phone,
    required String password,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'name': name,
        'password': password,
        if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
        if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
      },
    );
    return _persist(response.data!);
  }

  Future<UserModel> google(String idToken) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/auth/google',
      data: {'id_token': idToken},
    );
    return _persist(response.data!);
  }

  Future<void> forgotPassword(String email) {
    return _api.post('/auth/forgot-password', data: {'email': email});
  }

  Future<UserModel?> restoreSession() async {
    final token = await _tokens.read();
    if (token == null || token.isEmpty) {
      return null;
    }
    try {
      final response = await _api.get<Map<String, dynamic>>('/auth/me');
      return UserModel.fromJson(response.data!['data'] as Map<String, dynamic>);
    } on DioException {
      await _tokens.clear();
      return null;
    }
  }

  Future<UserModel> updateProfile(Map<String, dynamic> payload) async {
    final response = await _api.put<Map<String, dynamic>>(
      '/auth/profile',
      data: payload,
    );
    return UserModel.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  Future<void> logout() async {
    try {
      await _api.post('/auth/logout');
    } catch (_) {}
    await _tokens.clear();
  }

  Future<bool> onboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(ApiConstants.onboardingKey) ?? false;
  }

  Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ApiConstants.onboardingKey, true);
  }

  Future<UserModel> _persist(Map<String, dynamic> body) async {
    final data = body['data'] as Map<String, dynamic>;
    await _tokens.write(data['token'] as String);
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }
}
