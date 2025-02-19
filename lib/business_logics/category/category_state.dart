import 'package:equatable/equatable.dart';
import 'package:inovest/data/models/category_model.dart';

abstract class GetCategoriesState extends Equatable {
  const GetCategoriesState();

  @override
  List<Object> get props => [];
}

class GetCategoriesInitial extends GetCategoriesState {}

class  GetCategoryLoading extends GetCategoriesState {}

class GetCategoryLoaded extends GetCategoriesState {
  final List<CategoryModel> categories;

  const GetCategoryLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class GetCategoryError extends GetCategoriesState {
  final String error;

  const GetCategoryError(this.error);

  @override
  List<Object> get props => [error];
}