// File: lib/models/blog_tag.dart

import 'blog.dart';
import 'tag.dart';

class BlogTag {
  final String blogId;
  final String tagId;
  final Blog? blog;
  final Tag? tag;

  BlogTag({
    required this.blogId,
    required this.tagId,
    this.blog,
    this.tag,
  });

  factory BlogTag.fromJson(Map<String, dynamic> json) {
    return BlogTag(
      blogId: json['blogId'] as String,
      tagId: json['tagId'] as String,
      blog: json['blog'] != null ? Blog.fromJson(json['blog'] as Map<String, dynamic>) : null,
      tag: json['tag'] != null ? Tag.fromJson(json['tag'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blogId': blogId,
      'tagId': tagId,
      'blog': blog?.toJson(),
      'tag': tag?.toJson(),
    };
  }
}
