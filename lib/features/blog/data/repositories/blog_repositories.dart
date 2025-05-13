// File: lib/repositories/blog_repository.dart

import 'dart:async';
import '../../domain/entities/blog.dart';
import '../../domain/entities/blog_comment.dart';
import '../../domain/entities/blog_like.dart';

class BlogRepository {
  // Private mutable list simulating persistent storage.
  final List<Blog> _dummyBlogs = [
    Blog(
      blogId: '1',
      title: 'Heart Health: A Comprehensive Guide',
      content: 'Full article content here...',
      slug: 'heart-health',
      summary:
      'Caring for your heart is essential for a vibrant life. Discover tips and insights to maintain a healthy heart.',
      authorId: 'doctor1',
      blogComments: [], // Initially empty.
      blogLikes: [],
      blogTags: [],
    ),
    Blog(
      blogId: '2',
      title: 'Skincare in Dry Climates',
      content: 'Full article content here...',
      slug: 'skincare-dry-climates',
      summary:
      'Effective skincare routines that work in arid environments. Hydration and protection tips inside.',
      authorId: 'doctor2',
      blogComments: [],
      blogLikes: [],
      blogTags: [],
    ),
    // Add more dummy blogs as needed.
  ];

  Future<List<Blog>> fetchBlogs() async {
    await Future.delayed(const Duration(seconds: 1));
    return _dummyBlogs;
  }

  Future<void> addBlog(Blog newBlog) async {
    await Future.delayed(const Duration(seconds: 1));
    _dummyBlogs.add(newBlog);
  }

  // New: Add comment to a specific blog.
  Future<void> addComment(String blogId, BlogComment newComment) async {
    final blog = _dummyBlogs.firstWhere(
          (b) => b.blogId == blogId,
      orElse: () => throw Exception("Blog not found"),
    );
    blog.blogComments.add(newComment);
  }

  Future<void> addLike(String blogId, BlogLike newLike) async {
    await Future.delayed(const Duration(seconds: 0));
    final blog = _dummyBlogs.firstWhere(
          (b) => b.blogId == blogId,
      orElse: () => throw Exception('Blog not found'),
    );
    blog.blogLikes.add(newLike);
  }

  Future<void> removeLike(String blogId, String userId) async {
    await Future.delayed(const Duration(seconds: 0));
    final blog = _dummyBlogs.firstWhere(
          (b) => b.blogId == blogId,
      orElse: () => throw Exception('Blog not found'),
    );
    blog.blogLikes.removeWhere((like) => like.userId == userId);
  }

}
