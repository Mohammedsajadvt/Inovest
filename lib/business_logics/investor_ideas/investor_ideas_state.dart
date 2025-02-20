part of 'investor_ideas_bloc.dart';

sealed class InvestorIdeasState extends Equatable {
  const InvestorIdeasState();

  @override
  List<Object> get props => [];
}

final class InvestorIdeasInitial extends InvestorIdeasState {}

class GetInvestorLoaded extends InvestorIdeasState {
  final TopIdeas topIdeas;
  const GetInvestorLoaded(this.topIdeas);

  @override
  List<Object> get props => [topIdeas];
}

class GetInvestorIdeasLoading extends InvestorIdeasState{}

class GetInvestorIdeasError extends InvestorIdeasState{
  final String message;
  const GetInvestorIdeasError(this.message);
  
  @override
  List<Object> get props => [message];
}