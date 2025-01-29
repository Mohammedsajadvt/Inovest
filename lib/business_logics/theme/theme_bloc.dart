import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:inovest/core/theme/theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(EntrepreneurThemeState()) {
    on<SetEntrepreneurThemeEvent>((event, emit) {
      emit(EntrepreneurThemeState());
    });

    on<SetInvestorThemeEvent>((event, emit) {
      emit(InvestorThemeState());
    });
  }
}
