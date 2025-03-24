import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/business_logics/auth/auth_event.dart';
import 'package:inovest/business_logics/auth/auth_state.dart';
import 'package:inovest/core/utils/user_utils.dart';
import 'package:inovest/data/models/auth_model.dart';
import 'package:inovest/data/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignUpEvent>(_onSignup);
    on<TokenExpiredEvent>(_onTokenExpired);
    on<LogoutEvent>(_onLogout);
    on<SwitchRoleEvent>(_onSwitchRole);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final AuthModel? response = await authService.loginUser(event.email, event.password);

    if (response != null && response.success) {
      final accessToken = response.data?.tokens?.accessToken ?? "";
      final refreshToken = response.data?.tokens?.refreshToken ?? "";
      final userRole = response.data?.user?.role ?? "GUEST";
      final userId = response.data?.user?.id ?? "";

      if (accessToken.isNotEmpty) {
        await UserUtils.saveUserData(
          token: accessToken,
          role: userRole,
          userId: userId,
        );
      } else {
        print("⚠️ No access token received.");
      }

      emit(AuthSuccess(
        accessToken: accessToken,
        refreshToken: refreshToken,
        message: "Login successful",
        role: userRole,
      ));
    } else {
      emit(AuthFailure(message: response?.message ?? "Login failed"));
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
        final loginResponse = await authService.loginUser(event.email, event.password);

        if (loginResponse != null && loginResponse.success) {
          final accessToken = loginResponse.data?.tokens?.accessToken ?? "";
          final refreshToken = loginResponse.data?.tokens?.refreshToken ?? "";
          final userRole = loginResponse.data?.user?.role ?? event.role;
          final userId = loginResponse.data?.user?.id ?? "";

          if (accessToken.isNotEmpty) {
            await UserUtils.saveUserData(
              token: accessToken,
              role: userRole,
              userId: userId,
            );
          } else {
            print("⚠️ No access token received after login.");
          }

          emit(AuthSuccess(message: "Signup & login successful!"));
        } else {
          emit(AuthFailure(message: "Signup successful, but login failed. Please log in manually."));
        }
      } else {
        emit(AuthFailure(message: response?.message ?? "Signup failed. Please try again."));
      }
    } catch (e) {
      emit(AuthFailure(message: "An error occurred: ${e.toString()}"));
      print('Signup Error: $e');
    }
  }

  Future<void> _onTokenExpired(TokenExpiredEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final refreshToken = await UserUtils.getToken();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      final newAuthModel = await authService.refreshToken();

      if (newAuthModel != null && newAuthModel.success) {
        final accessToken = newAuthModel.data?.tokens?.accessToken ?? "";
        final refreshToken = newAuthModel.data?.tokens?.refreshToken ?? "";
        final userRole = newAuthModel.data?.user?.role ?? "GUEST";
        final userId = newAuthModel.data?.user?.id ?? "";

        if (accessToken.isNotEmpty) {
          await UserUtils.saveUserData(
            token: accessToken,
            role: userRole,
            userId: userId,
          );
        }

        emit(AuthSuccess(
          accessToken: accessToken,
          refreshToken: refreshToken,
          message: "Token refreshed successfully",
          role: userRole,
        ));
      } else {
        emit(AuthFailure(message: "Failed to refresh token."));
      }
    } else {
      emit(AuthFailure(message: "No refresh token available, please log in again."));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await UserUtils.clearUserData();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(message: 'Logout failed: $e'));
    }
  }

  Future<void> _onSwitchRole(SwitchRoleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userId = await UserUtils.getCurrentUserId();
      if (userId == null) {
        emit(AuthFailure(message: 'User not authenticated'));
        return;
      }

      final response = await authService.switchRole(userId, event.newRole);
      
      if (response != null && response.success) {
        emit(AuthSuccess(
          message: "Role switched successfully",
          role: event.newRole,
        ));
      } else {
        emit(AuthFailure(message: response?.message ?? "Failed to switch role"));
      }
    } catch (e) {
      emit(AuthFailure(message: 'Role switch failed: $e'));
    }
  }
}
