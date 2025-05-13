// File: lib/models/blog_like.dart

import '../../../../models/user.dart';
import 'blog.dart';

class BlogLike {
  final String blogLikeId;
  final String userId;
  final String blogId;
  final User? user;
  final Blog? blog;

  BlogLike({
    required this.blogLikeId,
    required this.userId,
    required this.blogId,
    this.user,
    this.blog,
  });

  factory BlogLike.fromJson(Map<String, dynamic> json) {
    return BlogLike(
      blogLikeId: json['blogLikeId'] as String,
      userId: json['userId'] as String,
      blogId: json['blogId'] as String,
      user: json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null,
      blog: json['blog'] != null ? Blog.fromJson(json['blog'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blogLikeId': blogLikeId,
      'userId': userId,
      'blogId': blogId,
      'user': user?.toJson(),
      'blog': blog?.toJson(),
    };
  }
}
