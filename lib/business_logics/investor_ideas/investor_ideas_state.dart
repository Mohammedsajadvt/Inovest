import 'package:equatable/equatable.dart';
import 'package:inovest/data/models/categories_ideas.dart';
import 'package:inovest/data/models/investor_categories.dart';
import 'package:inovest/data/models/top_ideas_model.dart';

abstract class InvestorIdeasState extends Equatable {
  const InvestorIdeasState();

  @override
  List<Object?> get props => [];
}

class InvestorIdeasInitial extends InvestorIdeasState {}

class InvestorIdeasLoading extends InvestorIdeasState {}

class InvestorIdeasLoaded extends InvestorIdeasState {
  final TopIdeas? topIdeas;
  final InvestorCategories? investorCategories;

  const InvestorIdeasLoaded({this.topIdeas, this.investorCategories});

  InvestorIdeasLoaded copyWith({
    TopIdeas? topIdeas,
    InvestorCategories? investorCategories,
  }) {
    return InvestorIdeasLoaded(
      topIdeas: topIdeas ?? this.topIdeas,
      investorCategories: investorCategories ?? this.investorCategories,
    );
  }

  @override
  List<Object?> get props => [topIdeas, investorCategories];
}

class InvestorIdeasError extends InvestorIdeasState {
  final String message;

  const InvestorIdeasError(this.message);

  @override
  List<Object?> get props => [message];
}

class GetCategoriesBasedIdeasLoaded extends InvestorIdeasState {
  final CategoriesIdeasModel ideas;
  final String? categoryName;
  final List<DatumIdeas> favoriteIdeas;

  const GetCategoriesBasedIdeasLoaded(
    this.ideas, {
    this.categoryName,
    this.favoriteIdeas = const [],
  });

  GetCategoriesBasedIdeasLoaded copyWith({
    CategoriesIdeasModel? ideas,
    String? categoryName,
    List<DatumIdeas>? favoriteIdeas,
  }) {
    return GetCategoriesBasedIdeasLoaded(
      ideas ?? this.ideas,
      categoryName: categoryName ?? this.categoryName,
      favoriteIdeas: favoriteIdeas ?? this.favoriteIdeas,
    );
  }

  @override
  List<Object?> get props => [ideas, categoryName, favoriteIdeas];
}


