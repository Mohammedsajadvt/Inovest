part of 'entrepreneur_ideas_bloc.dart';

abstract class EntrepreneurIdeasState extends Equatable {
  const EntrepreneurIdeasState();
  
  @override
  List<Object> get props => [];
}

class EntrepreneurIdeasInitial extends EntrepreneurIdeasState {}

class EntrepreneurIdeasLoading extends EntrepreneurIdeasState {}

class EntrepreneurIdeasLoaded extends EntrepreneurIdeasState {
  final EntrepreneurIdeasModel ideas;
  final EntrepreneurIdeasModel originalIdeas;

  const EntrepreneurIdeasLoaded(this.ideas, {required this.originalIdeas});
  
  @override
  List<Object> get props => [ideas, originalIdeas];
}

class EntrepreneurIdeasError extends EntrepreneurIdeasState {
  final String message;
  
  const EntrepreneurIdeasError(this.message);
  
  @override
  List<Object> get props => [message];
} 