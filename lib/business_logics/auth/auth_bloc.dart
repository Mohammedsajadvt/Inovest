import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/business_logics/auth/auth_event.dart';
import 'package:inovest/business_logics/auth/auth_state.dart';
import 'package:inovest/data/models/login_model.dart';
import 'package:inovest/data/models/signup_model.dart';
import 'package:inovest/data/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignUpEvent>(_onSignup);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
  emit(AuthLoading());

  final LoginModel? response = await authService.loginUser(event.email, event.password);

  if (response != null && response.success && response.data != null) {
    final user = response.data?.user;
    final accessToken = response.data?.tokens?.accessToken;
    final refreshToken = response.data?.tokens?.refreshToken;

    emit(AuthSuccess(
      accessToken: accessToken,
      refreshToken: refreshToken,
      message: "Login successful",
      role: user?.role, 
    ));
  } else {
    emit(AuthFailure(message:"Login failed"));
  }
}


  Future<void> _onSignup(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final SignUpModel? response = await authService.signupUser(
        event.name,
        event.password,
        event.email,
        event.role,
      );

      if (response != null && response.success) {
        emit(AuthSuccess(message: "User created successfully"));
      } else {
        emit(AuthFailure(message: response?.message ?? "Signup failed"));
      }
    } catch (e) {
      String errorMessage = "An unknown error occurred";

      if (e is FormatException) {
        errorMessage = "Invalid data format received. Please try again.";
      } else if (e is TimeoutException) {
        errorMessage = "The request timed out. Please try again.";
      } else if (e is SocketException) {
        errorMessage = "No internet connection. Please check your connection.";
      } else {
        // If it's a custom error, show that message
        print('Error during signup: ${e.toString()}');
      }

      // Emit failure state with the custom error message
      emit(AuthFailure(message: errorMessage));
    }
  }
}
