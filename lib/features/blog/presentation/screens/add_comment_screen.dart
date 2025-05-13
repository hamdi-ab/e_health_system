// File: lib/screens/add_comment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/blog_comment.dart';
import '../provider/blog_notifier.dart';

class AddCommentScreen extends ConsumerStatefulWidget {
  final String blogId;
  const AddCommentScreen({Key? key, required this.blogId}) : super(key: key);

  @override
  _AddCommentScreenState createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends ConsumerState<AddCommentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_formKey.currentState!.validate()) {
      // Extract the entered comment text
      final String commentText = _commentController.text.trim();

      // Dummy current user id; in your app, fetch the actual logged-in user's ID.
      const String currentUserId = "user1";

      // Create a new BlogComment instance using your model structure.
      final newComment = BlogComment(
          blogCommentId: DateTime.now().millisecondsSinceEpoch.toString(),
          blogId: widget.blogId,
          senderId: currentUserId,
          commentText: commentText,
          blog: null,  // Optionally, set this if you have a Blog instance.
          sender: null // Optionally, set this if you have a User instance.
      );

      // Add the comment via the blog notifier.
      ref.read(blogNotifierProvider.notifier).addComment(widget.blogId, newComment);

      // Show a confirmation message and return.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Comment added!")),
      );
      Navigator.of(context).pop();
    }
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: _commentController,
      decoration: InputDecoration(
        labelText: "Enter your comment",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter a comment";
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Comment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitComment,
                child: const Text("Submit Comment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
