// File: lib/providers/blog_notifier.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/blog_repositories.dart';
import '../../domain/entities/blog.dart';
import '../../domain/entities/blog_comment.dart';
import '../../domain/entities/blog_like.dart';

class BlogNotifier extends ChangeNotifier {
  final BlogRepository _repository;

  List<Blog> _blogs = [];
  bool _isLoading = false;
  String? _error;

  BlogNotifier({required BlogRepository repository}) : _repository = repository;

  List<Blog> get blogs => _blogs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadBlogs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _blogs = await _repository.fetchBlogs();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Adds a new blog post.
  Future<void> addBlog(Blog newBlog) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate adding the blog (could be an API call in a real app).
      await _repository.addBlog(newBlog);
      // Optionally, you could reload all blogs:
      // _blogs = await _repository.fetchBlogs();
      // For our dummy implementation we'll simply add it locally:
      // _blogs.add(newBlog);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addComment(String blogId, BlogComment newComment) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Call the repository to add the comment.
      await _repository.addComment(blogId, newComment);

      // Instead of manually appending the comment, re-fetch the blogs.
      await loadBlogs();

      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleLike(String blogId, String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final blogIndex = _blogs.indexWhere((b) => b.blogId == blogId);
      if (blogIndex != -1) {
        final blog = _blogs[blogIndex];

        // Check if the user has already liked the blog.
        final existingLike = blog.blogLikes.firstWhere(
              (like) => like.userId == userId,
          orElse: () => BlogLike(blogLikeId: "", userId: "", blogId: ""),
        );

        if (existingLike.blogLikeId.isNotEmpty) {
          // Unlike the blog
          await _repository.removeLike(blogId, userId);
        } else {
          // Like the blog
          final newLike = BlogLike(
            blogLikeId: DateTime.now().millisecondsSinceEpoch.toString(),
            blogId: blogId,
            userId: userId,
          );
          await _repository.addLike(blogId, newLike);
        }
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}



final blogNotifierProvider = ChangeNotifierProvider<BlogNotifier>((ref) {
  return BlogNotifier(repository: BlogRepository());
});
