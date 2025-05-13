// File: lib/models/tag.dart

import 'blog_tag.dart';

class Tag {
  final String tagId;
  final String tagName;
  final List<BlogTag> blogTags;

  Tag({
    required this.tagId,
    required this.tagName,
    List<BlogTag>? blogTags,
  }) : blogTags = blogTags ?? [];

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      tagId: json['tagId'] as String,
      tagName: json['tagName'] as String,
      blogTags: json['blogTags'] != null
          ? (json['blogTags'] as List)
          .map((e) => BlogTag.fromJson(e as Map<String, dynamic>))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'tagName': tagName,
      'blogTags': blogTags.map((e) => e.toJson()).toList(),
    };
  }
}
