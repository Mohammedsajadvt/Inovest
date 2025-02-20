import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inovest/data/models/profile_model.dart';
import 'package:inovest/data/services/profile_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService profileService;
  ProfileBloc(this.profileService) : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await profileService.getProfile();
        if (profile != null) {
          emit(GetProfileloaded(profile));
        } else {
          emit(ProfileError("Failed to load profile."));
        }
      } catch (e) {
        emit(ProfileError("Error $e"));
      }
    });
  }
}
