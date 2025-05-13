// File: lib/models/blog_comment.dart

import '../../../../models/user.dart';
import 'blog.dart';

class BlogComment {
  final String blogCommentId;
  final String blogId;
  final String senderId;
  final String commentText;
  final Blog? blog;
  final User? sender;

  BlogComment({
    required this.blogCommentId,
    required this.blogId,
    required this.senderId,
    required this.commentText,
    this.blog,
    this.sender,
  });

  factory BlogComment.fromJson(Map<String, dynamic> json) {
    return BlogComment(
      blogCommentId: json['blogCommentId'] as String,
      blogId: json['blogId'] as String,
      senderId: json['senderId'] as String,
      commentText: json['commentText'] as String,
      blog: json['blog'] != null
          ? Blog.fromJson(json['blog'] as Map<String, dynamic>)
          : null,
      sender: json['sender'] != null
          ? User.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blogCommentId': blogCommentId,
      'blogId': blogId,
      'senderId': senderId,
      'commentText': commentText,
      'blog': blog?.toJson(),
      'sender': sender?.toJson(),
    };
  }
}
