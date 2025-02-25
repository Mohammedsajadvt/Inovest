import 'package:bloc/bloc.dart';
import 'package:inovest/business_logics/investor_ideas/investor_ideas_event.dart';
import 'package:inovest/business_logics/investor_ideas/investor_ideas_state.dart';
import 'package:inovest/data/models/categories_ideas.dart';
import 'package:inovest/data/services/investor_service.dart';
import 'package:inovest/data/models/top_ideas_model.dart';

class InvestorIdeasBloc extends Bloc<InvestorIdeasEvent, InvestorIdeasState> {
  final InvestorService investorService;

  InvestorIdeasBloc(this.investorService) : super(InvestorIdeasInitial()) {
    on<GetInvestorIdeas>((event, emit) async {
      emit(InvestorIdeasLoading());
      try {
        final ideas = await investorService.topIdeas();
        if (ideas != null) {
          final currentState = state;
          if (currentState is InvestorIdeasLoaded) {
            emit(currentState.copyWith(topIdeas: ideas));
          } else {
            emit(InvestorIdeasLoaded(topIdeas: ideas));
          }
        } else {
          emit(const InvestorIdeasError("Failed to load ideas"));
        }
      } catch (e) {
        emit(InvestorIdeasError(e.toString()));
      }
    });

    on<GetInvestorCategories>((event, emit) async {
      emit(InvestorIdeasLoading());
      try {
        final categories = await investorService.investorCategories();
        if (categories != null) {
          final currentState = state;
          if (currentState is InvestorIdeasLoaded) {
            emit(currentState.copyWith(investorCategories: categories));
          } else {
            emit(InvestorIdeasLoaded(investorCategories: categories));
          }
        } else {
          emit(const InvestorIdeasError("Failed to load categories"));
        }
      } catch (e) {
        emit(InvestorIdeasError(e.toString()));
      }
    });
   on<CategoriesIdeas>((event, emit) async {
  emit(InvestorIdeasLoading());
  try {
    final categoriesIdeas = await investorService.ideas(event.categoryId);
    if (categoriesIdeas != null) {
      emit(GetCategoriesBasedIdeasLoaded(categoriesIdeas, categoryName: event.categoryName));
    } else {
      emit(const InvestorIdeasError("Failed to load category ideas"));
    }
  } catch (e) {
    emit(InvestorIdeasError(e.toString()));
  }
});
on<ToggleFavoriteIdea>((event, emit) {
  if (state is GetCategoriesBasedIdeasLoaded) {
    final currentState = state as GetCategoriesBasedIdeasLoaded;

    final updatedFavorites = List<DatumIdeas>.from(currentState.favoriteIdeas);
    if (updatedFavorites.contains(event.idea)) {
      updatedFavorites.remove(event.idea);
    } else {
      updatedFavorites.insert(0, event.idea);
    }

    emit(GetCategoriesBasedIdeasLoaded(
      currentState.ideas,
      favoriteIdeas: updatedFavorites,
    ));
  }
});

    on<SearchInvestorIdeas>((event, emit) {
      if (state is InvestorIdeasLoaded) {
        final currentState = state as InvestorIdeasLoaded;
        
        final originalData = currentState.topIdeas?.data ?? [];
        
        if (event.query.isEmpty) {
          emit(InvestorIdeasLoaded(
            topIdeas: currentState.topIdeas,
            investorCategories: currentState.investorCategories,
          ));
          return;
        }

        final filteredData = originalData.where((idea) {
          final title = idea.title.toLowerCase();
          final abstract = idea.datumAbstract.toLowerCase();
          final category = idea.category?.name.toLowerCase() ?? '';
          final searchQuery = event.query.toLowerCase();
          
          return title.contains(searchQuery) || 
                 abstract.contains(searchQuery) || 
                 category.contains(searchQuery);
        }).toList();

        final filteredIdeas = TopIdeas(
          success: currentState.topIdeas?.success ?? true,
          data: filteredData,
        );

        emit(InvestorIdeasLoaded(
          topIdeas: filteredIdeas,
          investorCategories: currentState.investorCategories,
        ));
      }
    });
  }
}