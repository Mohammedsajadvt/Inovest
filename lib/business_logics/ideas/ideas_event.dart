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