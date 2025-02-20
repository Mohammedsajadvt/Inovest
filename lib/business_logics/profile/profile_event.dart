part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfile extends ProfileEvent{}

class UpdateProfile extends ProfileEvent {
  final ProfileModel updatedProfile;
  const UpdateProfile(this.updatedProfile);

  @override
  List<Object> get props => [updatedProfile];
}

class UpdateProfileImage extends ProfileEvent {
  final String imagePath;
  const UpdateProfileImage(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}
