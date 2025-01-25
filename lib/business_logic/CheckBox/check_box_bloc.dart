import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'check_box_event.dart';
part 'check_box_state.dart';

class CheckBoxBloc extends Bloc<CheckBoxEvent, CheckBoxState> {
  CheckBoxBloc() : super(CheckBoxInitial()) {
    on<CheckBoxEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
