part of 'check_box_bloc.dart';

abstract class CheckBoxState extends Equatable {
  final bool isChecked;
  const CheckBoxState(this.isChecked);

  @override
  List<Object> get props => [isChecked];
}

class CheckboxToggled extends CheckBoxState {
  const CheckboxToggled(super.isChecked);
}
