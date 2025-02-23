part of 'entrepreneur_ideas_bloc.dart';

abstract class EntrepreneurIdeasEvent extends Equatable {
  const EntrepreneurIdeasEvent();

  @override
  List<Object> get props => [];
}

class GetEntrepreneurIdeas extends EntrepreneurIdeasEvent {}

class SortEntrepreneurIdeas extends EntrepreneurIdeasEvent {
  final bool ascending;

  const SortEntrepreneurIdeas(this.ascending);

  @override
  List<Object> get props => [ascending];
}

class SearchEntrepreneurIdeas extends EntrepreneurIdeasEvent {
  final String query;

  const SearchEntrepreneurIdeas(this.query);

  @override
  List<Object> get props => [query];
}