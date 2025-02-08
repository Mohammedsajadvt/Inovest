import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CreateCategoryEvent extends CategoryEvent {
  final String name;
  final String description;

  const CreateCategoryEvent(this.name, this.description);

  @override
  List<Object> get props => [name, description];
}
