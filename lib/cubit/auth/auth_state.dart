import 'package:equatable/equatable.dart';
import 'package:fintrack/data/models/user_model.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.onboardingSeen = false, this.message});

  final bool onboardingSeen;
  final String? message;

  @override
  List<Object?> get props => [onboardingSeen, message];
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final UserModel user;

  @override
  List<Object?> get props => [user.id, user.name, user.email];
}

final class AuthFailure extends AuthState {
  const AuthFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
