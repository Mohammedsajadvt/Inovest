import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => []; 
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String? accessToken;
  final String? refreshToken;
  final String? message;

  const AuthSuccess({this.accessToken, this.refreshToken, this.message});

  @override
  List<Object?> get props => [accessToken, refreshToken, message]; // Safely handle nulls
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}
