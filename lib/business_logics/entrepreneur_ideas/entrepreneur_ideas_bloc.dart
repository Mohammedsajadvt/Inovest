import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inovest/data/models/entrepreneur_ideas_model.dart';
import 'package:inovest/data/services/entrepreneur_service.dart';

part 'entrepreneur_ideas_event.dart';
part 'entrepreneur_ideas_state.dart';

class EntrepreneurIdeasBloc
    extends Bloc<EntrepreneurIdeasEvent, EntrepreneurIdeasState> {
  final EntrepreneurService entrepreneurService;

  EntrepreneurIdeasBloc({required this.entrepreneurService})
      : super(EntrepreneurIdeasInitial()) {
    on<GetEntrepreneurIdeas>(_onGetEntrepreneurIdeas);
    on<SortEntrepreneurIdeas>(_onSortEntrepreneurIdeas);
    on<SearchEntrepreneurIdeas>(_onSearchEntrepreneurIdeas);
  }

  Future<void> _onGetEntrepreneurIdeas(
    GetEntrepreneurIdeas event,
    Emitter<EntrepreneurIdeasState> emit,
  ) async {
    emit(EntrepreneurIdeasLoading());
    try {
      final ideas = await entrepreneurService.getEntrepreneurIdeas();
      if (ideas != null && ideas.data.isNotEmpty) {
        emit(EntrepreneurIdeasLoaded(
          allIdeas: ideas.data,
          displayedIdeas: ideas.data,
        ));
      } else {
        emit(const EntrepreneurIdeasError('No ideas available'));
      }
    } catch (e) {
      emit(EntrepreneurIdeasError(e.toString()));
    }
  }

  void _onSortEntrepreneurIdeas(
    SortEntrepreneurIdeas event,
    Emitter<EntrepreneurIdeasState> emit,
  ) {
    final currentState = state;
    if (currentState is EntrepreneurIdeasLoaded) {
      final sortedIdeas = List<EntrepreneurIdea>.from(currentState.displayedIdeas);
      sortedIdeas.sort((a, b) => event.ascending
          ? a.title.compareTo(b.title)
          : b.title.compareTo(a.title));
      emit(EntrepreneurIdeasLoaded(
        allIdeas: currentState.allIdeas,
        displayedIdeas: sortedIdeas,
      ));
    }
  }

  void _onSearchEntrepreneurIdeas(
    SearchEntrepreneurIdeas event,
    Emitter<EntrepreneurIdeasState> emit,
  ) {
    final currentState = state;
    if (currentState is EntrepreneurIdeasLoaded) {
      final filteredIdeas = event.query.isEmpty
          ? currentState.allIdeas
          : currentState.allIdeas
              .where((idea) =>
                  idea.title.toLowerCase().contains(event.query.toLowerCase()))
              .toList();
      emit(EntrepreneurIdeasLoaded(
        allIdeas: currentState.allIdeas,
        displayedIdeas: filteredIdeas,
      ));
    }
  }
}