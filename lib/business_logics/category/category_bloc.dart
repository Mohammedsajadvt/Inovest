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
    on<SearchCategoriesEvent>(_onSearchCategories);
    on<SortCategoriesEvent>(_onSortCategories);
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

  void _onSearchCategories(
      SearchCategoriesEvent event, Emitter<GetCategoriesState> emit) {
    if (event.query.isEmpty) {
      emit(GetCategoryLoaded(_allCategories));
    } else {
      final filtered = _allCategories.where((category) {
        return category.name.toLowerCase().contains(event.query.toLowerCase());
      }).toList();
      emit(GetCategoryLoaded(filtered));
    }
  }

  void _onSortCategories(
      SortCategoriesEvent event, Emitter<GetCategoriesState> emit) {
    if (state is GetCategoryLoaded) {
      final currentList =
          List<CategoryModel>.from((state as GetCategoryLoaded).categories);
      currentList.sort((a, b) => event.ascending
          ? a.name.compareTo(b.name)
          : b.name.compareTo(a.name));
      emit(GetCategoryLoaded(currentList));
    }
  }
}
