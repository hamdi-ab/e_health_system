// File: lib/screens/comments_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/blog.dart';
import '../../domain/entities/blog_comment.dart';
import '../provider/blog_notifier.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final Blog blog; // The blog for which comments are shown

  const CommentsScreen({Key? key, required this.blog}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    final String commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    // Dummy logged-in user id; replace with real data in production.
    const String currentUserId = "user1";

    // Create a new BlogComment instance using your model.
    final newComment = BlogComment(
      blogCommentId: DateTime.now().millisecondsSinceEpoch.toString(),
      blogId: widget.blog.blogId,
      senderId: currentUserId,
      commentText: commentText,
      blog: null,   // Optionally set if you have a Blog instance.
      sender: null, // Optionally set if you have a User instance.
    );

    // Use the notifier's addComment method.
    ref
        .read(blogNotifierProvider.notifier)
        .addComment(widget.blog.blogId, newComment);

    // Clear the input field.
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for updated blogs.
    final blogNotifier = ref.watch(blogNotifierProvider);

    // Look for the updated blog data.
    final updatedBlog = blogNotifier.blogs.firstWhere(
          (b) => b.blogId == widget.blog.blogId,
      orElse: () => widget.blog,
    );

    return DraggableScrollableSheet(
        // Initial size is 50% of the screen height.
        initialChildSize: 1,
        // Users can swipe up to reveal up to 90% of the screen.
        maxChildSize: 1,
        // The minimum height when collapsed.
        minChildSize: 0.3,
        builder: (context, scrollController) {
          return Container(
            // Use a white background with rounded top corners.
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, -2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                // Drag handle.
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                // The comments list.
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: updatedBlog.blogComments.length,
                    itemBuilder: (context, index) {
                      final comment = updatedBlog.blogComments[index];
                      return ListTile(
                        title: Text(comment.commentText),
                        subtitle: Text("By ${comment.senderId}"),
                      );
                    },
                  ),
                ),
                // Input area for a new comment.
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: "Add a comment",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _submitComment,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
    );
  }
}
