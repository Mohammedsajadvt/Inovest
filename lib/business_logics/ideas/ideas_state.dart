part of 'ideas_bloc.dart';

sealed class IdeasState extends Equatable {
  const IdeasState();

  @override
  List<Object> get props => [];
}

final class IdeasInitial extends IdeasState {}

class IdeasLoading extends IdeasState {}

class CreatedIdeas extends IdeasState {
  final IdeasModel ideas;
  const CreatedIdeas(this.ideas);
  
  @override
  List<Object> get props => [ideas];
}

class GetIdeasLodaing extends IdeasState{
  final IdeasModel ideas;
  const GetIdeasLodaing(this.ideas);
}


class IdeasError extends IdeasState{
  final String error;
  const IdeasError(this.error);
  
  @override
  List<Object> get props => [error];
}