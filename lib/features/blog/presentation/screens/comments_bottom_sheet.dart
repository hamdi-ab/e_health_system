// File: lib/features/blog/presentation/screens/comments_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/blog_repositories.dart';
import '../../domain/entities/blog.dart';
import '../../domain/entities/blog_comment.dart';
import '../bloc/blog_bloc.dart';
import '../bloc/blog_event.dart';
import '../bloc/blog_state.dart';

class CommentsBottomSheet extends StatefulWidget {
  final Blog blog;

  const CommentsBottomSheet({super.key, required this.blog});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
  
  // Static method to show the comments as a bottom sheet
  static Future<void> show(BuildContext context, Blog blog) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true, // Allow dismissing by tapping outside
      useSafeArea: true,
      enableDrag: true,
      builder: (context) {
        // Get the repository from the parent context
        final blogRepository = context.read<BlogRepository>();
        
        // Pass it explicitly to the CommentsBottomSheet
        return BlocProvider(
          create: (context) => BlogBloc(
            repository: blogRepository,
          )..add(const LoadBlogs()),
          child: CommentsBottomSheet(blog: blog),
        );
      },
    );
  }
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final DraggableScrollableController _draggableController = DraggableScrollableController();
  late Blog _localBlog;
  
  @override
  void initState() {
    super.initState();
    _localBlog = widget.blog;
  }
  
  @override
  void dispose() {
    _commentController.dispose();
    _draggableController.dispose();
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
      blogId: _localBlog.blogId,
      senderId: currentUserId,
      commentText: commentText,
      blog: null,
      sender: null,
    );

    // Update local state immediately for instant UI feedback
    setState(() {
      // Create a new comments list with the new comment added
      final updatedComments = List<BlogComment>.from(_localBlog.blogComments)..add(newComment);
      
      // Update the local blog with the new comments list
      _localBlog = _localBlog.copyWith(blogComments: updatedComments);
    });

    // Use the bloc to add comment
    context.read<BlogBloc>().add(AddComment(
      blogId: _localBlog.blogId,
      comment: newComment,
    ));

    // Clear the input field.
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogsLoaded) {
          final updatedBlog = state.blogs.firstWhere(
            (b) => b.blogId == _localBlog.blogId,
            orElse: () => _localBlog,
          );
          if (updatedBlog != _localBlog) {
            setState(() {
              _localBlog = updatedBlog;
            });
          }
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.6, // Start at 60% of screen height
        minChildSize: 0.3, // Allow collapse to 30%
        maxChildSize: 0.9, // Allow expansion to 90%
        controller: _draggableController,
        builder: (context, scrollController) {
          return Material(
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Draggable handle
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  // Title bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Comments (${_localBlog.blogComments.length})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Comments list
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _localBlog.blogComments.length,
                      itemBuilder: (context, index) {
                        final comment = _localBlog.blogComments[index];
                        return CommentTile(comment: comment);
                      },
                    ),
                  ),
                  // Comment input
                  Container(
                    padding: EdgeInsets.only(
                      left: 16, 
                      right: 16, 
                      top: 8, 
                      bottom: MediaQuery.of(context).viewInsets.bottom + 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, -1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // User avatar (optional)
                        const CircleAvatar(
                          radius: 16,
                          child: Icon(Icons.person, size: 18),
                        ),
                        const SizedBox(width: 8),
                        // Comment text field
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              isDense: true,
                            ),
                            maxLines: 4,
                            minLines: 1,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Send button
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.blue),
                          onPressed: _submitComment,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Comment item widget
class CommentTile extends StatelessWidget {
  final BlogComment comment;
  
  const CommentTile({super.key, required this.comment});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          const CircleAvatar(
            radius: 16,
            child: Icon(Icons.person, size: 18),
          ),
          const SizedBox(width: 12),
          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: 'User ${comment.senderId} ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: comment.commentText),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Time and like/reply options
                Row(
                  children: [
                    Text(
                      '2h', // Placeholder - replace with actual time logic
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Like',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Reply',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Like button
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 14),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// Legacy CommentsScreen for backward compatibility
class CommentsScreen extends StatelessWidget {
  final Blog blog;

  const CommentsScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    // Show the bottom sheet immediately and close this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      CommentsBottomSheet.show(context, blog);
    });
    
    // Temporary screen while transitioning
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
} 