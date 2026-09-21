import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/cubit/auth/auth_state.dart';
import 'package:fintrack/data/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthInitial());

  final AuthRepository _repository;

  Future<void> bootstrap() async {
    emit(const AuthLoading());
    final seen = await _repository.onboardingSeen();
    final user = await _repository.restoreSession();
    if (user != null) {
      emit(AuthAuthenticated(user));
      return;
    }
    emit(AuthUnauthenticated(onboardingSeen: seen));
  }

  Future<void> google() async {
    try {
      final google = GoogleSignIn.instance;
      await google.initialize();
      final account = await google.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        emit(const AuthFailure('Connexion Google indisponible.'));
        return;
      }
      emit(AuthAuthenticated(await _repository.google(idToken)));
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return;
      }
      emit(AuthFailure(error.description ?? 'Connexion Google indisponible.'));
    } catch (error) {
      emit(AuthFailure(_message(error)));
    }
  }

  Future<void> login(String identifier, String password) async {
    try {
      final user = await _repository.login(identifier, password);
      emit(AuthAuthenticated(user));
    } catch (error) {
      emit(AuthFailure(_message(error)));
    }
  }

  Future<void> register({
    required String name,
    String? email,
    String? phone,
    required String password,
  }) async {
    try {
      final user = await _repository.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } catch (error) {
      emit(AuthFailure(_message(error)));
    }
  }

  Future<void> completeOnboarding() async {
    await _repository.setOnboardingSeen();
    emit(const AuthUnauthenticated(onboardingSeen: true));
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthUnauthenticated(onboardingSeen: true));
  }

  void expireSession() {
    if (state is AuthUnauthenticated) {
      return;
    }
    emit(const AuthUnauthenticated(onboardingSeen: true, message: 'session'));
  }

  Future<void> forgotPassword(String email) =>
      _repository.forgotPassword(email);

  String _message(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      if (data is Map && data['errors'] is Map) {
        final first = (data['errors'] as Map).values.first;
        if (first is List && first.isNotEmpty) {
          return first.first.toString();
        }
      }
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout) {
        return 'Serveur injoignable. Vérifiez internet, puis réessayez.';
      }
    }
    return 'Impossible de se connecter. Vérifiez l’API Laravel.';
  }
}
