import 'package:equatable/equatable.dart';
abstract class InvestorIdeasEvent extends Equatable {
  const InvestorIdeasEvent();

  @override
  List<Object> get props => [];
}


class GetInvestorIdeas extends InvestorIdeasEvent{}

class GetInvestorCategories extends InvestorIdeasEvent{}

class CategoriesIdeas extends InvestorIdeasEvent {
  final String categoryId;
  final String? categoryName;

  const CategoriesIdeas(this.categoryId, {this.categoryName});

  @override
  List<Object> get props => [categoryId, categoryName!];
}