
import 'package:equatable/equatable.dart';

abstract class GetCategoriesEvent extends Equatable {
  const GetCategoriesEvent();

  @override
  List<Object> get props => [];
}

class FetchCategoriesEvent extends GetCategoriesEvent{}


class SearchCategoriesEvent extends GetCategoriesEvent{
  final String query;
  const SearchCategoriesEvent({required this.query});
  
  @override
  List<Object> get props => [query];
}

class SortCategoriesEvent extends GetCategoriesEvent {
  final bool ascending;
  const SortCategoriesEvent(this.ascending);

  @override
  List<Object> get props => [ascending];
}