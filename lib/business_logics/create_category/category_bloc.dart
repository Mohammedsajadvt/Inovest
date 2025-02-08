import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/business_logics/create_category/category_event.dart';
import 'package:inovest/business_logics/create_category/category_state.dart';
import 'package:inovest/data/services/entrepreneur_service.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final EntrepreneurService entrepreneurService;

  CategoryBloc(this.entrepreneurService) : super(CategoryInitial()) {
    on<CreateCategoryEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        final category = await entrepreneurService.createCategory(event.name, event.description);
        if (category != null) {
          emit(CategoryCreated(category));
        } else {
          emit(CategoryError("Failed to create category."));
        }
      } catch (e) {
        emit(CategoryError("An error occurred: $e"));
      }
    });
  }
}
