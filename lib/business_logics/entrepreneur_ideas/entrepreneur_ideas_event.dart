part of 'entrepreneur_ideas_bloc.dart';

abstract class EntrepreneurIdeasEvent extends Equatable {
  const EntrepreneurIdeasEvent();

  @override
  List<Object> get props => [];
}

class GetEntrepreneurIdeas extends EntrepreneurIdeasEvent {}

class SearchEntrepreneurIdeas extends EntrepreneurIdeasEvent {
  final String query;
  const SearchEntrepreneurIdeas({required this.query});

  @override
  List<Object> get props => [query];
}

class SortEntrepreneurIdeas extends EntrepreneurIdeasEvent {
  final bool ascending;
  const SortEntrepreneurIdeas({required this.ascending});

  @override
  List<Object> get props => [ascending];
} 