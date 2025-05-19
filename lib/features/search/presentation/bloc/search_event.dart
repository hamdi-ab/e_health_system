import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  final String? category;

  const SearchQueryChanged(this.query, {this.category});

  @override
  List<Object?> get props => [query, category];
}

class SearchFilterChanged extends SearchEvent {
  final Map<String, dynamic> filters;

  const SearchFilterChanged(this.filters);

  @override
  List<Object?> get props => [filters];
}

class ClearSearch extends SearchEvent {
  const ClearSearch();
} 