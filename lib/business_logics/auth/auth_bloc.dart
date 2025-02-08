import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/business_logics/auth/auth_event.dart';
import 'package:inovest/business_logics/auth/auth_state.dart';
import 'package:inovest/core/app_settings/secure_storage.dart';
import 'package:inovest/data/models/auth_model.dart';
import 'package:inovest/data/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignUpEvent>(_onSignup);
  }

 Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
  emit(AuthLoading());

  final AuthModel? response = await authService.loginUser(event.email, event.password);

  if (response != null && response.success) {
    final accessToken = response.data?.tokens?.accessToken ?? "";
    final refreshToken = response.data?.tokens?.refreshToken ?? "";
    final userRole = response.data?.user?.role ?? "GUEST"; // Default to "GUEST" if role is null

    if (accessToken.isNotEmpty) {
      await SecureStorage().saveToken(accessToken);
      await SecureStorage().saveRole(userRole);
    } else {
      print("⚠️ No access token received.");
    }

    // Emit AuthSuccess with user details
    emit(AuthSuccess(
      accessToken: accessToken,
      refreshToken: refreshToken,
      message: "Login successful",
      role: userRole,
    ));
  } else {
    emit(AuthFailure(message: "Login failed"));
  }
}

Future<void> _onSignup(SignUpEvent event, Emitter<AuthState> emit) async {
  emit(AuthLoading());

  try {
    final response = await authService.signupUser(
      event.name,
      event.password,
      event.email,
      event.role,
    );

    if (response != null && response.success) {
      print("✅ Signup successful! Now attempting login...");

      final loginResponse = await authService.loginUser(event.email, event.password);

      if (loginResponse != null && loginResponse.success) {
        final accessToken = loginResponse.data?.tokens?.accessToken ?? "";
        final refreshToken = loginResponse.data?.tokens?.refreshToken ?? "";
        final userRole = loginResponse.data?.user?.role ?? event.role; // Use provided role if missing

        if (accessToken.isNotEmpty) {
          await SecureStorage().saveToken(accessToken);
          await SecureStorage().saveRole(userRole);
          print("✅ Tokens saved to SecureStorage.");
        } else {
          print("⚠️ No access token received after login.");
        }

        emit(AuthSuccess(message: "Signup & login successful!"));
      } else {
        emit(AuthFailure(message: "Signup successful, but login failed. Please log in manually."));
      }
    } else {
      emit(AuthFailure(message: "Signup failed. Please try again."));
    }
  } catch (e) {
    emit(AuthFailure(message: "An error occurred: ${e.toString()}"));
    print('Signup Error: $e');
  }
}

}
