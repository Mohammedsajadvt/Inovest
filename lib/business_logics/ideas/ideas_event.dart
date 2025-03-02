part of 'ideas_bloc.dart';

abstract class IdeasEvent extends Equatable {
  const IdeasEvent();

  @override
  List<Object> get props => [];
}

class CreateIdeas extends IdeasEvent{
  String title;
  String abstract;
  double expectedInvestment;
  String categoryId;
  CreateIdeas({required this.abstract,required this.expectedInvestment,required this.categoryId,required this.title});
  
  @override
  List<Object> get props => [title,abstract,expectedInvestment,categoryId];
}

class GetIdeas extends  IdeasEvent{}


class SearchCategoriesEvent extends  IdeasEvent{
  final String query;
  const SearchCategoriesEvent({required this.query});
  
  @override
  List<Object> get props => [query];
}

class SortCategoriesEvent extends  IdeasEvent{
  final bool ascending;
  const SortCategoriesEvent(this.ascending);

  @override
  List<Object> get props => [ascending];
}

class UpdateIdea extends IdeasEvent {
  final String id;
  final String title;
  final String abstract;
  final double expectedInvestment;
  final String categoryId;

  const UpdateIdea({
    required this.id,
    required this.title,
    required this.abstract,
    required this.expectedInvestment,
    required this.categoryId,
  });

  @override
  List<Object> get props => [id, title, abstract, expectedInvestment, categoryId];
}

class DeleteIdea extends IdeasEvent {
  final String id;

  const DeleteIdea({required this.id});

  @override
  List<Object> get props => [id];
}