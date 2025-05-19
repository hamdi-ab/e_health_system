import 'package:equatable/equatable.dart';
import '../../../../models/doctor.dart';
import '../../../blog/domain/entities/blog.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchResults extends SearchState {
  final String query;
  final String? category;
  final List<Doctor> doctors;
  final List<Blog> blogs;
  final Map<String, dynamic>? filters;

  const SearchResults({
    required this.query,
    this.category,
    this.doctors = const [],
    this.blogs = const [],
    this.filters,
  });

  SearchResults copyWith({
    String? query,
    String? category,
    List<Doctor>? doctors,
    List<Blog>? blogs,
    Map<String, dynamic>? filters,
  }) {
    return SearchResults(
      query: query ?? this.query,
      category: category ?? this.category,
      doctors: doctors ?? this.doctors,
      blogs: blogs ?? this.blogs,
      filters: filters ?? this.filters,
    );
  }

  @override
  List<Object?> get props => [query, category, doctors, blogs, filters];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
} 