import 'package:bloc/bloc.dart';
import 'package:inovest/business_logics/investor_ideas/investor_ideas_event.dart';
import 'package:inovest/business_logics/investor_ideas/investor_ideas_state.dart';
import 'package:inovest/data/services/investor_service.dart';

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
}}