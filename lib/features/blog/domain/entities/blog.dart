// File: lib/models/blog.dart

import '../../../../models/user.dart';
import 'blog_comment.dart';
import 'blog_like.dart';
import 'blog_tag.dart';


class Blog {
  final String blogId;
  final String title;
  final String content;
  final String slug;
  final String summary;
  final String authorId;
  final User? author;
  final List<BlogComment> blogComments;
  final List<BlogLike> blogLikes;
  final List<BlogTag> blogTags;

  Blog({
    required this.blogId,
    required this.title,
    required this.content,
    required this.slug,
    required this.summary,
    required this.authorId,
    this.author,
    List<BlogComment>? blogComments,
    List<BlogLike>? blogLikes,
    List<BlogTag>? blogTags,
  })  : blogComments = blogComments ?? [],
        blogLikes = blogLikes ?? [],
        blogTags = blogTags ?? [];

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      blogId: json['blogId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      slug: json['slug'] as String,
      summary: json['summary'] as String,
      authorId: json['authorId'] as String,
      author: json['author'] != null
          ? User.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      blogComments: json['blogComments'] != null
          ? (json['blogComments'] as List)
          .map((x) => BlogComment.fromJson(x as Map<String, dynamic>))
          .toList()
          : [],
      blogLikes: json['blogLikes'] != null
          ? (json['blogLikes'] as List)
          .map((x) => BlogLike.fromJson(x as Map<String, dynamic>))
          .toList()
          : [],
      blogTags: json['blogTags'] != null
          ? (json['blogTags'] as List)
          .map((x) => BlogTag.fromJson(x as Map<String, dynamic>))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blogId': blogId,
      'title': title,
      'content': content,
      'slug': slug,
      'summary': summary,
      'authorId': authorId,
      'author': author?.toJson(),
      'blogComments': blogComments.map((x) => x.toJson()).toList(),
      'blogLikes': blogLikes.map((x) => x.toJson()).toList(),
      'blogTags': blogTags.map((x) => x.toJson()).toList(),
    };
  }
}
