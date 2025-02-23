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
  }

  Future<void> _onGetEntrepreneurIdeas(
    GetEntrepreneurIdeas event,
    Emitter<EntrepreneurIdeasState> emit,
  ) async {
    emit(EntrepreneurIdeasLoading());
    try {
      final ideas = await entrepreneurService.getEntrepreneurIdeas();
      if (ideas != null) {
        emit(EntrepreneurIdeasLoaded(ideas));
      } else {
        emit(const EntrepreneurIdeasError('Failed to load ideas'));
      }
    } catch (e) {
      emit(EntrepreneurIdeasError(e.toString()));
    }
  }
} 