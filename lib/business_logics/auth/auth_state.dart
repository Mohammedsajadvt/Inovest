
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String accessToken;
  final String refreshToken;

 const AuthSuccess({required this.accessToken, required this.refreshToken});
   
  @override
  List<Object> get props => [accessToken,refreshToken];
}

class AuthFailure extends AuthState {
  final String message;

 const AuthFailure({required this.message});
   
  @override
  List<Object> get props => [message];
}
