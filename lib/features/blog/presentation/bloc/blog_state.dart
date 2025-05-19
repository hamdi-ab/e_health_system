import 'package:equatable/equatable.dart';
import '../../domain/entities/blog.dart';

abstract class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object?> get props => [];
}

class BlogInitial extends BlogState {}

class BlogLoading extends BlogState {}

class BlogsLoaded extends BlogState {
  final List<Blog> blogs;
  final String? searchQuery;
  final String? activeTag;
  final List<Blog> filteredBlogs;

  const BlogsLoaded({
    required this.blogs,
    this.searchQuery,
    this.activeTag,
    List<Blog>? filteredBlogs,
  }) : filteredBlogs = filteredBlogs ?? blogs;

  BlogsLoaded copyWith({
    List<Blog>? blogs,
    String? searchQuery,
    String? activeTag,
    List<Blog>? filteredBlogs,
  }) {
    return BlogsLoaded(
      blogs: blogs ?? this.blogs,
      searchQuery: searchQuery ?? this.searchQuery,
      activeTag: activeTag ?? this.activeTag,
      filteredBlogs: filteredBlogs ?? this.filteredBlogs,
    );
  }

  @override
  List<Object?> get props => [blogs, searchQuery, activeTag, filteredBlogs];
}

class BlogError extends BlogState {
  final String message;
  const BlogError(this.message);

  @override
  List<Object?> get props => [message];
}
