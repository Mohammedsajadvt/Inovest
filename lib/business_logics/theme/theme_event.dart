part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}


class SetEntrepreneurThemeEvent extends ThemeEvent {}

class SetInvestorThemeEvent extends ThemeEvent {}
