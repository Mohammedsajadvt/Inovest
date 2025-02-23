part of 'entrepreneur_ideas_bloc.dart';

abstract class EntrepreneurIdeasState extends Equatable {
  const EntrepreneurIdeasState();

  @override
  List<Object> get props => [];
}

class EntrepreneurIdeasInitial extends EntrepreneurIdeasState {}

class EntrepreneurIdeasLoading extends EntrepreneurIdeasState {}

class EntrepreneurIdeasLoaded extends EntrepreneurIdeasState {
  final List<EntrepreneurIdea> allIdeas; 
  final List<EntrepreneurIdea> displayedIdeas;

  const EntrepreneurIdeasLoaded({
    required this.allIdeas,
    required this.displayedIdeas,
  });

  @override
  List<Object> get props => [allIdeas, displayedIdeas];
}

class EntrepreneurIdeasError extends EntrepreneurIdeasState {
  final String message;

  const EntrepreneurIdeasError(this.message);

  @override
  List<Object> get props => [message];
}