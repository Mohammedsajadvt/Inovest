import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String role;
  const SignUpEvent(
      {required this.email,
      required this.password,
      required this.name,
      required this.role});
  @override
  List<Object> get props => [email, password];
}

class TokenExpiredEvent extends AuthEvent{}

class LogoutEvent extends AuthEvent {}

class SwitchRoleEvent extends AuthEvent {
  final String newRole;

  const SwitchRoleEvent({required this.newRole});

  @override
  List<Object> get props => [newRole];
}
