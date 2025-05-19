import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blog/data/repositories/blog_repositories.dart';
import '../../data/repositories/doctor_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final BlogRepository blogRepository;
  final DoctorRepository doctorRepository;
  Timer? _debounce;

  SearchBloc({
    required this.blogRepository,
    required this.doctorRepository,
  }) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchFilterChanged>(_onSearchFilterChanged);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    // Cancel any existing timer
    _debounce?.cancel();

    // Start a new timer
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      emit(SearchLoading());

      try {
        final doctors = await doctorRepository.searchDoctors(
          query: event.query,
          category: event.category,
        );

        final blogs = await blogRepository.searchBlogs(
          query: event.query,
        );

        emit(SearchResults(
          query: event.query,
          category: event.category,
          doctors: doctors,
          blogs: blogs,
        ));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });
  }

  Future<void> _onSearchFilterChanged(
    SearchFilterChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (state is SearchResults) {
      final currentState = state as SearchResults;
      try {
        final doctors = await doctorRepository.searchDoctors(
          query: currentState.query,
          category: currentState.category,
          filters: event.filters,
        );

        emit(currentState.copyWith(
          doctors: doctors,
          filters: event.filters,
        ));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    }
  }

  void _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) {
    _debounce?.cancel();
    emit(SearchInitial());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
