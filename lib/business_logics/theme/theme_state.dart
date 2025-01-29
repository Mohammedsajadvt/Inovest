part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  final ThemeData themeData;
  const ThemeState(this.themeData);
  
  @override
  List<Object> get props => [themeData];
}

class EntrepreneurThemeState extends ThemeState {
  EntrepreneurThemeState() : super(entrepreneurTheme);
  
  @override
  List<Object> get props => [entrepreneurTheme];
}

class InvestorThemeState extends ThemeState {
  InvestorThemeState() : super(investorTheme);
  
  @override
  List<Object> get props => [investorTheme];
}
