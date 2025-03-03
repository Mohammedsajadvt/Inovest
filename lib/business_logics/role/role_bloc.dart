import 'package:bloc/bloc.dart';
import 'package:inovest/core/app_settings/secure_storage.dart';

part 'role_event.dart';
part 'role_state.dart';
class RoleBloc extends Bloc<RoleEvent, RoleState> {
  RoleBloc() : super(RoleInitial()) {
    on<LoadRole>(_onLoadRole);
  }

  Future<void> _onLoadRole(LoadRole event, Emitter<RoleState> emit) async {
    emit(RoleLoading());
    try {
      final role = await SecureStorage().getRole();
      emit(RoleLoaded(role));
    } catch (e) {
      emit(RoleError('Failed to load role: $e'));
    }
  }
}