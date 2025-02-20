import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inovest/data/models/profile_model.dart';
import 'package:inovest/data/services/profile_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService profileService;
  ProfileBloc(this.profileService) : super(ProfileInitial()) {
    on<GetProfile>((event, emit) async {
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
    
    on<UpdateProfile>((event, emit) async {
      if (state is GetProfileloaded) {
        final currentProfile = (state as GetProfileloaded).profileModel.data;
        final updatedUserData = currentProfile.copyWith(
          name: event.updatedProfile.data.name,
          fullName: event.updatedProfile.data.fullName,
          email: event.updatedProfile.data.email,
          imageUrl: event.updatedProfile.data.imageUrl,
          phoneNumber: event.updatedProfile.data.phoneNumber,
        );
        
        final updatedProfileModel = ProfileModel(success: true, data: updatedUserData);
        
        try {
          emit(ProfileLoading());
          final result = await profileService.updateProfile(updatedProfileModel);
          if (result != null) {
            emit(ProfileUpdated(result));
          } else {
            emit(ProfileError("Failed to update profile."));
          }
        } catch (e) {
          emit(ProfileError("Error updating profile: $e"));
        }
      }
    });

    on<UpdateProfileImage>((event, emit) async {
      if (state is GetProfileloaded) {
        final currentProfile = (state as GetProfileloaded).profileModel.data;
        final updatedUserData = currentProfile.copyWith(
          imageUrl: event.imagePath,
        );
        final updatedProfileModel = ProfileModel(success: true, data: updatedUserData);
        try {
          emit(ProfileLoading());
          final result = await profileService.updateProfile(updatedProfileModel);
          if (result != null) {
            emit(ProfileUpdated(result));
          } else {
            emit(ProfileError("Failed to update profile image."));
          }
        } catch (e) {
          emit(ProfileError("Error updating profile image: $e"));
        }
      }
    });
  }
}
