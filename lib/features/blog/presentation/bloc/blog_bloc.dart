import 'package:e_health_system/features/blog/domain/entities/blog_like.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/blog_repositories.dart';
import '../../domain/entities/blog.dart';
import 'blog_event.dart';
import 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogRepository repository;

  BlogBloc({required this.repository}) : super(BlogInitial()) {
    on<LoadBlogs>(_onLoadBlogs);
    on<AddBlog>(_onAddBlog);
    on<AddComment>(_onAddComment);
    on<ToggleLike>(_onToggleLike);
    on<SearchBlogs>(_onSearchBlogs);
    on<FilterBlogsByTag>(_onFilterBlogsByTag);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadBlogs(
    LoadBlogs event,
    Emitter<BlogState> emit,
  ) async {
    emit(BlogLoading());
    try {
      final blogs = await repository.fetchBlogs();
      emit(BlogsLoaded(blogs: blogs));
    } catch (e) {
      emit(BlogError(e.toString()));
    }
  }

  Future<void> _onAddBlog(
    AddBlog event,
    Emitter<BlogState> emit,
  ) async {
    if (state is BlogsLoaded) {
      try {
        await repository.addBlog(event.blog);
        final blogs = await repository.fetchBlogs();
        emit(BlogsLoaded(blogs: blogs));
      } catch (e) {
        emit(BlogError(e.toString()));
      }
    }
  }

  Future<void> _onAddComment(
    AddComment event,
    Emitter<BlogState> emit,
  ) async {
    if (state is BlogsLoaded) {
      try {
        await repository.addComment(event.blogId, event.comment);
        final blogs = await repository.fetchBlogs();
        emit(BlogsLoaded(blogs: blogs));
      } catch (e) {
        emit(BlogError(e.toString()));
      }
    }
  }

  Future<void> _onToggleLike(
    ToggleLike event,
    Emitter<BlogState> emit,
  ) async {
    if (state is BlogsLoaded) {
      try {
        final currentState = state as BlogsLoaded;
        final blogIndex =
            currentState.blogs.indexWhere((b) => b.blogId == event.blogId);

        if (blogIndex == -1) return; // Blog not found

        final blog = currentState.blogs[blogIndex];
        final hasLiked =
            blog.blogLikes.any((like) => like.userId == event.userId);

        // Create a copy of the blogs list
        final List<Blog> updatedBlogs = List.from(currentState.blogs);

        // Create a copy of the blog with updated likes
        final updatedBlog = _updateBlogLikes(blog, event.userId, hasLiked);

        // Replace the blog in the list
        updatedBlogs[blogIndex] = updatedBlog;

        // Emit optimistic update
        emit(BlogsLoaded(
          blogs: updatedBlogs,
          searchQuery: currentState.searchQuery,
          activeTag: currentState.activeTag,
          filteredBlogs:
              currentState.searchQuery != null || currentState.activeTag != null
                  ? updatedBlogs.where((b) {
                      if (currentState.searchQuery != null &&
                          !(b.title.toLowerCase().contains(
                                  currentState.searchQuery!.toLowerCase()) ||
                              b.content.toLowerCase().contains(
                                  currentState.searchQuery!.toLowerCase()))) {
                        return false;
                      }
                      if (currentState.activeTag != null &&
                          !b.blogTags.contains(currentState.activeTag)) {
                        return false;
                      }
                      return true;
                    }).toList()
                  : updatedBlogs,
        ));

        // Update the repository
        if (hasLiked) {
          await repository.removeLike(event.blogId, event.userId);
        } else {
          await repository.addLike(
            event.blogId,
            BlogLike(
              blogLikeId: 'like_${DateTime.now().millisecondsSinceEpoch}',
              userId: event.userId,
              blogId: event.blogId,
            ),
          );
        }

        // Fetch updated blogs from repository
        final updatedBlogsFromRepo = await repository.fetchBlogs();
        emit(BlogsLoaded(
          blogs: updatedBlogsFromRepo,
          searchQuery: currentState.searchQuery,
          activeTag: currentState.activeTag,
          filteredBlogs:
              currentState.searchQuery != null || currentState.activeTag != null
                  ? updatedBlogsFromRepo.where((b) {
                      if (currentState.searchQuery != null &&
                          !(b.title.toLowerCase().contains(
                                  currentState.searchQuery!.toLowerCase()) ||
                              b.content.toLowerCase().contains(
                                  currentState.searchQuery!.toLowerCase()))) {
                        return false;
                      }
                      if (currentState.activeTag != null &&
                          !b.blogTags.contains(currentState.activeTag)) {
                        return false;
                      }
                      return true;
                    }).toList()
                  : updatedBlogsFromRepo,
        ));
      } catch (e) {
        emit(BlogError(e.toString()));
      }
    }
  }

  // Helper method to create a new blog with updated likes
  Blog _updateBlogLikes(Blog blog, String userId, bool hasLiked) {
    List<BlogLike> updatedLikes = List.from(blog.blogLikes);

    if (hasLiked) {
      // Remove like
      updatedLikes.removeWhere((like) => like.userId == userId);
    } else {
      // Add like
      updatedLikes.add(BlogLike(
        blogLikeId: 'temp_like_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        blogId: blog.blogId,
      ));
    }

    return Blog(
      blogId: blog.blogId,
      title: blog.title,
      content: blog.content,
      summary: blog.summary,
      slug: blog.slug,
      authorId: blog.authorId,
      author: blog.author,
      blogComments: blog.blogComments,
      blogLikes: updatedLikes,
      blogTags: blog.blogTags,
    );
  }

  Future<void> _onSearchBlogs(
    SearchBlogs event,
    Emitter<BlogState> emit,
  ) async {
    if (state is BlogsLoaded) {
      try {
        final currentState = state as BlogsLoaded;
        final searchResults = await repository.searchBlogs(query: event.query);
        emit(currentState.copyWith(
          searchQuery: event.query,
          filteredBlogs: searchResults,
        ));
      } catch (e) {
        emit(BlogError(e.toString()));
      }
    }
  }

  Future<void> _onFilterBlogsByTag(
    FilterBlogsByTag event,
    Emitter<BlogState> emit,
  ) async {
    if (state is BlogsLoaded) {
      try {
        final currentState = state as BlogsLoaded;
        final filteredBlogs = currentState.blogs.where((blog) {
          return blog.blogTags.contains(event.tag);
        }).toList();

        emit(currentState.copyWith(
          activeTag: event.tag,
          filteredBlogs: filteredBlogs,
        ));
      } catch (e) {
        emit(BlogError(e.toString()));
      }
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<BlogState> emit,
  ) async {
    if (state is BlogsLoaded) {
      final currentState = state as BlogsLoaded;
      emit(currentState.copyWith(
        searchQuery: null,
        activeTag: null,
        filteredBlogs: currentState.blogs,
      ));
    }
  }
}
