part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class GetProfileloaded extends ProfileState {
  final ProfileModel profileModel;
  const GetProfileloaded(this.profileModel);

  @override
  List<Object> get props => [profileModel];
}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}
