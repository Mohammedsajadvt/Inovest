part of 'investor_ideas_bloc.dart';

abstract class InvestorIdeasEvent extends Equatable {
  const InvestorIdeasEvent();

  @override
  List<Object> get props => [];
}


class GetInvestorIdeas extends InvestorIdeasEvent{}