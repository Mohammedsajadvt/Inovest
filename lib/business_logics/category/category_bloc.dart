import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/business_logics/category/category_event.dart';
import 'package:inovest/business_logics/category/category_state.dart';
import 'package:inovest/data/models/category_model.dart';
import 'package:inovest/data/services/entrepreneur_service.dart';

class GetCategoriesBloc extends Bloc<GetCategoriesEvent, GetCategoriesState> {
  final EntrepreneurService entrepreneurService;
  List<CategoryModel> _allCategories = [];

  GetCategoriesBloc(this.entrepreneurService) : super(GetCategoriesInitial()) {
    on<FetchCategoriesEvent>(_onFetchCategories);
  
  }

  Future<void> _onFetchCategories(
      FetchCategoriesEvent event, Emitter<GetCategoriesState> emit) async {
    emit(GetCategoryLoading());
    try {
      final categories = await entrepreneurService.getCategory();

      if (categories != null && categories.isNotEmpty) {
        _allCategories = categories;
        emit(GetCategoryLoaded(categories));
      } else {
        emit(GetCategoryError('No categories found'));
      }
    } catch (e) {
      print("Error fetching categories: $e");
      emit(GetCategoryError('Failed to fetch categories. Please try again.'));
    }
  }


}
