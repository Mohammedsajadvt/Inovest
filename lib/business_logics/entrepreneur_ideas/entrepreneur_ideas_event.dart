part of 'entrepreneur_ideas_bloc.dart';

abstract class EntrepreneurIdeasEvent extends Equatable {
  const EntrepreneurIdeasEvent();

  @override
  List<Object> get props => [];
}

class GetEntrepreneurIdeas extends EntrepreneurIdeasEvent {} 