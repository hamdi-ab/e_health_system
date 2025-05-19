import 'package:equatable/equatable.dart';
import '../../domain/entities/blog.dart';
import '../../domain/entities/blog_comment.dart';

abstract class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object?> get props => [];
}

class LoadBlogs extends BlogEvent {
  const LoadBlogs();
}

class SearchBlogs extends BlogEvent {
  final String query;
  const SearchBlogs(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterBlogsByTag extends BlogEvent {
  final String tag;
  const FilterBlogsByTag(this.tag);

  @override
  List<Object?> get props => [tag];
}

class ClearSearch extends BlogEvent {
  const ClearSearch();
}

class AddBlog extends BlogEvent {
  final Blog blog;
  const AddBlog(this.blog);

  @override
  List<Object?> get props => [blog];
}

class AddComment extends BlogEvent {
  final String blogId;
  final BlogComment comment;
  const AddComment({
    required this.blogId,
    required this.comment,
  });

  @override
  List<Object?> get props => [blogId, comment];
}

class ToggleLike extends BlogEvent {
  final String blogId;
  final String userId;
  
  const ToggleLike({
    required this.blogId,
    required this.userId,
  });

  @override
  List<Object?> get props => [blogId, userId];
}
