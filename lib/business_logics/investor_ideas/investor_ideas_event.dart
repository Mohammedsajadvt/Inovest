import 'package:equatable/equatable.dart';

import '../../data/models/categories_ideas.dart';

abstract class InvestorIdeasEvent extends Equatable {
  const InvestorIdeasEvent();

  @override
  List<Object?> get props => []; 
}

class GetInvestorIdeas extends InvestorIdeasEvent {}

class GetInvestorCategories extends InvestorIdeasEvent {}

class CategoriesIdeas extends InvestorIdeasEvent {
  final String categoryId;
  final String categoryName;
  const CategoriesIdeas({required this.categoryId, required this.categoryName});

  @override
  List<Object?> get props => [categoryId, categoryName];
}

class ToggleFavoriteIdea extends InvestorIdeasEvent {
  final DatumIdeas idea;

 const ToggleFavoriteIdea(this.idea);
   @override
  List<Object?> get props => [idea];
}

class SearchInvestorIdeas extends InvestorIdeasEvent {
  final String query;
  const SearchInvestorIdeas({required this.query});

  @override
  List<Object?> get props => [query];
}
