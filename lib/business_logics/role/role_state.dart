part of 'role_bloc.dart';

abstract class RoleState {}

class RoleInitial extends RoleState {}

class RoleLoading extends RoleState {}

class RoleLoaded extends RoleState {
  final String? role;

  RoleLoaded(this.role);
}

class RoleError extends RoleState {
  final String message;

  RoleError(this.message);
}