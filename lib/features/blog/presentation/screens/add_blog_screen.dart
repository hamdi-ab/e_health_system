import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/blog.dart';
import '../bloc/blog_bloc.dart';
import '../bloc/blog_event.dart';

class AddBlogScreen extends StatefulWidget {
  const AddBlogScreen({super.key});

  @override
  _AddBlogScreenState createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields.
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _slugController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _slugController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _submitBlog() {
    if (_formKey.currentState!.validate()) {
      // Extract data from the form.
      final String title = _titleController.text.trim();
      final String summary = _summaryController.text.trim();
      final String content = _contentController.text.trim();
      final String slug = _slugController.text.trim();

      // Process tags: split, trim, and filter out empties.
      final List<String> tagNames = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      // Assign a dummy logged-in user id.
      const String currentUserId = 'doctor1';

      // Create a new blog instance.
      final newBlog = Blog(
        blogId: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        content: content,
        slug: slug,
        summary: summary,
        authorId: currentUserId,
        blogComments: [],
        blogLikes: [],
        // Convert each tag name into a BlogTag object.
        // blogTags: tagNames.map((tag) => BlogTag(tagName: tag)).toList(),
      );

      context.read<BlogBloc>().add(AddBlog(newBlog));

      // Show a confirmation SnackBar and navigate back.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Blog '$title' submitted!")),
      );
      Navigator.of(context).pop();
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Blog"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _titleController,
                label: "Title",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _summaryController,
                label: "Summary",
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a summary";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _contentController,
                label: "Content",
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter the blog content";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _slugController,
                label: "Slug",
                hint: "URL-friendly title",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a slug";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _tagsController,
                label: "Tags (comma separated)",
                maxLines: 1,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submitBlog,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
