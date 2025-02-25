import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:inovest/core/utils/index.dart';
import 'package:inovest/data/models/categories_ideas.dart';
import 'package:inovest/data/models/ideas_model.dart';
import 'package:inovest/data/services/entrepreneur_service.dart';

part 'ideas_event.dart';
part 'ideas_state.dart';

class IdeasBloc extends Bloc<IdeasEvent, IdeasState> {
  final EntrepreneurService entrepreneurService;
  IdeasBloc(this.entrepreneurService) : super(IdeasInitial()) {
    on<CreateIdeas>((event, emit) async {
      emit(IdeasLoading());
      try {
        final ideas = await entrepreneurService.createIdeas(event.title,
            event.abstract, event.expectedInvestment, event.categoryId);
        if (ideas != null) {
          emit(CreatedIdeas(ideas));
        } else {
          emit(IdeasError("Failed to create ideas."));
        }
      } catch (e) {
        emit(IdeasError("An error occurred: $e"));
      }
    });
    on<GetIdeas>((event, emit) async {
      emit(IdeasLoading());
      try {
        final ideas = await EntrepreneurService().getIdeas();
        if (ideas != null) {
          emit(GetIdeasLodaing(ideas));
        } else {
          emit(IdeasError("Failed to load ideas."));
        }
      } catch (e) {
        emit(IdeasError("An error occurred: $e"));
      }
    });
    

  }
  
}
