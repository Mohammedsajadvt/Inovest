part of 'check_box_bloc.dart';

sealed class CheckBoxState extends Equatable {
  const CheckBoxState();
}

final class CheckBoxInitial extends CheckBoxState {
  @override
  List<Object> get props => [];
}
