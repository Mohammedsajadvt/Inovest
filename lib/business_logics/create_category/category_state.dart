import 'package:equatable/equatable.dart';
import 'package:inovest/data/models/category_model.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryCreated extends CategoryState {
  final CategoryModel category;

  const CategoryCreated(this.category);

  @override
  List<Object> get props => [category];
}

class CategoryError extends CategoryState {
  final String error;

  const CategoryError(this.error);

  @override
  List<Object> get props => [error];
}
