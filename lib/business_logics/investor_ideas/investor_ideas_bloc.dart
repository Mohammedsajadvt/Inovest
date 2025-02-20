import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inovest/data/models/top_ideas_model.dart';
import 'package:inovest/data/models/investor_categories.dart';
import 'package:inovest/data/services/investor_service.dart';
part 'investor_ideas_event.dart';
part 'investor_ideas_state.dart';

class InvestorIdeasBloc extends Bloc<InvestorIdeasEvent, InvestorIdeasState> {
  final InvestorService investorService;
  InvestorIdeasBloc(this.investorService) : super(InvestorIdeasInitial()) {
    on<GetInvestorIdeas>((event, emit) async {
      emit(GetInvestorIdeasLoading());
      try {
        final ideas = await investorService.topIdeas();
        if (ideas != null) {
          emit(GetInvestorLoaded(ideas));
        } else {
          emit(GetInvestorIdeasError("Failed to load ideas"));
        }
      } catch (e) {
        emit(GetInvestorIdeasError(e.toString()));
      }
    });
    on<GetInvestorCategories>((event, emit) async {
      emit(GetInvestorIdeasLoading());
      try {
        final categories = await investorService.investorCategories();
        if (categories != null) {
          emit(InvestorCategoriesLoaded(categories));
        } else {
          emit(GetInvestorIdeasError("Failed to load categories"));
        }
      } catch (e) {
        emit(GetInvestorIdeasError(e.toString()));
      }
    });
  }
}
