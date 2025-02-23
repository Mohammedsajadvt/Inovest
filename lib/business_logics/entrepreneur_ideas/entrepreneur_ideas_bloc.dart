import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inovest/data/models/entrepreneur_ideas_model.dart';
import 'package:inovest/data/services/entrepreneur_service.dart';

part 'entrepreneur_ideas_event.dart';
part 'entrepreneur_ideas_state.dart';

class EntrepreneurIdeasBloc extends Bloc<EntrepreneurIdeasEvent, EntrepreneurIdeasState> {
  final EntrepreneurService entrepreneurService;

  EntrepreneurIdeasBloc({required this.entrepreneurService}) : super(EntrepreneurIdeasInitial()) {
    on<GetEntrepreneurIdeas>(_onGetEntrepreneurIdeas);
    on<SearchEntrepreneurIdeas>((event, emit) {
      if (state is EntrepreneurIdeasLoaded) {
        final currentState = state as EntrepreneurIdeasLoaded;
        
        // If search query is empty, show all ideas
        if (event.query.isEmpty) {
          emit(EntrepreneurIdeasLoaded(currentState.originalIdeas, originalIdeas: currentState.originalIdeas));
          return;
        }

        final filteredIdeas = currentState.originalIdeas.data
            .where((idea) =>
                idea.title.toLowerCase().contains(event.query.toLowerCase()) ||
                idea.abstract.toLowerCase().contains(event.query.toLowerCase()))
            .toList()
            .cast<EntrepreneurIdea>();
        
        emit(EntrepreneurIdeasLoaded(
          EntrepreneurIdeasModel(success: true, data: filteredIdeas),
          originalIdeas: currentState.originalIdeas,
        ));
      }
    });

    on<SortEntrepreneurIdeas>((event, emit) {
      if (state is EntrepreneurIdeasLoaded) {
        final currentState = state as EntrepreneurIdeasLoaded;
        final sortedIdeas = List<EntrepreneurIdea>.from(currentState.ideas.data)
          ..sort((a, b) => event.ascending
              ? a.title.compareTo(b.title)
              : b.title.compareTo(a.title));
        
        emit(EntrepreneurIdeasLoaded(EntrepreneurIdeasModel(success: true, data: sortedIdeas), originalIdeas: currentState.originalIdeas));
      }
    });
  }

  Future<void> _onGetEntrepreneurIdeas(
    GetEntrepreneurIdeas event,
    Emitter<EntrepreneurIdeasState> emit,
  ) async {
    emit(EntrepreneurIdeasLoading());
    try {
      final ideas = await entrepreneurService.getEntrepreneurIdeas();
      if (ideas != null) {
        emit(EntrepreneurIdeasLoaded(ideas, originalIdeas: ideas));
      } else {
        emit(const EntrepreneurIdeasError('Failed to load ideas'));
      }
    } catch (e) {
      emit(EntrepreneurIdeasError(e.toString()));
    }
  }
} 