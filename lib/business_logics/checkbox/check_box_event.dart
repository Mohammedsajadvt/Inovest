part of 'check_box_bloc.dart';

abstract class CheckBoxEvent extends Equatable {
  const CheckBoxEvent();

  @override
  List<Object> get props => [];
}

class ToggleCheckbox extends CheckBoxEvent {}
