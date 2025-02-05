
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/business_logics/auth/auth_event.dart';
import 'package:inovest/business_logics/auth/auth_state.dart';
import 'package:inovest/data/models/login_model.dart';
import 'package:inovest/data/services/auth_service.dart';



class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final LoginModel? response = await authService.loginUser(event.email, event.password);

    if (response!.success && response.accessToken != null && response.refreshToken != null) {
      emit(AuthSuccess(
        accessToken: response.accessToken!,
        refreshToken: response.refreshToken!,
      ));
    } else {
      emit(AuthFailure(message: response.message ?? "Login failed"));
    }
  }
}

